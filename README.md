[![Build Status](https://travis-ci.org/IBM/Java-MicroProfile-on-Kubernetes.svg?branch=master)](https://travis-ci.org/IBM/Java-MicroProfile-on-Kubernetes)

# Deploy MicroProfile based Java microservices on Kubernetes.

*Read this in other languages: [한국어](README-ko.md)、[中国](README-cn.md).*

This code demonstrates the deployment of a Java based microservices application using MicroProfile and Microservice Builder on Kubernetes.

[MicroProfile](http://microprofile.io) is a baseline platform definition that optimizes Enterprise Java for a microservices architecture and delivers application portability across multiple MicroProfile runtimes. [Microservice Builder](https://developer.ibm.com/microservice-builder/) provides means to develop, test and deploy your microservices using a Java and MicroProfile based programming model and tools.

The Microservice Builder [sample application](https://github.com/WASdev/sample.microservicebuilder.docs) is a web application for managing a conference and is based on a number of discrete microservices. The front end is written in Angular; the backing microservices are in Java. All run on WebSphere Liberty, in Docker containers managed by Kubernetes.

![Flow](images/microprofile_kube_code.png)

## Included Components
- [Kubernetes Cluster](https://console.ng.bluemix.net/docs/containers/cs_ov.html#cs_ov)
- [MicroProfile](http://microprofile.io)
- [Microservice Builder](https://developer.ibm.com/microservice-builder/)
- [Bluemix DevOps Toolchain Service](https://console.ng.bluemix.net/catalog/services/continuous-delivery)
- [Bluemix Container Service](https://console.ng.bluemix.net/catalog/?taxonomyNavigation=apps&category=containers)

## Getting Started

### Kubernetes

In order to follow this guide you'll need a Kubernetes cluster. If you do not have access to an existing Kubernetes cluster then follow the instructions (in the link) for one of the following:

_Note: These instructions are tested on Kubernetes 1.7.3.  Your mileage may vary if you use a version much lower of higher than this._

* [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube) on your workstation
* [IBM Bluemix Container Service](https://github.com/IBM/container-journey-template#container-journey-template---creating-a-kubernetes-cluster) to deploy in an IBM managed cluster (free small cluster)
* [IBM Cloud Private - Community Edition](https://github.com/IBM/deploy-ibm-cloud-private/blob/master/README.md) for a self managed Kubernetes Cluster (in Vagrant, Softlayer or OpenStack)

After installing (or setting up your access to) Kubernetes ensure that you can access it by running the following and confirming you get version responses for both the Client and the Server:

```shell
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"7", GitVersion:"v1.7.3", GitCommit:"17d7182a7ccbb167074be7a87f0a68bd00d58d97", GitTreeState:"clean", BuildDate:"2017-08-31T09:14:02Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"7", GitVersion:"v1.7.3", GitCommit:"17d7182a7ccbb167074be7a87f0a68bd00d58d97", GitTreeState:"clean", BuildDate:"2017-09-18T20:30:29Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
```

### Helm

Some of the instructions utilize Helm to deploy applications. If you don't already
have it you should [Install Helm](https://github.com/kubernetes/helm) and then
initialize Helm on your Kubernetes cluster:

```shell
$ helm init
$HELM_HOME has been configured at /home/username/.helm.

Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster.
Happy Helming!
```

## Steps

### 1. Install Microservice Builder add-ons

First, clone our repository.
```shell
git clone https://github.com/IBM/Java-MicroProfile-on-Kubernetes.git
cd Java-MicroProfile-on-Kubernetes
```

Then, install the 2 add-ons:
* [Microservice Builder Fabric](https://www.ibm.com/support/knowledgecenter/SS5PWC/fabric_concept.html)
* [ELK Sample](https://github.com/WASdev/sample.microservicebuilder.helm.elk/blob/master/sample_elk_concept.md)

Install Microservice Builder Fabric:

```shell
$ helm repo add mb http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/microservicebuilder/helm/
$ helm install --name fabric mb/fabric
```

Install ELK:

```shell
$ helm repo add mb-sample https://wasdev.github.io/sample.microservicebuilder.helm.elk/charts
$ helm install --name sample-elk mb-sample/sample-elk
```

It will take up to 20 minutes to install the Microservice Builder Add-ons on your Kubernetes Cluster. If you want to [build the application](docs/build-instructions.md) yourself now would be a good time to do that. However for the sake of demonstration you can use the images that we've already built and uploaded to the journeycode docker repository.

Before you start deploying your application, make sure the Microservice Builder Add-ons are installed and running.

```shell
$ kubectl get pods --show-all=true
NAME                                    READY     STATUS      RESTARTS   AGE
fabric-zipkin-4284087195-d6s1t          1/1       Running     0          11m
key-retrieval-deploy-gkr9n              0/1       Completed   0          11m  # Make sure this job is completed
kibana-dashboard-deploy-rd0q5           1/1       Running     0          11m
sample-elk-sample-elk-461262821-rp1rl   3/3       Running     0          11m
secret-generator-deploy-bj1jj           0/1       Completed   0          11m  # Make sure this job is completed
```

### 2. Optional Step - Deploy Istio

If you want to deploy and use [Istio](https://istio.io/) to control traffic between the microservices you can deploy it with the following command:

```shell
$ kubectl create -f istio
namespace "istio-system" created
clusterrole "istio-pilot-istio-system" created
clusterrole "istio-initializer-istio-system" created
clusterrole "istio-mixer-istio-system" created
...
...
initializerconfiguration "istio-sidecar" created
```

### 3. Deploy Microservices

Now, deploy the microservices with the command:

```shell
$ kubectl create -f manifests
persistentvolume "cloudant-pv" created
persistentvolumeclaim "cloudant-pv-claim" created
service "cloudant-service" created
deployment "cloudant-db" created
...
...
```

_Note: this will deploy all of the kubernetes manifests in the [manifests/](manifests/) directory. Take some time to explore their contents to get an idea of the resources being used to deploy and expose the app._

After you have created all the services and deployments, wait for 10 to 15 minutes. You can check the status of your deployment on Kubernetes UI. Run 'kubectl proxy' and go to URL 'http://127.0.0.1:8001/ui' to check when the application containers are ready.

![Kubernetes Status Page](images/kube_ui.png)


After a few minutes you should be able to access the application. Part of our deployment is a [Kubernetes Ingress resource](manifests/deploy-ingress.yaml). If your Kubernetes cluster already has an ingress service such as IBM Cloud Private then you should be able to access the application with no further changes.

However if you are using minikube, or a Kubernetes cluster that does not have an ingress service you have one more step before you can access your cluster. On minikube you can do the following:

```shell
$ minikube addons enable ingress
ingress was successfully enabled
$ minikube ip
192.168.99.100
```

With an Ingress controller enabled you can access the app via the IP provided by minikube above.

Now you can use the link **http://[Public IP]** to access your application on browser and use **http://[Public IP]:30500** to access your Kibana for tracking the metrics.

Web application home page

![Web-app Home Page](images/ui1.png)

When you click on speaker name

![Speaker Info](images/ui2.png)

When you click on schedules link

![Schedule Info](images/ui3.png)

When you click on vote link

![Vote Info](images/ui4.png)

Kibana discover page

![Kibana](images/ui5.png)

## Troubleshooting

* If your microservice instance is not running properly, you may check the logs using
	* `kubectl logs <your-pod-name>`
* To delete a microservice
	* `kubectl delete -f manifests/<microservice-yaml-file>`
* To delete all microservices
	* `kubectl delete -f manifests`
* To delete istio
	* `kubectl delete -f istio`
* To delete Microservice Builder add-ons
  	* `helm delete --purge sample-elk`
  	* `helm delete --purge fabric`

## References
* This java microservices example is based on Kubernete's [Microprofile Showcase Application](https://github.com/WASdev/sample.microservicebuilder.docs).

# Privacy Notice

Sample Kubernetes Yaml file that includes this package may be configured to track deployments to [IBM Cloud](https://www.bluemix.net/) and other Kubernetes platforms. The following information is sent to a [Deployment Tracker](https://github.com/IBM/metrics-collector-service) service on each deployment:

* Kubernetes Cluster Provider(`IBM Cloud, Minikube, etc`)
* Kubernetes Machine ID
* Kubernetes Cluster ID (Only from IBM Cloud's cluster)
* Kubernetes Customer ID (Only from IBM Cloud's cluster)
* Environment variables in this Kubernetes Job.

This data is collected from the Kubernetes Job in the sample application's yaml file. This data is used by IBM to track metrics around deployments of sample applications to IBM Cloud to measure the usefulness of our examples so that we can continuously improve the content we offer to you. Only deployments of sample applications that include code to ping the Deployment Tracker service will be tracked.

## Disabling Deployment Tracking

Please comment out/remove the Metric Kubernetes Job portion at the end of the `manifests/deploy-cloudant.yaml` file.
