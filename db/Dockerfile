FROM --platform=$BUILDPLATFORM imresamu/postgis:18-3.6-alpine
COPY *.sql /docker-entrypoint-initdb.d/
COPY *.sql.gz /docker-entrypoint-initdb.d/
COPY ./university-db/*.sql.gz /docker-entrypoint-initdb.d/
COPY ./university-db/*.sql /docker-entrypoint-initdb.d/
USER postgres
