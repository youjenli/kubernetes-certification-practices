export IMAGE_NAME=$(basename "$PWD")
export DO_IMAGE_TAG=$REGISTRY_ENDPOINT/$IMAGE_NAME:latest
docker tag $IMAGE_NAME:latest $DO_IMAGE_TAG
docker push $DO_IMAGE_TAG
docker image rm $DO_IMAGE_TAG