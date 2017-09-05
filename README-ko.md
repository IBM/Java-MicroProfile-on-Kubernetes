[![Build Status](https://travis-ci.org/IBM/Java-MicroProfile-on-Kubernetes.svg?branch=master)](https://travis-ci.org/IBM/Java-MicroProfile-on-Kubernetes)

# 쿠버네티스 클러스터에 MicroProfile 기반의 Java 마이크로서비스 구축하기

*다른 언어로 보기: [English](README.md).*

이 과정에서는 쿠버네티스 클러스터에서 MicroProfile과 Microservice Builder를 사용하여 Java 기반 마이크로서비스 애플리케이션을 구축하는 것을 보여줍니다.

[MicroProfile](http://microprofile.io) 은 Enterprise Java를 마이크로서비스 아키텍처에 최적화하고 다양한 MicroProfile 런타임 간 애플리케이션 이식성을 제공하는 베이스라인 플랫폼 정의입니다. [Microservice Builder](https://developer.ibm.com/microservice-builder/)는 Java 및 MicroProfile 기반의 프로그래밍 모델과 툴을 사용한 마이크로서비스를 개발, 테스트 및 구현할 수 있도록 기능을 제공합니다.

이 Microservice Builder [샘플 애플리케이션](https://github.com/WASdev/sample.microservicebuilder.docs)은 컨퍼런스 관리를 위한 웹 애플리케이션으로 다양한 이산형 마이크로서비스를 기반으로 합니다. 프론트엔드는 Angular로 작성되었고 백엔드 마이크로서비스는 Java로 작성되었습니다. 모두 쿠버네티스에 의해 관리되는 도커 컨테이너의 WebSphere Liberty에서 실행됩니다.

![Flow](images/microprofile_kube_code.png)

## 구성 요소
- [쿠버네티스 클러스터](https://console.ng.bluemix.net/docs/containers/cs_ov.html#cs_ov)
- [MicroProfile](http://microprofile.io)
- [Microservice Builder](https://developer.ibm.com/microservice-builder/)
- [Bluemix DevOps 툴체인 서비스](https://console.ng.bluemix.net/catalog/services/continuous-delivery)
- [Bluemix 컨테이너 서비스](https://console.ng.bluemix.net/catalog/?taxonomyNavigation=apps&category=containers)

## 전제 조건

* 로컬 테스트를 위해서는 [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube), 클라우드에 구축하려면 [IBM Bluemix Container 서비스](https://github.com/IBM/container-journey-template)를 이용하여 쿠버네티스 클러스터를 생성합니다. Minikube에 구축하려면 [여기](https://github.com/WASdev/sample.microservicebuilder.docs/blob/master/dev_test_local_minikube.md)의 지침을 따르십시오.
* 이 리포지토리의 코드는 정기적으로 [Bluemix 컨테이너 서비스에서 쿠버네티스 클러스터](https://console.ng.bluemix.net/docs/containers/cs_ov.html#cs_ov)를 대상으로 Travis를 사용하여 테스트합니다.
* 샘플 코드를 얻기 위해 Git 클라이언트를 설치합니다.


## Bluemix에서 쿠버네티스 클러스터에 구축
Bluemix에 곧바로 구축하려는 경우, 아래의 'Deploy to Bluemix' 버튼을 클릭하고 MicroProfile 샘플을 사용하여 Java 마이크로서비스를 구축하기 위한 Bluemix DevOps 서비스 툴체인 및 파이프라인을 생성합니다. 그렇지 않으면 [단계](#단계)로 바로 넘어가서 진행하시면 됩니다.

[![Create Toolchain](https://github.com/IBM/container-journey-template/blob/master/images/button.png)](https://console.ng.bluemix.net/devops/setup/deploy/?repository=https://github.com/IBM/Java-MicroProfile-on-Kubernetes)

툴체인 및 파이프라인을 완료하려면 [툴체인 지침](https://github.com/IBM/container-journey-template/blob/master/Toolchain_Instructions_new-ko.md)을 따르십시오.

## 단계

1. [Microservice Builder add-on 설치](#1-microservice-builder-add-on-설치)
2. [애플리케이션 코드 가져오기 및 빌드하기](#2-애플리케이션-코드-가져오기-및-빌드하기)
3. [애플리케이션 컨테이너 빌드하기](#3-애플리케이션-컨테이너-빌드하기)
4. [서비스 생성 및 구축](#4-서비스-생성-및-구축)

# 1. Microservice Builder add-on 설치

먼저, 본 리포지토리를 복제합니다.
```shell
git clone https://github.com/IBM/Java-MicroProfile-on-Kubernetes.git
cd Java-MicroProfile-on-Kubernetes
```

그런 다음, MicroProfile 컨퍼런스 애플리케이션에서 측정 항목 수집을 위한 [Microservice Builder Fabric](https://www.ibm.com/support/knowledgecenter/SS5PWC/fabric_concept.html) 및 [ELK Sample](https://github.com/WASdev/sample.microservicebuilder.helm.elk/blob/master/sample_elk_concept.md)이라는 2개의 add-on을 설치합니다. 
  
[Helm](https://github.com/kubernetes/helm)을 설치하고 Helm을 이용하여 쿠버네티스에 필수 add-on을 설치합니다.

```shell
helm init

#Install Fabric
helm repo add mb http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/microservicebuilder/helm/
helm install --name fabric mb/fabric

#Install ELK Sample
helm repo add mb-sample https://wasdev.github.io/sample.microservicebuilder.helm.elk/charts
helm install --name sample-elk mb-sample/sample-elk
```
쿠버네티스 클러스터에 Microservice Builder add-on을 설치하는데 대략 20분 정도가 소요됩니다. 그동안 애플리케이션 및 마이크로서비스 빌드를 시작합니다.

> 참고: 고유한 애플리케이션을 빌드하지 않는것이 아니라면, 기본으로 제공하는 Docker 이미지를 사용할 수 있으며 [4 단계](#4-서비스-생성-및-구축)로 이동하세요.

# 2. 애플리케이션 코드 가져오기 및 빌드하기

* [Maven](https://maven.apache.org/download.cgi)과  Java 8 JDK를 설치합니다.

> **참고:** 다음 단계를 위해, 아래와 같은 스크립트를 실행하여 코드를 가져와서 패키지를 빌드할 수 있습니다 
> ```shell
> ./scripts/get_code.sh
> ``` 


* 다음 프로젝트들을 `git clone` 후 `mvn clean package`를 실행합니다:
   * [Web-App](https://github.com/WASdev/sample.microservicebuilder.web-app)
   ```bash
      git clone https://github.com/WASdev/sample.microservicebuilder.web-app.git
  ```
   * [Schedule](https://github.com/WASdev/sample.microservicebuilder.schedule)
   ```bash
      git clone https://github.com/WASdev/sample.microservicebuilder.schedule.git
  ```
   * [Speaker](https://github.com/WASdev/sample.microservicebuilder.speaker)
   ```bash
      git clone https://github.com/WASdev/sample.microservicebuilder.speaker.git
  ```
   * [Session](https://github.com/WASdev/sample.microservicebuilder.session)
   ```bash
      git clone https://github.com/WASdev/sample.microservicebuilder.session.git
  ```
   * [Vote](https://github.com/WASdev/sample.microservicebuilder.vote)
   ```bash
      git clone https://github.com/WASdev/sample.microservicebuilder.vote.git
  ```

* 각 프로젝트의 ../sample.microservicebuilder.* 에서 `mvn clean package`를 실행합니다.


# 3. 애플리케이션 컨테이너 빌드하기

[Docker CLI](https://www.docker.com/community-edition#/download) 와 [Docker](https://docs.docker.com/engine/installation/) 엔진을 설치합니다.

다음 명령을 사용하여 마이크로서버 컨테이너를 빌드하고 푸시합니다.

> **참고:** 다음 단계를 위해, 아래와 같은 스크립트를 실행하여 이미지를 빌드하고 푸시할 수 있습니다 
> ```shell
> ./scripts/build_and_push_docker_images.sh <docker_namespace>
> ```

web-app 마이크로 서비스 컨테이너 빌드하기

```bash
docker build -t <docker_namespace>/microservice-webapp sample.microservicebuilder.web-app
docker push <docker_namespace>/microservice-webapp
```

vote 마이크로 서비스 컨테이너 빌드하기

```bash
docker build -t <docker_namespace>/microservice-vote sample.microservicebuilder.vote
docker push <docker_namespace>/microservice-vote-cloudant
```

schedule 마이크로 서비스 컨테이너 빌드하기

```bash
docker build -t <docker_namespace>/microservice-schedule sample.microservicebuilder.schedule
docker push <docker_namespace>/microservice-schedule
```

speaker 마이크로 서비스 컨테이너 빌드하기

```bash
docker build -t <docker_namespace>/microservice-speaker sample.microservicebuilder.speaker
docker push <docker_namespace>/microservice-speaker
```

session 마이크로 서비스 컨테이너 빌드하기 

```bash
docker build -t <docker_namespace>/microservice-session sample.microservicebuilder.session
docker push <docker_namespace>/microservice-session
```

nginx 컨트롤러 빌드하기

```bash
docker build -t <docker_namespace>/nginx-server nginx
docker push <docker_namespace>/nginx-server
```

# 4. 서비스 생성 및 구축

노드의 IP를 가져옵니다

```bash
$ kubectl get nodes
NAME             STATUS    AGE
10.76.193.96     Ready     23h
```

manifests 디렉토리의 모든 프로젝트에 대해 해당 구축 YAML 파일에 있는 이미지 이름을 새로운 빌드 이미지 이름으로 바꿉니다. 그리고 manifests 폴더 아래 deploy-nginx.yaml 파일에 있는 `SOURCE_IP` 환경 변수의 값을 노드의 IP로 변경합니다. 

또는, 다음과 같은 이미지의 이름과 모든 YAML 파일에 있는 SOURCE_IP 값을 변경하는 스크립트를 실행할 수 있습니다.

> 기본 이미지를 사용하려면, 스크립트를 실행할 때 *docker_username*으로 **journeycode**를 사용합니다.

```shell
./scripts/change_image_name_osx.sh <docker_username> #For Mac users
./scripts/change_image_name_linux.sh <docker_username> #For Linux users
```

애플리케이션을 배포하기 전에, Microservice Builder Add-on이 설치되어 실행 중인 상태여야 합니다.
```shell
$ kubectl get pods --show-all=true
NAME                                    READY     STATUS      RESTARTS   AGE
fabric-zipkin-4284087195-d6s1t          1/1       Running     0          11m
key-retrieval-deploy-gkr9n              0/1       Completed   0          11m  # Make sure this job is completed
kibana-dashboard-deploy-rd0q5           1/1       Running     0          11m 
sample-elk-sample-elk-461262821-rp1rl   3/3       Running     0          11m 
secret-generator-deploy-bj1jj           0/1       Completed   0          11m  # Make sure this job is completed
```

이제, `kubectl create -f manifests` 명령으로 마이크로 서비스를 배포합니다.

모든 서비스와 구축을 생성한 다음 10분 ~ 15분 정도 기다립니다. 쿠버네티스 UI에서 구축 상태를 확인할 수 있습니다. 'kubectl proxy'를 실행하고 URL 'http://127.0.0.1:8001/ui' 에서 애플리케이션 컨테이너가 언제 준비되는지 확인합니다.

![Kubernetes Status Page](images/kube_ui.png)


몇 분 후, 다음 명령을 사용하여 공용 IP 및 IP and NodePort 번호를 얻습니다.

```bash
$ bx cs workers <cluster_name>
OK
ID                                                 Public IP      Private IP     Machine Type   State    Status   
kube-hou02-pa817264f1244245d38c4de72fffd527ca-w1   184.173.1.55   10.76.193.96   free           normal   Ready 
$ kubectl get svc nginx-svc
NAME        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
nginx-svc   10.76.193.96   <nodes>       80:30056/TCP   11s
```

이제 **http://[Public IP]:30056** 링크를 통해 브라우저에서 애플리케이션에 엑세스할 수 있고, **http://[Public IP]:30500** 링크를 통해 측정 항목 추적을 위한 Kibana에 엑세스할 수 있습니다.

웹 애플리케이션 홈 페이지

![Web-app Home Page](images/ui1.png)

스피커 이름을 클릭하면 다음과 같이 보입니다

![Speaker Info](images/ui2.png)

스케줄 링크를 클릭하면 다음과 같이 보입니다

![Schedule Info](images/ui3.png)

vote 링크를 클릭하면 다음과 같이 보입니다

![Vote Info](images/ui4.png)

Kibana 디스커버 페이지

![Kibana](images/ui5.png)

## 문제 해결

* 마이크로서비스 인스턴스가 제대로 실행되지 않을 경우 다음 명령으로 로그를 확인할 수 있습니다
	* `kubectl logs <your-pod-name>`
* 마이크로서비스를 삭제하려면 다음 명령을 실행하십시오
	* `kubectl delete -f manifests/<microservice-yaml-file>`
* 모든 마이크로서비스를 삭제하려면 다음 명령을 실행하십시오
	* `kubectl delete -f manifests`
* Microservice Builder add-on들을 삭제하려면 다음 명령을 실행하십시오
  	* `helm delete --purge sample-elk`
  	* `helm delete --purge fabric`

## 참조
* 이 Java 마이크로서비스 예제는 쿠버네티스의 [Microprofile Showcase Application](https://github.com/WASdev/sample.microservicebuilder.docs)를 기반으로 합니다.

# License
[Apache 2.0](LICENSE)
