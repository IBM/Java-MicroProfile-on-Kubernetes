#!/bin/bash

function buildAndPushDockerImages {
  cd $1
  docker build -t registry.ng.bluemix.net/$1/microservice-speaker .
  docker push registry.ng.bluemix.net/$1/microservice-speaker .
  cd ..
}

if [ $# -ne 1 ]; then
    echo "usage: ./buildAndPushDockerImages.sh [bluemix container registry namespace]
    exit
fi

buildAndPushDockerImages sample.microservicebuilder.web-app
buildAndPushDockerImages sample.microservicebuilder.schedule
buildAndPushDockerImages sample.microservicebuilder.speaker
buildAndPushDockerImages sample.microservicebuilder.session
buildAndPushDockerImages sample.microservicebuilder.vote
