FROM node:latest

MAINTAINER Al Maline (copied from Lin Wen Chun)


RUN apt-get -q update
RUN apt-get -qy install git-core redis-server

RUN npm install -g hubot yo generator-hubot coffee-script ;\
    npm config -g set strict-ssl false

RUN adduser --disabled-password --gecos "" hubot; \
  echo "hubot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ADD ./certs /usr/local/share/ca-certificates/

RUN update-ca-certificates

ENV HOME /home/hubot
ENV NODE_TLS_REJECT_UNAUTHORIZED 0

USER hubot

WORKDIR /home/hubot

RUN yo hubot --owner "Al Maline <amaline@yahoo.com>" --name="eabot" --description="Slack chat-bot for EA" --adapter=slack

RUN npm install hubot-stackstorm ;\
    cat external-scripts.json |sed -e 's/]/,"hubot-stackstorm"]/' > tmp.json ;\
    cp tmp.json external-scripts.json ;\
    rm tmp.json

CMD HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN ./bin/hubot --adapter slack
