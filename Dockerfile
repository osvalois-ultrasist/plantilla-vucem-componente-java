FROM eclipse-temurin:21-jdk AS constructor
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline -B

COPY src/ ./src/
RUN ./mvnw package -DskipTests && \
    mkdir -p target/extracted && \
    java -Djarmode=layertools -jar target/*.jar extract --destination target/extracted

FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# Usuario no privilegiado
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser

# Metadatos de aplicación
ARG APP_VERSION=unknown
ARG BUILD_TIME=unknown
ARG GIT_COMMIT=unknown

# Certificados y herramientas básicas
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dumb-init \
    && rm -rf /var/lib/apt/lists/*

# Capas de aplicación
COPY --from=constructor /app/target/extracted/dependencies/ ./
COPY --from=constructor /app/target/extracted/spring-boot-loader/ ./
COPY --from=constructor /app/target/extracted/snapshot-dependencies/ ./
COPY --from=constructor /app/target/extracted/application/ ./

# Configuración del entorno
ENV TZ=America/Mexico_City
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# Seguridad
USER appuser
EXPOSE 8080
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.JarLauncher"]

# Verificación de salud
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/actuator/health/liveness || exit 1

# Etiquetas estándar
LABEL org.opencontainers.image.title="${COMPONENTE_NOMBRE}" \
      org.opencontainers.image.description="Componente ${COMPONENTE_DESCRIPCION} de VUCEM" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.created="${BUILD_TIME}" \
      org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.vendor="Gobierno de México" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      mx.gob.vucem.componente="${COMPONENTE_NOMBRE}" \
      mx.gob.vucem.area="${COMPONENTE_AREA}"