FROM        cypress/base:8
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
WORKDIR     /home/node
ADD         . .
RUN         npm install --silent cypress
CMD         ["npx", "cypress", "run"]
