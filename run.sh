#!/bin/bash

image_name="open-webui"
container_name="open-webui"
host_port=3000
container_port=8080

docker build -t "$image_name" .
docker stop "$container_name" &>/dev/null || true
docker rm "$container_name" &>/dev/null || true

docker run -d -p "$host_port":"$container_port" \
    --add-host=host.docker.internal:host-gateway \
    -v "${image_name}:/app/backend/data" \
    --name "$container_name" \
    --restart always \
    "$image_name"

docker image prune -f

# Function to save a running container as an image
save_container_as_image() {
  local container_name=$1
  local new_image_name=$2
  local new_tag=$3

  echo "Saving container $container_name as image $new_image_name:$new_tag"
  docker commit $container_name $new_image_name:$new_tag
  echo "Container saved as image $new_image_name:$new_tag"
}

# Function to push the image to Docker Hub
push_to_dockerhub() {
  local image_name=$1
  local tag=$2
  local docker_username=$3

  echo "Pushing $image_name:$tag to Docker Hub as $docker_username/$image_name:$tag"
  docker tag $image_name:$tag $docker_username/$image_name:$tag
  docker push $docker_username/$image_name:$tag
}

# Function to push the image to GitHub Container Registry
push_to_ghcr() {
  local image_name=$1
  local tag=$2
  local github_username=$3

  echo "Pushing $image_name:$tag to GitHub Container Registry as ghcr.io/$github_username/$image_name:$tag"
  docker tag $image_name:$tag ghcr.io/$github_username/$image_name:$tag
  docker push ghcr.io/$github_username/$image_name:$tag
}

# Usage examples (uncomment and modify as needed):
# 
# # Save running container as a new image with tag 'latest'
# save_container_as_image $container_name $image_name "latest"
# 
# # Push to Docker Hub (replace 'yourusername' with your Docker Hub username)
# push_to_dockerhub $image_name "latest" "yourusername"
# 
# # Push to GitHub Container Registry (replace 'yourusername' with your GitHub username)
# # Note: Make sure you're authenticated to GHCR first
# push_to_ghcr $image_name "latest" "yourusername"
#
# # To authenticate to GitHub Container Registry:
# # export CR_PAT=YOUR_GITHUB_PERSONAL_ACCESS_TOKEN
# # echo $CR_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
