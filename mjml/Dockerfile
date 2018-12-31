FROM node:alpine

RUN apk --update add bash wget dpkg-dev \
	&& mkdir -p /home/mjml/ \
	&& mkdir -p /home/mjml/templates \
	&& mkdir -p /home/mjml/dist \
	&& npm init -y \
	&& npm install -g mjml
	
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home/mjml

ENTRYPOINT ["/entrypoint.sh"]

