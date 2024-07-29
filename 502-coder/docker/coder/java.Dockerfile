FROM codercom/enterprise-base:ubuntu

USER coder

RUN sudo apt update -y

RUN sudo apt install -y tmux direnv jq dnsutils net-tools iputils-ping telnet zsh && sudo usermod -s /bin/zsh coder

# corretto 8
RUN sudo wget -q https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz -O /opt/corretto-8.tar.gz \
    && sudo tar xzf /opt/corretto-8.tar.gz -C /opt \
    && sudo ln -sf /opt/amazon-corretto-8*/bin/* /usr/local/bin

# mvn
RUN sudo wget -q https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz -O /opt/maven-3.tar.gz \
    && sudo tar xzf /opt/maven-3.tar.gz -C /opt/ \
    && sudo ln -sf /opt/apache-maven-3*/bin/* /usr/local/bin
