FROM        havengrc-docker.jfrog.io/node:8.4
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
RUN mkdir /code
WORKDIR /code
COPY ./webui/package.json /code
RUN npm install --quiet
