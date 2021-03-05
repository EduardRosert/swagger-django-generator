FROM python:3-slim-buster

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app

RUN set -ex \
    && pip install -r requirements.txt

ENTRYPOINT [ "python", "/app/swagger_django_generator/generator.py" ]
CMD [ "--help" ]