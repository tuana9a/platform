FROM codercom/enterprise-minimal:ubuntu-20251117

USER coder

RUN sudo apt update -y

RUN sudo apt install -y \
  openssh-client

RUN sudo apt install -y zsh && sudo usermod -s /bin/zsh coder
