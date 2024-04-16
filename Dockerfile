FROM openjdk:21
#ADD target/Spring-docker.jar Spring-docker.jar
WORKDIR /
COPY build/ /build/
EXPOSE 8080
ENTRYPOINT ["java","-jar","/build/libs/spring-boot-docker-0.0.1-SNAPSHOT.jar"]
