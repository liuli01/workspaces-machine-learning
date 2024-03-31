FROM kasmweb/ubuntu-focal-dind-rootless:develop

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

######### START CUSTOMIZATION ########

# install apt packages
RUN apt-get update && apt-get install -y \
        python3-pip libasound2 libegl1-mesa libgl1-mesa-glx \
        libxcomposite1 libxcursor1 libxi6 libxrandr2 libxss1 \
        libxtst6 gdal-bin ffmpeg vlc dnsutils iputils-ping \
        git remmina remmina-plugin-rdp


# Install Visual Studio Code
#install VS code
COPY resources/install_vscode.sh /tmp/
RUN bash /tmp/install_vscode.sh


# Install Chrome
COPY resources/install_chrome.sh /tmp/
RUN bash /tmp/install_chrome.sh


# Create desktop shortcuts
RUN cp /usr/share/applications/org.remmina.Remmina.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/org.remmina.Remmina.desktop \
    && chown 1000:1000 $HOME/Desktop/org.remmina.Remmina.desktop


######### END CUSTOMIZATIONS ########

RUN chown -R 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
