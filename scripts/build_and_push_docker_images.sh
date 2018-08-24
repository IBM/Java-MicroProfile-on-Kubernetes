#!/bin/bash

function buildAndPushDockerImages {
  cd "$1" || return
  docker build -t "$2" .
  docker push "$2"
  cd ..
}

if [ $# -ne 1 ]; then
    echo "usage: ./build_and_push_docker_images.sh [Docker username]"
    exit
fi

buildAndPushDockerImages sample.microservices.web-app "$1"/microservice-ol-webapp  
buildAndPushDockerImages sample.microservices.schedule "$1"/microservice-ol-schedule
buildAndPushDockerImages sample.microservices.speaker "$1"/microservice-ol-speaker
buildAndPushDockerImages sample.microservices.session "$1"/microservice-ol-session
buildAndPushDockerImages sample.microservices.vote "$1"/microservice-ol-vote
buildAndPushDockerImages nginx "$1"/nginx-server
