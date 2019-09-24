FROM ruby:2.6

RUN cd /tmp/ \
  && git clone https://github.com/ninoseki/mihari.git \
  && cd mihari \
  && gem build mihari.gemspec -o mihari.gem \
  && gem install mihari.gem

ENTRYPOINT ["mihari"]

CMD ["--help"]
