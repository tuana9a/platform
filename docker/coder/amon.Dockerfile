FROM codercom/enterprise-base:ubuntu-20250829

USER coder

RUN sudo apt update -y && sudo apt install -y tmux direnv jq dnsutils net-tools iputils-ping telnet zsh && sudo usermod -s /bin/zsh coder

RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh -o /tmp/install-zoxide.sh && chmod +x /tmp/install-zoxide.sh \
  && sudo /tmp/install-zoxide.sh --bin-dir /usr/local/bin --man-dir /usr/local/share/man

RUN curl -L https://github.com/junegunn/fzf/releases/download/v0.62.0/fzf-0.62.0-linux_amd64.tar.gz -o /tmp/fzf.tar.gz \
  && tar -xzf /tmp/fzf.tar.gz -C /tmp/ \
  && sudo cp /tmp/fzf /usr/local/bin/ \
  && sudo chmod +x /usr/local/bin/fzf \
  && rm /tmp/fzf*

RUN sudo curl -sL "https://dl.k8s.io/release/v1.33.4/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
  && sudo chmod 0755 /usr/local/bin/kubectl

RUN wget https://github.com/derailed/k9s/releases/download/v0.50.9/k9s_Linux_amd64.tar.gz -O /tmp/k9s.tar.gz \
  && tar xzf /tmp/k9s.tar.gz -C /tmp/ \
  && sudo cp /tmp/k9s /usr/local/bin/ \
  && rm /tmp/k9s*

RUN sudo apt install -y python3.$(python3 --version | cut -d '.' -f2)-venv \
  && sudo python3 -m venv /usr/local/ansible.venv \
  && sudo /usr/local/ansible.venv/bin/pip install ansible ansible-core ansible-lint \
  && sudo ln -sf /usr/local/ansible.venv/bin/ansible* /usr/local/bin

RUN wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip -O /tmp/terraform.zip \
  && unzip -d /tmp/ /tmp/terraform.zip \
  && sudo cp /tmp/terraform /usr/local/bin/ \
  && sudo chmod 0755 /usr/local/bin/terraform

RUN curl -sL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz -o /tmp/google-cloud-cli-linux-x86_64.tar.gz \
  && sudo tar -xf /tmp/google-cloud-cli-linux-x86_64.tar.gz -C /usr/local/ \
  && sudo /usr/local/google-cloud-sdk/install.sh --usage-reporting false --command-completion false --path-update false \
  && rm /tmp/google-cloud-cli-linux-x86_64.tar.gz

RUN wget https://github.com/digitalocean/doctl/releases/download/v1.124.0/doctl-1.124.0-linux-amd64.tar.gz -O /tmp/doctl.tar.gz \
  && tar xzf /tmp/doctl.tar.gz -C /tmp \
  && sudo mv /tmp/doctl /usr/local/bin/

RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O /tmp/awscli.zip \
  && unzip /tmp/awscli.zip -d /tmp/ \
  && sudo /tmp/aws/install
