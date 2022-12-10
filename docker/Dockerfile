FROM ruby:3.1.3-alpine3.17

RUN apk --no-cache add git build-base ruby-dev sqlite-dev postgresql-dev mysql-client mysql-dev && \
  gem install pg mysql2

ARG MIHARI_VERSION=4.11.0

RUN gem install mihari -v ${MIHARI_VERSION}

RUN apk del --purge git build-base ruby-dev

ENTRYPOINT ["mihari"]

CMD ["--help"]
