FROM ruby:3.2.2-alpine3.18

ARG MIHARI_VERSION=6.0.0

RUN apk --no-cache add git build-base ruby-dev postgresql-dev && \
  gem install pg && \
  gem install mihari -v ${MIHARI_VERSION} && \
  apk del --purge git build-base ruby-dev && \
  rm -rf /usr/local/bundle/cache/*

ENTRYPOINT ["mihari"]

CMD ["--help"]
