#!/bin/bash

container_name="wes-mcpo"
image_name="wes-mcpo"
tag="latest"

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

# Save the container as an image
save_container_as_image $container_name $image_name $tag

# Uncomment and modify these lines if you want to push to registries
# docker_username="your-dockerhub-username"
# github_username="your-github-username"
# push_to_dockerhub $image_name $tag $docker_username
# push_to_ghcr $image_name $tag $github_username

echo "Image saved as $image_name:$tag"
echo "To push to Docker Hub: push_to_dockerhub $image_name $tag your-dockerhub-username"
echo "To push to GitHub Container Registry: push_to_ghcr $image_name $tag your-github-username"
