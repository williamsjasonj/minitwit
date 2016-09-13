FROM maven:3.3.9-jdk-8

ADD . /workspace

WORKDIR /workspace

RUN mvn package

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/workspace/target/minitwit.jar"]
