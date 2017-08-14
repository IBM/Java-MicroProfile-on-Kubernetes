#!/bin/bash

function buildAndPushDockerImages {
  cd $1
  docker build -t $2 .
  docker push $2
  cd ..
}

if [ $# -ne 1 ]; then
    echo "usage: ./build_and_push_docker_images.sh [Docker username]"
    exit
fi

buildAndPushDockerImages sample.microservicebuilder.web-app $1/microservice-webapp  
buildAndPushDockerImages sample.microservicebuilder.schedule $1/microservice-schedule
buildAndPushDockerImages sample.microservicebuilder.speaker $1/microservice-speaker
buildAndPushDockerImages sample.microservicebuilder.session $1/microservice-session
buildAndPushDockerImages sample.microservicebuilder.vote $1/microservice-vote
buildAndPushDockerImages nginx $1/nginx-server
