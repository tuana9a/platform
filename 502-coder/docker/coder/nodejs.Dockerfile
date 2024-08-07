FROM codercom/enterprise-base:ubuntu

USER coder

RUN sudo apt update -y

RUN sudo apt install -y tmux direnv jq dnsutils net-tools iputils-ping telnet zsh && sudo usermod -s /bin/zsh coder

# nodejs
RUN sudo wget -q https://nodejs.org/dist/v18.20.3/node-v18.20.3-linux-x64.tar.xz -O /opt/node-v18.20.3-linux-x64.tar.xz \
    && sudo tar xf /opt/node-v18.20.3-linux-x64.tar.xz -C /opt \
    && sudo ln -sf /opt/node-v18.20.3-linux-x64/bin/* /usr/local/bin/

RUN sudo wget -q https://nodejs.org/dist/v20.15.0/node-v20.15.0-linux-x64.tar.xz -O /opt/node-v20.15.0-linux-x64.tar.xz \
    && sudo tar xf /opt/node-v20.15.0-linux-x64.tar.xz -C /opt
