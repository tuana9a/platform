FROM codercom/enterprise-base:ubuntu

USER coder

RUN sudo apt update -y

RUN sudo apt install -y tmux direnv jq dnsutils net-tools iputils-ping telnet zsh && sudo usermod -s /bin/zsh coder

RUN sudo wget -q https://go.dev/dl/go1.22.5.linux-amd64.tar.gz -O /opt/go1.22.5.linux-amd64.tar.gz \
    && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /opt/go1.22.5.linux-amd64.tar.gz \
    && echo "export PATH=$PATH:/usr/local/go/bin" | sudo tee -a /etc/profile

RUN /usr/local/go/bin/go version