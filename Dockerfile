# Pull base image 
From tomcat:alpine

# Maintainer 
MAINTAINER "ravi.prakash60@gmail.com" 
RUN wget -O /usr/local/tomcat/webapps/launchstation04.war http://10.127.130.66:8040/artifactory/ravi_3149871/com/example/maven-project/webapp/1.0-SNAPSHOT/webapp-1.0-20200902.082058-17.war
EXPOSE 80
CMD /usr/local/tomcat/bin/catalina.sh run

