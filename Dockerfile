FROM ruby:3.4-alpine3.22

ARG VERSION=0.0.0

RUN apk --no-cache add build-base ruby-dev libpq-dev whois && \
  echo 'gem: --no-document' >> /usr/local/etc/gemrc && \
  gem install pg && \
  gem install mihari -v ${VERSION} && \
  apk del --purge build-base ruby-dev && \
  rm -rf /usr/local/bundle/cache/*

ENTRYPOINT ["mihari"]

CMD ["--help"]
