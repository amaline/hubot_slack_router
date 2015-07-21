FROM node:latest

MAINTAINER Al Maline (copied from Lin Wen Chun)


RUN apt-get -q update
RUN apt-get -qy install git-core redis-server

RUN npm install -g hubot yo generator-hubot coffee-script

RUN adduser --disabled-password --gecos "" hubot; \
  echo "hubot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ADD ./certs /usr/local/share/ca-certificates/

RUN update-ca-certificates

ENV HOME /home/hubot

USER hubot

WORKDIR /home/hubot

RUN yo hubot --owner "Al Maline <amaline@yahoo.com>" --name="eabot" --description="Slack chat-bot for EA" --adapter=slack

CMD HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN ./bin/hubot --adapter slack
