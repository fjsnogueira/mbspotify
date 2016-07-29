FROM python:2.7.12

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                       build-essential \
                       libffi-dev \
                       libssl-dev \
                       libxml2-dev \
                       libxslt1-dev

# PostgreSQL client
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
ENV PG_MAJOR 9.5
ENV PG_VERSION 9.5.3-1.pgdg80+1
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update \
    && apt-get install -y postgresql-client-$PG_MAJOR=$PG_VERSION \
    && rm -rf /var/lib/apt/lists/*
# Specifying password so that client doesn't ask scripts for it...
ENV PGPASSWORD "mbspotify"

RUN mkdir /code
WORKDIR /code

# Python dependencies
COPY requirements.txt /code/
RUN pip install -r requirements.txt

COPY . /code/

CMD python3 server.py