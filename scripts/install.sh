#!/bin/bash

function sleep_func() {
#statements
echo "sleeping for 3m"
sleep 3m
}

function run_tests() {
  echo "Deploying Microservices"
  cp templates/deploy-ingress.mini manifests/deploy-ingress.yaml
  kubectl create -f manifests

  sleep_func
}

function exit_tests() {
  kubectl delete pv,pvc,jobs,svc,rc,deployments,pods -l app=microprofile-app
}


run_tests
exit_tests
