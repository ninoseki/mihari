FROM ruby:3.2.2-alpine3.18

RUN apk --no-cache add git build-base ruby-dev postgresql-dev && \
  gem install pg

ARG MIHARI_VERSION=5.7.0

RUN gem install mihari -v ${MIHARI_VERSION}

RUN apk del --purge git build-base ruby-dev

ENTRYPOINT ["mihari"]

CMD ["--help"]
