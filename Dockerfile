FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND teletype

RUN dpkg --add-architecture i386

USER root

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:wine/wine-builds && \
    apt-get update -y && \
    apt-get install -y wine-staging winetricks lynx xvfb supervisor mono-devel nuget apt-utils novnc x11vnc git net-tools nano && \
    apt-get purge -y software-properties-common && \
    apt-get autoclean -y && \
    useradd -u 1001 -d /home/wine -m -s /bin/bash wine
    
RUN echo "wine ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER wine

RUN cd /home/wine && git clone https://github.com/kanaka/noVNC.git && \
    cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify
    
ENV HOME /home/wine
ENV WINEARCH win32
ENV WINEPREFIX /home/wine/.wine

WORKDIR /home/wine

RUN wine wineboot && xvfb-run winetricks -q dotnet40 corefonts

RUN echo "alias csc='wine /home/wine/.wine/drive_c/windows/Microsoft.NET/Framework/v4.0.30319/csc.exe'" >> ~/.bashrc

ADD startup.sh /home/wine/startup.sh

USER root

RUN cd /home/wine/ && \
    chmod 0755 startup.sh && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*
    
USER wine
CMD ["/home/wine/startup.sh"]
EXPOSE 6080
