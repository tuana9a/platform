FROM codercom/enterprise-base:ubuntu

USER coder

RUN sudo apt update -y

# direnv
RUN sudo apt install -y direnv

# zoxide
RUN sudo wget -q https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh -O /opt/install-zoxide.sh \
    && sudo chmod +x /opt/install-zoxide.sh && sudo /opt/install-zoxide.sh --bin-dir /usr/local/bin/

RUN sudo wget -q https://go.dev/dl/go1.22.5.linux-amd64.tar.gz -O /opt/go1.22.5.linux-amd64.tar.gz \
    && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /opt/go1.22.5.linux-amd64.tar.gz \
    && echo "export export PATH=$PATH:/usr/local/go/bin" | sudo tee -a /etc/profile

RUN go version