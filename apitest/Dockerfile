FROM havengrc-docker.jfrog.io/ruby:2.4

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./apitest/Gemfile /usr/src/app
COPY ./apitest/Gemfile.lock /usr/src/app
RUN bundle install
CMD ["cucumber"]
