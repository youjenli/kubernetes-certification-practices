provider "aws" {
  region = var.region
}

# https://github.com/hashicorp-education/learn-terraform-provision-eks-cluster

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "education-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = local.cluster_name
  cluster_version = "1.31"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups

    ami_type = "AL2023_ARM_64_STANDARD"
    # https://github.com/awslabs/amazon-eks-ami/releases
    instance_types = ["c8g.xlarge", "c7g.xlarge", "c6g.xlarge"]

    # Determines the instance type of launch templates and the EKS node group
    # Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT
    capacity_type = "SPOT"
    
    # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/modules/eks-managed-node-group/main.tf#L189
    # instance_market_options = {
    #   market_type = "spot"
    #   spot_instance_type = "persistent" # "one-time" or "persistent"
    # }
    # IMPORTANT: The launch template configuration unfortunately cannot include a reference to RequestSpotInstances
    # https://github.com/hashicorp/terraform-provider-aws/issues/15118

    min_size     = 1
    max_size     = 2
    # This value is ignored after the initial creation
    # https://github.com/bryantbiggs/eks-desired-size-hack
    desired_size = 1
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      # This is not required - demonstrates how to pass additional configuration to nodeadm
      # Ref https://awslabs.github.io/amazon-eks-ami/nodeadm/doc/api/
      # cloudinit_pre_nodeadm = [
      #   {
      #     content_type = "application/node.eks.aws"
      #     content      = <<-EOT
      #       ---
      #       apiVersion: node.eks.aws/v1alpha1
      #       kind: NodeConfig
      #       spec:
      #         kubelet:
      #           config:
      #             shutdownGracePeriod: 30s
      #             featureGates:
      #               DisableKubeletCloudCredentialProviders: true
      #     EOT
      #   }
      # ]
    }

    two = {
      name = "node-group-2"
    }
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/examples/iam-assumable-role-with-oidc/main.tf
module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}