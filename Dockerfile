FROM debian:trixie-slim AS downloader

WORKDIR /sakila

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates tar \
    && wget -O sakila-db.tar.gz https://downloads.mysql.com/docs/sakila-db.tar.gz \
    && tar -xzf sakila-db.tar.gz \
    && cp sakila-db/sakila-schema.sql 01-sakila-schema.sql \
    && cp sakila-db/sakila-data.sql 02-sakila-data.sql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM mariadb:lts

ENV MARIADB_DATABASE=sakila

COPY --from=downloader /sakila/01-sakila-schema.sql /docker-entrypoint-initdb.d/
COPY --from=downloader /sakila/02-sakila-data.sql /docker-entrypoint-initdb.d/