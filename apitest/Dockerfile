FROM havengrc-docker.jfrog.io/python:3
WORKDIR /usr/src/app
COPY ./apitest/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
CMD ["behave"]
