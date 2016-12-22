FROM ubuntu:16.04

RUN dpkg --add-architecture i386

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:wime/wine-builds && \
    apt-get update -y && \
    apt-get install -y wine-staging xvfb && \
    apt-get purge -y software-properties-common && \
    apt-get autoclean -y
