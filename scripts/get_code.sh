function mvn_clean() {
  #statements
  cd $1
  mvn clean package
  cd ..
}

git clone https://github.com/WASdev/sample.microservicebuilder.web-app
mvn_clean sample.microservicebuilder.web-app

git clone https://github.com/WASdev/sample.microservicebuilder.schedule
mvn_clean sample.microservicebuilder.schedule

git clone https://github.com/WASdev/sample.microservicebuilder.speaker
mvn_clean sample.microservicebuilder.speaker

git clone https://github.com/WASdev/sample.microservicebuilder.session
mvn_clean sample.microservicebuilder.session

git clone https://github.com/WASdev/sample.microservicebuilder.vote
cd sample.microservicebuilder.vote/
git checkout 4bd11a9bcdc7f445d7596141a034104938e08b22
mvn clean package
cd ..
