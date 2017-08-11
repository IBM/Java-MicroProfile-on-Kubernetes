#!/bin/bash

function buildAndPushDockerImages {
  cd $1
  docker build -t $2 .
  docker push $2
  cd ..
}

if [ $# -ne 1 ]; then
    echo "usage: ./buildAndPushDockerImages.sh [bluemix container registry namespace]"
    exit
fi

buildAndPushDockerImages sample.microservicebuilder.web-app registry.ng.bluemix.net/$1/microservice-webapp  
buildAndPushDockerImages sample.microservicebuilder.schedule registry.ng.bluemix.net/$1/microservice-schedule
buildAndPushDockerImages sample.microservicebuilder.speaker registry.ng.bluemix.net/$1/microservice-speaker
buildAndPushDockerImages sample.microservicebuilder.session registry.ng.bluemix.net/$1/microservice-session
buildAndPushDockerImages sample.microservicebuilder.vote registry.ng.bluemix.net/$1/microservice-vote
buildAndPushDockerImages nginx registry.ng.bluemix.net/$1/nginx-server
