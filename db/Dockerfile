FROM postgis/postgis:13-3.4-alpine
COPY *.sql /docker-entrypoint-initdb.d/
COPY *.sql.gz /docker-entrypoint-initdb.d/
COPY ./university-db/*.sql.gz /docker-entrypoint-initdb.d/
COPY ./university-db/*.sql /docker-entrypoint-initdb.d/
USER postgres
