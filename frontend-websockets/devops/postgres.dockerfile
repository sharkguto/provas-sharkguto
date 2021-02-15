FROM postgres:10-alpine

RUN apk --update add curl net-tools tcpdump bind-tools jq && rm -rf /var/cache/apk/*

COPY devops/sql-scripts/wolverine.20200902.b317_system-schema.sql /docker-entrypoint-initdb.d/