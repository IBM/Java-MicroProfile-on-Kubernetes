# 1. Get and build the application code

* Install [Maven](https://maven.apache.org/download.cgi) and a Java 8 JDK.

> **Note:** For the following steps, you can get the code and build the packages by running
> ```shell
> ./scripts/get_code.sh
> ```


* `git clone` and `mvn clean package` the following projects:
   * [Web-App](https://github.com/IBM/sample.microservices.web-app)
   ```bash
      git clone https://github.com/IBM/sample.microservices.web-app.git
  ```
   * [Schedule](https://github.com/IBM/sample.microservices.schedule)
   ```bash
      git clone https://github.com/IBM/sample.microservices.schedule.git
  ```
   * [Speaker](https://github.com/IBM/sample.microservices.speaker)
   ```bash
      git clone https://github.com/IBM/sample.microservices.speaker.git
  ```
   * [Session](https://github.com/IBM/sample.microservices.session)
   ```bash
      git clone https://github.com/IBM/sample.microservices.session.git
  ```
   * [Vote](https://github.com/IBM/sample.microservices.vote)
   ```bash
      git clone https://github.com/IBM/sample.microservices.vote.git
  ```

* `mvn clean package` in each ../sample.microservices.* projects


# 2. Build application containers

Install [Docker CLI](https://www.docker.com/community-edition#/download) and a [Docker](https://docs.docker.com/engine/installation/) engine.

Use the following commands to build and push your microservice containers.

> **Note:** For the following steps, you can build and push the images by running (requires running get_code.sh in this directory first.)
> ```shell
> ./scripts/build_and_push_docker_images.sh <docker_namespace>
> ```

Build the web-app microservice container

```bash
docker build -t <docker_namespace>/microservice-ol-webapp sample.microservices.web-app
docker push <docker_namespace>/microservice-ol-webapp
```

Build the vote microservice container

```bash
docker build -t <docker_namespace>/microservice-ol-vote sample.microservices.vote
docker push <docker_namespace>/microservice-ol-vote
```

Build the schedule microservice container

```bash
docker build -t <docker_namespace>/microservice-ol-schedule sample.microservices.schedule
docker push <docker_namespace>/microservice-ol-schedule
```

Build the speaker microservice container

```bash
docker build -t <docker_namespace>/microservice-ol-speaker sample.microservices.speaker
docker push <docker_namespace>/microservice-ol-speaker
```

Build the session microservice container

```bash
docker build -t <docker_namespace>/microservice-ol-session sample.microservices.session
docker push <docker_namespace>/microservice-ol-session
```

Build the nginx controller

```bash
docker build -t <docker_namespace>/nginx-server nginx
docker push <docker_namespace>/nginx-server
```

# 3. Update the Kubernetes manifests:

Change the image name given in the respective deployment YAML files for all the projects in the manifests directory with the newly build image names.

Alternatively, you can run the following script to change the image name and SOURCE_IP for all your YAML files.

> If you want to use our default images, use **journeycode** as the *docker_username* when you run the script.

```shell
./scripts/change_image_name_osx.sh <docker_username> #For Mac users
./scripts/change_image_name_linux.sh <docker_username> #For Linux users
```
