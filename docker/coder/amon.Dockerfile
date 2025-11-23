FROM codercom/enterprise-minimal:ubuntu-20251117

USER coder

RUN sudo apt update -y

RUN sudo apt install -y \
  dnsutils \
  net-tools \
  openssh-client \
  iputils-ping \
  telnet

RUN sudo apt install -y \
  tmux \
  unzip \
  jq \
  wget \
  vim

RUN sudo apt install -y zsh && sudo usermod -s /bin/zsh coder

RUN sudo apt install -y direnv
