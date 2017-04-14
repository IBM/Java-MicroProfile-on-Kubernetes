#!/bin/bash

echo "Download Helm"
# Download helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

# Install Tiller using Helm
echo "Install Tiller"
helm init

#Add the repository
helm repo add mb http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/microservicebuilder/helm/

#Install Microservice Builder Fabric using Helm
helm install mb/fabric
