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
echo "1" | bx login -a https://api.ng.bluemix.net --apikey $API_KEY
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
echo "Creating Deployments"
git clone https://github.com/IBM/kubernetes-container-service-java-microprofile-deployment.git
cd kubernetes-container-service-java-microprofile-deployment

echo "Remnoving deployments"
kubectl delete -f manifests

echo "Installing Helm"
sh ./install_helm.sh

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

function exit_tests() {
kubectl delete -f manifests
echo "Deployments Removed"
}


install_bluemix_cli
bluemix_auth
#cluster_setup
run_tests
exit_tests
