#!/bin/bash

echo "Create Java microservices using MicroProfile"
IP_ADDR=$(bx cs workers "$CLUSTER_NAME" | grep Ready | awk '{ print $2 }')
if [ -z "$IP_ADDR" ]; then
  echo "$CLUSTER_NAME not created or workers not ready"
  exit 1
fi

echo -e "Configuring vars"
exp=$(bx cs cluster-config "$CLUSTER_NAME" | grep export)
if [ -z "$exp" ]; then
  echo "Cluster $CLUSTER_NAME not created or not ready."
  exit 1
fi
eval "$exp"

echo -e "Deleting previous version of Java microservices using MicroProfile if it exists"
kubectl delete svc,rc,deployments,pods -l app=microprofile-app

echo "Deploying Cloudant"
cd manifests || return
kubectl create -f deploy-cloudant.yaml

echo "Deploying speaker"
kubectl create -f deploy-speaker.yaml

echo "Deploying schedule"
kubectl create -f deploy-schedule.yaml

echo "Deploying vote"
kubectl create -f deploy-vote.yaml

echo "Deploying session"
kubectl create -f deploy-session.yaml

echo "Deploying webapp"
kubectl create -f deploy-webapp.yaml

echo -e "Sleeping for 3m to let the microservices finish configuring"
sleep 3m
PORT=$(kubectl get service nginx-svc | grep nginx-svc | sed 's/.*://g' | sed 's/\/.*//g')

echo ""
echo "View the Java microservices using MicroProfile at http://$IP_ADDR:$PORT"
