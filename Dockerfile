# Etapa de build (compila o projeto)
FROM maven:3.8.6-openjdk-17 AS build
WORKDIR /app

# Copia o pom.xml e baixa dependências (melhora cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o código-fonte
COPY src ./src

# Compila o projeto e gera o JAR (sem rodar os testes)
RUN mvn clean package -DskipTests

# Etapa de execução (runtime)
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copia o JAR gerado da etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Define a porta que o Spring vai escutar
ENV PORT=8080

# Expõe a porta para o Render
EXPOSE 8080

# Comando para iniciar o app
ENTRYPOINT ["java", "-jar", "app.jar"]
