# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER "ravi.prakash60@gmail.com" 
COPY ./webapp.war /usr/local/tomcat/webapps

