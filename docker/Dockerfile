FROM ruby:3.2.2-alpine3.18

RUN apk --no-cache add git build-base ruby-dev sqlite-dev postgresql-dev mysql-client mysql-dev && \
  gem install pg mysql2

ARG MIHARI_VERSION=5.3.1

RUN gem install mihari -v ${MIHARI_VERSION}

RUN apk del --purge git build-base ruby-dev

ENTRYPOINT ["mihari"]

CMD ["--help"]
