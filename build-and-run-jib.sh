#!/bin/bash

# Build all services
cd eureka && mvn clean compile jib:dockerBuild && cd ..
cd gateway && mvn clean compile jib:dockerBuild && cd ..
cd configserver && mvn clean compile jib:dockerBuild && cd ..
cd order && mvn clean compile jib:dockerBuild && cd ..
cd user && mvn clean compile jib:dockerBuild && cd ..
cd product && mvn clean compile jib:dockerBuild && cd ..
cd notification && mvn clean compile jib:dockerBuild && cd ..
