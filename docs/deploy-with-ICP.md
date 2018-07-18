# Deploy with IBM Cloud Private

Deploying MicroProfile with IBM Cloud Private essentially follows the same
pattern as the other platform options.

## Prerequisite

Follow the [instructions](https://github.com/IBM/deploy-ibm-cloud-private)
to either install a local instance of IBM Cloud Private via Vagrant or a remote
instance at Softlayer. These instructions assume the former.

## Steps

Access your Vagrant VM

```bash
$ vagrant ssh
```

From here, you can follow along with the instructions in the
[root](../README.md#2-get-and-build-the-application-code) of this repo to
deploy the sample application.
