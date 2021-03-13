FROM ruby:3.0.0-alpine3.13

ENV MIHARI_VERSION 1.5.0

RUN apk --no-cache add build-base sqlite-dev postgresql-dev \
  && gem install mihari -v ${MIHARI_VERSION} \
  && apk del --purge build-base

ENTRYPOINT ["mihari"]

CMD ["--help"]
