FROM maven:3.3.9-jdk-8-alpine

ADD . /usr/src/app
WORKDIR /usr/src/app

RUN mvn package

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/usr/src/app/target/minitwit.jar"]
