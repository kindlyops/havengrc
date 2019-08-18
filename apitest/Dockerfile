FROM havengrc-docker.jfrog.io/ruby:2.5

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./Gemfile /usr/src/app
COPY ./Gemfile.lock /usr/src/app
COPY ./features/ /usr/src/app/features
COPY ./vendor /usr/src/app/vendor
RUN bundle install --local
CMD ["cucumber"]
