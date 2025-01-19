export CONTAINER_NAME=$(basename "$PWD")
docker run --rm --name $CONTAINER_NAME -d -p 80:80 $CONTAINER_NAME:latest