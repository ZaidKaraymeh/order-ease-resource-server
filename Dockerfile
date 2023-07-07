FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=railway
# ENV KC_DB_URL=postgresql://postgres:ctt9GZyZnfdFLGSPT2Tr@containers-us-west-66.railway.app:7787/railway
ENV KC_DB_USERNAME=postgres
ENV KC_DB_PASSWORD=ctt9GZyZnfdFLGSPT2Tr
ENV KC_HOSTNAME=containers-us-west-66.railway.app
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]