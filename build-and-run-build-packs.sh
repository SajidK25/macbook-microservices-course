#!/bin/bash

# Build all services
cd eureka && mvn spring-boot:build-image -DskipTests && cd ..
cd gateway && mvn spring-boot:build-image -DskipTests && cd ..
cd configserver && mvn spring-boot:build-image -DskipTests && cd ..
cd order && mvn spring-boot:build-image -DskipTests && cd ..
cd user && mvn spring-boot:build-image -DskipTests && cd ..
cd product && mvn spring-boot:build-image -DskipTests && cd ..
