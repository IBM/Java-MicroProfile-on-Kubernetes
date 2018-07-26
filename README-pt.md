[![Build Status](https://travis-ci.org/IBM/Java-MicroProfile-on-Kubernetes.svg?branch=master)](https://travis-ci.org/IBM/Java-MicroProfile-on-Kubernetes)
# Implemente microsserviços de Java baseados no MicroProfile em um cluster do Kubernetes
*Ler em outros idiomas: [한국어](README-ko.md).*
Este código demonstra a implementação de um aplicativo de microsserviços baseado em Java usando o MicroProfile e o Microservice Builder em um cluster do Kubernetes.
[MicroProfile](http://microprofile.io) é uma definição de plataforma de referência que otimiza o Enterprise Java para uma arquitetura de microsserviços e oferece portabilidade de aplicativo em vários tempos de execução do MicroProfile. [Microservice Builder](https://developer.ibm.com/microservice-builder/) oferece um meio para desenvolver, testar e implementar microsserviços usando um modelo e ferramentas de programação com base em Java e MicroProfile.
O [aplicativo de amostra](https://github.com/WASdev/sample.microservicebuilder.docs) do Microservice Builder é um aplicativo da web para gerenciamento de conferência e baseia-se em vários microsserviços distintos. O front-end é escrito em Angular; os microsserviços auxiliares, em Java. Tudo é executado no WebSphere Liberty, em contêineres do Docker gerenciados pelo Kubernetes.
![Flow](images/microprofile_kube_code.png)
## Componentes inclusos
- [Cluster Kubernetes](https://console.ng.bluemix.net/docs/containers/cs_ov.html#cs_ov)
- [MicroProfile](http://microprofile.io)
- [Microservice Builder](https://developer.ibm.com/microservice-builder/)
- [Bluemix DevOps Toolchain Service](https://console.ng.bluemix.net/catalog/services/continuous-delivery)
- [Bluemix Container Service](https://console.ng.bluemix.net/catalog/?taxonomyNavigation=apps&amp;category=containers)
## Pré-requisito
* Crie um cluster Kubernetes com [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube) para teste local ou com o [IBM Bluemix Container Service](https://github.com/IBM/container-journey-template) para implementação na nuvem. Para implementar no Minikube, siga as instruções [aqui](https://github.com/WASdev/sample.microservicebuilder.docs/blob/master/dev_test_local_minikube.md)
* O código neste repositório específico é testado regularmente com relação ao [Cluster Kubernetes do Bluemix Container Service](https://console.ng.bluemix.net/docs/containers/cs_ov.html#cs_ov) usando Travis.
* Instale um cliente Git para obter o código de amostra.

## Implementar no Cluster Kubernetes a partir do Bluemix
Se quiser implementar diretamente no Bluemix, clique no botão “Deploy to Bluemix” para criar uma cadeia de ferramentas de serviço do Bluemix DevOps e um canal para implementação dos microsserviços de Java usando a amostra do MicroProfile ou pule para [Etapas](#steps)
[![Create Toolchain](https://github.com/IBM/container-journey-template/blob/master/images/button.png)](https://console.ng.bluemix.net/devops/setup/deploy/?repository=https://github.com/IBM/Java-MicroProfile-on-Kubernetes)
Siga as [instruções da cadeia de ferramentas](https://github.com/IBM/container-journey-template/blob/master/Toolchain_Instructions_new.md) para concluir a cadeia de ferramentas e o canal.
## Etapas
1. [Instalar complementos do Microservice Builder](#1-install-microservice-builder-add-ons)
2. [Obter e desenvolver o código do aplicativo](#2-get-and-build-the-application-code)
3. [Desenvolver contêineres do aplicativo](#3-build-application-containers)
4. [Criar serviços e implementações](#4-create-services-and-deployments)

# 1. Instale os complementos do Microservice Builder em primeiro lugar e clone nosso repositório.
```shell
git clone https://github.com/IBM/Java-MicroProfile-on-Kubernetes.git cd Java-MicroProfile-on-Kubernetes
```
A seguir, instale os dois complementos [Microservice Builder Fabric](https://www.ibm.com/support/knowledgecenter/SS5PWC/fabric_concept.html) e [ELK Sample](https://github.com/WASdev/sample.microservicebuilder.helm.elk/blob/master/sample_elk_concept.md) para coletar métricas do aplicativo MicroProfile Conference. Instale o [Helm](https://github.com/kubernetes/helm) e utilize o Helm para instalar os complementos necessários no seu Kubernetes.
```shell
helm init

#Install Fabric
helm repo add mb http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/microservicebuilder/helm/
helm install --name fabric mb/fabric

#Install ELK Sample
helm repo add mb-sample https://wasdev.github.io/sample.microservicebuilder.helm.elk/charts
helm install --name sample-elk mb-sample/sample-elk
```
A instalação dos complementos do Microservice Builder no seu Cluster Kubernetes poderá levar até 20 minutos. Enquanto isso, vamos começar a desenvolver nossos aplicativos e microsserviços.  
Observação: Se não quiser desenvolver seu próprio aplicativo, você poderá usar nossas imagens padrão do Docker e avançar para a [etapa 4](#4-create-services-and-deployments).
# 2. Obter e desenvolver o código do aplicativo
* Instale o [Maven](https://maven.apache.org/download.cgi) e um JDK Java 8.  
**Observação:** para as próximas etapas, é possível obter o código e desenvolver os pacotes executando  
```shell
 ./scripts/get_code.sh  
```
* `git clone` e `mvn clean package` os projetos a seguir:
    * [Aplicativo da web](https://github.com/WASdev/sample.microservicebuilder.web-app)
    ```bash
    git clone https://github.com/WASdev/sample.microservicebuilder.web-app.git
    ```
    * [Planejamento](https://github.com/WASdev/sample.microservicebuilder.schedule)
    ```bash
    git clone https://github.com/WASdev/sample.microservicebuilder.schedule.git
    ```
    * [Falante](https://github.com/WASdev/sample.microservicebuilder.speaker)
    ```bash
    git clone https://github.com/WASdev/sample.microservicebuilder.speaker.git
    ```
    * [Sessão](https://github.com/WASdev/sample.microservicebuilder.session)
    ```bash
    git clone https://github.com/WASdev/sample.microservicebuilder.session.git
    ```
    * [Voto](https://github.com/WASdev/sample.microservicebuilder.vote)
    ```bash
    git clone https://github.com/WASdev/sample.microservicebuilder.vote.git
    ```
* `mvn clean package` em cada ../sample.microservicebuilder.* projetos

# 3. Desenvolver contêineres do aplicativo Instale [CLI do Docker](https://www.docker.com/community-edition#/download) e um mecanismo do [Docker](https://docs.docker.com/engine/installation/).

Use os comandos a seguir para desenvolver e realizar o push dos contêineres de microsserviço.  
**Observação:** para as próximas etapas, é possível desenvolver e realizar o push das imagens executando  
```shell
 ./scripts/build_and_push_docker_images.sh <docker_namespace>  
```
Desenvolva o contêiner de microsserviço do aplicativo da web
```bash
docker build -t <docker_namespace>/microservice-webapp sample.microservicebuilder.web-app
docker push <docker_namespace>/microservice-webapp
```
Desenvolva o contêiner de microsserviço de voto
```bash
docker build -t <docker_namespace>/microservice-vote sample.microservicebuilder.vote
docker push <docker_namespace>/microservice-vote-cloudant
```
Desenvolva o contêiner de microsserviço de planejamento
```bash
docker build -t <docker_namespace>/microservice-schedule sample.microservicebuilder.schedule
docker push <docker_namespace>/microservice-schedule
```
Desenvolva o contêiner de microsserviço de falante
```bash
docker build -t <docker_namespace>/microservice-speaker sample.microservicebuilder.speaker
docker push <docker_namespace>/microservice-speaker
```
Desenvolva o contêiner de microsserviço de sessão
```bash docker build -t <docker_namespace>/microservice-session sample.microservicebuilder.session
docker push <docker_namespace>/microservice-session
```
Desenvolva o controlador nginx
```bash
docker build -t <docker_namespace>/nginx-server nginx
docker push <docker_namespace>/nginx-server
```
# 4. Criar serviços e implementações
Obtenha o IP do nó
```bash
$ kubectl get nodes NAME STATUS AGE 10.76.193.96 Ready 23h
```
Altere o nome da imagem fornecido nos respectivos arquivos YAML de implementação para todos os projetos no diretório manifests com os nomes de imagens desenvolvidos recentemente. Em seguida, defina o valor da variável de ambiente `SOURCE_IP` presente no arquivo deploy-nginx.yaml encontrado na pasta manifests com o IP do nó. Como alternativa, é possível executar o script a seguir para alterar o nome da imagem e SOURCE_IP para todos os seus arquivos YAML.  Se quiser usar nossas imagens padrão, utilize **journeycode** como *docker_username* ao executar o script.
```shell
./scripts/change_image_name_osx.sh <docker_username> #For Mac users
./scripts/change_image_name_linux.sh <docker_username> #For Linux users
```
Antes de começar a implementar seu aplicativo, confira se os complementos do Microservice Builder estão instalados e em execução.
```shell
$ kubectl get pods --show-all=true
NAME                                  READY   STATUS      RESTARTS    AGE
fabric-zipkin-4284087195-d6s1t        1/1     Running     0           11m
key-retrieval-deploy-gkr9n            0/1     Completed   0           11m # Make sure this job is completed  
kibana-dashboard-deploy-rd0q5         1/1     Running     0           11m
sample-elk-sample-elk-461262821-rp1rl 3/3     Running     0           11m
secret-generator-deploy-bj1jj         0/1     Completed   0           11m # Make sure this job is completed
```
Agora, implemente o microsserviço com o comando `kubectl create -f manifests`.
Depois de criar todos os serviços e implementações, aguarde de 10 a 15 minutos. É possível verificar o status da implementação na interface com o usuário do Kubernetes. Execute “kubectl proxy” e acesse a URL “http://127.0.0.1:8001/ui” para verificar quando os contêineres do aplicativo estão prontos.
![Kubernetes Status Page](images/kube_ui.png)
Depois de alguns minutos, os comandos a seguir permitirão obter o número da porta do nó e do IP público.
```bash
$ bx cs workers <cluster_name>
OK
ID                                                  Public IP       Private IP      Machine Type    State   Status
kube-hou02-pa817264f1244245d38c4de72fffd527ca-w1    184.173.1.55    10.76.193.96    free            normal  Ready
$ kubectl get svc nginx-svc
NAME        CLUSTER-IP      EXTERNAL-IP     PORT(S)         AGE
nginx-svc   10.76.193.96    <nodes>         80:30056/TCP    11s
```
Agora, é possível usar o link **http://[Public IP]:30056** para acessar o aplicativo no navegador e usar **http://[Public IP]:30500** para acessar o Kibana para acompanhar as métricas.

Página inicial do aplicativo da web
![Web-app Home Page](images/ui1.png)
Ao clicar no nome do falante
![Speaker Info](images/ui2.png)
Ao clicar no link de planejamentos
![Schedule Info](images/ui3.png)
Ao clicar no link de voto
![Vote Info](images/ui4.png) Página de descoberta do Kibana
![Kibana](images/ui5.png)
 ## Resolução de problemas
 * Se sua instância do microsserviço não estiver sendo executada adequadamente, você poderá verificar os logs usando
    * `kubectl logs <your-pod-name>`
 * Para excluir um microsserviço
    * `kubectl delete -f manifests/<microservice-yaml-file>`
 * Para excluir todos os microsserviços 
    * `kubectl delete -f manifests`
 * Para excluir complementos do Microservice Builder
    * `helm delete --purge sample-elk`
    * `helm delete --purge fabric`

 ## Referências

 * Este exemplo de microsserviços de Java baseia-se no [aplicativo Microprofile Showcase](https://github.com/WASdev/sample.microservicebuilder.docs) do Kubernetes.

 # Licença
 [Apache 2.0](LICENÇA)
