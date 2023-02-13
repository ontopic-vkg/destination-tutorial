FROM postgis/postgis:13-3.1-alpine
COPY *.sql /docker-entrypoint-initdb.d/
COPY *.sql.gz /docker-entrypoint-initdb.d/
USER postgres
