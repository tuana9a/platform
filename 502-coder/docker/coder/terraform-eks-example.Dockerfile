FROM codercom/enterprise-base:ubuntu

USER coder

RUN sudo apt update -y

RUN sudo apt install -y tmux direnv jq dnsutils net-tools iputils-ping telnet zsh && sudo usermod -s /bin/zsh coder

# awscli
RUN sudo wget -q https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O /opt/awscli.zip \
    && sudo unzip -q /opt/awscli.zip -d /opt/ | sudo tee -a /opt/awscli.log \
    && sudo /opt/aws/install -u | sudo tee -a /opt/awscli.log

# terraform
RUN sudo wget -q https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip -O /opt/terraform-1.6.6.zip \
    && sudo mkdir -p /opt/terraform-1.6.6/ && sudo unzip -q /opt/terraform-1.6.6.zip -d /opt/terraform-1.6.6/ \
    && sudo ln -sf /opt/terraform-1.6.6/terraform /usr/local/bin/terraform

RUN sudo wget -q https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip -O /opt/terraform-1.7.5.zip \
    && sudo mkdir -p /opt/terraform-1.7.5/ && sudo unzip -q /opt/terraform-1.7.5.zip -d /opt/terraform-1.7.5/

RUN sudo wget -q https://releases.hashicorp.com/terraform/1.9.1/terraform_1.9.1_linux_amd64.zip -O /opt/terraform-1.9.1.zip \
    && sudo mkdir -p /opt/terraform-1.9.1/ && sudo unzip -q /opt/terraform-1.9.1.zip -d /opt/terraform-1.9.1/

# kubectl
RUN sudo curl -sL "https://dl.k8s.io/release/v1.28.11/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
&& sudo chmod 0755 /usr/local/bin/kubectl

# k9s
RUN sudo wget -q https://github.com/derailed/k9s/releases/download/v0.32.4/k9s_Linux_amd64.tar.gz -O /opt/k9s.tar.gz \
&& sudo mkdir -p /opt/k9s && sudo tar xzf /opt/k9s.tar.gz -C /opt/k9s \
&& sudo install -o root -g root -m 0755 /opt/k9s/k9s /usr/local/bin/k9s
