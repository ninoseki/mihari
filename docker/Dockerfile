FROM ruby:3.0.0-alpine3.13

RUN apk --no-cache add git build-base ruby-dev sqlite-dev postgresql-dev \
  && cd /tmp/ \
  && git clone https://github.com/ninoseki/mihari.git \
  && cd mihari \
  && gem build mihari.gemspec -o mihari.gem \
  && gem install mihari.gem \
  && rm -rf /tmp/mihari \
  && apk del --purge git build-base ruby-dev

ENTRYPOINT ["mihari"]

CMD ["--help"]