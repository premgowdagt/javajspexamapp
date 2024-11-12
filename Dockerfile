# Use a Maven image to build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files to the container
COPY pom.xml .
COPY src ./src

# Build the application and package it as a WAR file
RUN mvn clean package

# Use the official Tomcat image as a base for running the application
FROM tomcat:9.0.73-jdk17

# Expose port 8100
EXPOSE 8100

# Copy the generated WAR file from the build stage to Tomcat's webapps directory
COPY --from=build /app/target/java-tomcat-maven-example.war /usr/local/tomcat/webapps/java-tomcat-maven-example.war

# Configure Tomcat to use port 8100
RUN sed -i 's/8080/8100/g' /usr/local/tomcat/conf/server.xml

# Start Tomcat
CMD ["catalina.sh", "run"]
