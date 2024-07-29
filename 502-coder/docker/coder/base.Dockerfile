FROM codercom/enterprise-base:ubuntu

USER coder

RUN sudo apt update -y

RUN sudo apt install -y tmux direnv jq dnsutils net-tools iputils-ping telnet zsh && sudo usermod -s /bin/zsh coder
