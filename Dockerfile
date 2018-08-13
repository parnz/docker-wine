FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND teletype

RUN dpkg --add-architecture i386

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:wine/wine-builds && \
    apt-get update -y && \
    apt-get install -y wine-staging winetricks lynx xvfb mono-devel nuget apt-utils && \
    apt-get purge -y software-properties-common && \
    apt-get autoclean -y && \
    useradd -u 1001 -d /home/wine -m -s /bin/bash wine

USER wine

ENV HOME /home/wine
ENV WINEARCH win32
ENV WINEPREFIX /home/wine/.wine

WORKDIR /home/wine

RUN wine wineboot && xvfb-run winetricks -q dotnet40 corefonts

RUN echo "alias csc='wine /home/wine/.wine/drive_c/windows/Microsoft.NET/Framework/v4.0.30319/csc.exe'" >> ~/.bashrc

