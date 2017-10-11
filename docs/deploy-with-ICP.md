# Deploy with IBM Cloud Private

Deploying MicroProfile with IBM Cloud Private essentially follows the same
pattern as the other platform options.

## Prerequisite

Follow the [instructions](https://github.com/IBM/deploy-ibm-cloud-private)
to either install a local instance of IBM Cloud private via Vagrant or a remote
instance at Softlayer. These instructions assume the former.

## Steps

Log into the ICP web UI. 

### 1. Install Microservices Builder fabric

From the navigation menu on the upper left, select App Center.  Scroll down
until you see 'microservicesbuilder/fabric', and click the Install Package
button below it.  Accept the license and Review and Install.

### 2. Install Microservice Builder ELK sample

From the navigation menu, select System and then the Repositories tab.
Click the Add Repository button all the way to the right then add:

     Repositry Name
     mb-sample

     URL
     https://wasdev.github.io/sample.microservicebuilder.helm.elk/charts

Click Add.
Back in the App Center, find mb-sample/sample-elk, click Install Package and
finally, click Install Package.

### 3. Deploy the sample application

Now you will need to access your Vagrant VM

```bash
$ vagrant ssh
```

From here, you can follow along with the instructions in the
[root](../README.md#2-get-and-build-the-application-code) of this repo to
deploy the sample application.
