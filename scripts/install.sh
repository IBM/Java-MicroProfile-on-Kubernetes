#!/bin/bash

function sleep_func() {
#statements
echo "sleeping for 3m"
sleep 3m
}

function run_tests() {
echo "Installing Helm"
install_helm

echo "Deploying Microservices"
kubectl create -f manifests

sleep_func

}

function install_helm(){
  echo "Download Helm"
  curl  https://storage.googleapis.com/kubernetes-helm/helm-v2.2.3-linux-amd64.tar.gz > helm-v2.2.3-linux-amd64.tar.gz
  tar -xf helm-v2.2.3-linux-amd64.tar.gz
  chmod +x ./linux-amd64
  sudo mv ./linux-amd64/helm /usr/local/bin/helm

  # Install Tiller using Helm
  echo "Install Tiller"
  helm init

  echo "Wait for helm to be ready..."
  sleep_func
}

function install_prereqs(){
  echo Install Microservice Builder Fabric using Helm
  helm repo add mb http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/microservicebuilder/helm/
  helm install mb/fabric

  ech Install Microservice Builder ELK Sample
  helm repo add mb-sample https://wasdev.github.io/sample.microservicebuilder.helm.elk/charts
  helm install mb-sample/sample-elk

  sleep 300
}

function exit_tests() {
  kubectl delete pv,pvc,jobs,svc,rc,deployments,pods -l app=microprofile-app
}


run_tests
exit_tests
