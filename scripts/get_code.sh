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
mvn_clean sample.microservicebuilder.vote
