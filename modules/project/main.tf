resource "digitalocean_project" "playground" {
  name        = "playground"
  description = "A project that organizes resources established for DigitalOcean feature exploration."
  purpose     = "Exploration"
  environment = "Development"
}