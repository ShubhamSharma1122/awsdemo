# Stage 1: build the application
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: run the application
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 9090

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
