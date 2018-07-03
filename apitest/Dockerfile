FROM havengrc-docker.jfrog.io/ruby:2.5

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./apitest/* /usr/src/app/
RUN bundle install
CMD ["cucumber"]
