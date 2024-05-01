export IMAGE_NAME=$(basename "$PWD")
docker build -t $IMAGE_NAME .