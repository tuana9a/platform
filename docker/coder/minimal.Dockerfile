FROM codercom/enterprise-minimal:ubuntu-20240909

USER coder

RUN sudo apt update -y && sudo apt install -y tmux direnv jq dnsutils net-tools iputils-ping telnet zsh && sudo usermod -s /bin/zsh coder
