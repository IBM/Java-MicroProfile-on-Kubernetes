#!/bin/bash

function sleep_func() {
#statements
echo -e "sleeping for 3m"
sleep 3m
}

function install_helm(){
  echo -e "Download Helm"
  curl  https://storage.googleapis.com/kubernetes-helm/helm-v2.2.3-linux-amd64.tar.gz > helm-v2.2.3-linux-amd64.tar.gz
  tar -xf helm-v2.2.3-linux-amd64.tar.gz
  chmod +x ./linux-amd64
  sudo mv ./linux-amd64/helm /usr/local/bin/helm

  # Install Tiller using Helm
  echo -e "Install Tiller"
  helm init

  #Add the repository
  helm repo add mb http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/microservicebuilder/helm/

  #Install Microservice Builder Fabric using Helm
  helm install mb/fabric
}


echo "Create Java microservices using MicroProfile"
IP_ADDR=$(bx cs workers $CLUSTER_NAME | grep deployed | awk '{ print $2 }')
if [ -z $IP_ADDR ]; then
  echo "$CLUSTER_NAME not created or workers not ready"
  exit 1
fi

echo -e "Configuring vars"
exp=$(bx cs cluster-config $CLUSTER_NAME | grep export)
if [ $? -ne 0 ]; then
  echo "Cluster $CLUSTER_NAME not created or not ready."
  exit 1
fi
eval "$exp"

echo -e "Deleting previous version of Java microservices using MicroProfile if it exists"
kubectl delete svc,rc,deployments,pods -l app=microprofile-app

kuber=$(kubectl get pods -l app=microprofile-app)
if [ ${#kuber} -ne 0 ]; then
	sleep 120s
fi

echo -e "Installing Helm"
install_helm

echo "Deploying speaker"
cd kubernetes-container-service-java-microprofile-deployment/manifests
kubectl create -f deploy-speaker.yaml
sleep_func

echo "Deploying schedule"
kubectl create -f deploy-schedule.yaml
sleep_func

echo "Deploying vote"
kubectl create -f deploy-vote.yaml
sleep_func

echo "Deploying session"
kubectl create -f deploy-session.yaml
sleep_func

echo "Deploying webapp"
kubectl create -f deploy-webapp.yaml
sleep_func
echo "Deploying nginx"

sed -i "s/xx.xx.xx.xx/$IP_ADDR/g" deploy-nginx.yaml
kubectl create -f deploy-nginx.yaml
sleep_func


PORT=$(kubectl get service nginx-svc | grep nginx-svc | sed 's/.*://g' | sed 's/\/.*//g')

echo ""
echo "View the Java microservices using MicroProfile at http://$IP_ADDR:$PORT"
