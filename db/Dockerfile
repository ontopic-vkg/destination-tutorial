FROM --platform=$BUILDPLATFORM postgis/postgis:13-3.5-alpine
COPY *.sql /docker-entrypoint-initdb.d/
COPY *.sql.gz /docker-entrypoint-initdb.d/
COPY ./university-db/*.sql.gz /docker-entrypoint-initdb.d/
USER postgres
