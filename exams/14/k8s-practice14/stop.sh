export CONTAINER_NAME=$(basename "$PWD")
docker container stop $CONTAINER_NAME
docker image rm $CONTAINER_NAME