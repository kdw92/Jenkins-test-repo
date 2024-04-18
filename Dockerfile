FROM openjdk:21
WORKDIR /
ADD build /build
EXPOSE 8080
ENTRYPOINT ["java","-jar","/build/libs/spring-boot-docker-0.0.1-SNAPSHOT.jar"]
