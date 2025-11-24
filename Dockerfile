FROM ruby:3.4-alpine3.22

ENV APP_HOME="/app"

WORKDIR ${APP_HOME}

RUN apk --no-cache add \
  build-base \
  git \
  libpq \
  libpq-dev \
  mariadb-dev \
  mysql-client \
  mysql-dev \
  nodejs \
  npm \
  ruby-dev \
  whois

COPY . ${APP_HOME}

RUN gem install bundler -v 2.5.13 && \
  bundle install && \
  bundle exec rake build:swagger && \
  npm --prefix frontend install && \
  npm --prefix frontend run docs && \
  npm --prefix frontend run build-only && \
  rm -rf lib/mihari/web/public && \
  mkdir -p lib/mihari/web/public && \
  cp -r frontend/dist/* lib/mihari/web/public && \
  rm -rf frontend/node_modules frontend/dist && \
  apk del build-base ruby-dev libpq-dev && \
  rm -rf /usr/local/bundle/cache/*

ENTRYPOINT ["bundle", "exec", "exe/mihari"]

CMD ["--help"]
