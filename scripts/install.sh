#!/bin/sh

function install_bluemix_cli() {
#statements
echo "Installing Bluemix cli"
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
sudo mv cf /usr/local/bin
sudo curl -o /usr/share/bash-completion/completions/cf https://raw.githubusercontent.com/cloudfoundry/cli/master/ci/installers/completion/cf
cf --version
curl -L public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/Bluemix_CLI_0.5.1_amd64.tar.gz > Bluemix_CLI.tar.gz
tar -xvf Bluemix_CLI.tar.gz
cd Bluemix_CLI
sudo ./install_bluemix_cli
}

function bluemix_auth() {
echo "Authenticating with Bluemix"
echo "y" | bx login -a https://api.ng.bluemix.net --apikey $API_KEY
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
bx plugin install container-service -r Bluemix
echo "Installing kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
}

function sleep_func() {
#statements
echo "sleeping for 3m"
sleep 3m
}

function run_tests() {
bx cs workers sample
$(bx cs cluster-config sample | grep -v "Downloading" | grep -v "OK" | grep -v "The")
echo "Creating Deployments"
git clone https://github.com/IBM/kubernetes-container-service-java-microprofile-deployment.git
cd kubernetes-container-service-java-microprofile-deployment

echo "Remnoving deployments"
kubectl delete -f manifests

echo "Installing Helm"
install_helm

echo "Deploying speaker"
cd manifests
kubectl create -f deploy_speaker.yaml
sleep_func

echo "Deploying schedule"
kubectl create -f deploy_schedule.yaml
sleep_func

echo "Deploying vote"
kubectl create -f deploy_vote.yaml
sleep_func

echo "Deploying session"
kubectl create -f deploy_session.yaml
sleep_func

echo "Deploying webapp"
kubectl create -f deploy_webapp.yaml
sleep_func

sh ./deploy_config.sh
echo "Deploying nginx"
kubectl create -f deploy_nginx.yaml
sleep_func

}

function install_helm(){
  echo "Download Helm"
  curl  https://kubernetes-helm.storage.googleapis.com/helm-v2.3.0-linux-amd64.tar.gz > helm-v2.3.0-linux-amd64.tar.gz
  tar -xf helm-v2.3.0-linux-amd64.tar.gz
  chmod +x ./linux-amd64
  sudo mv ./linux-amd64/helm /usr/local/bin/helm

  # Download helm
  #curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
  #chmod 700 get_helm.sh
  #./get_helm.sh

  # Install Tiller using Helm
  echo "Install Tiller"
  helm init

  #Add the repository
  helm repo add mb http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/microservicebuilder/helm/

  #Install Microservice Builder Fabric using Helm
  helm install mb/fabric
}

function exit_tests() {
kubectl delete -f manifests
echo "Deployments Removed"
}


install_bluemix_cli
bluemix_auth
#cluster_setup
run_tests
exit_tests
