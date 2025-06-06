FROM tuana9a/coder:base

RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh --sudo --bin-dir /usr/local/bin --man-dir /usr/local/share/man

RUN sudo curl -sL "https://dl.k8s.io/release/v1.30.13/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && \
  sudo chmod 0755 /usr/local/bin/kubectl

RUN wget https://github.com/derailed/k9s/releases/download/v0.32.4/k9s_Linux_amd64.tar.gz -O /tmp/k9s.tar.gz && \
  tar xzf /tmp/k9s.tar.gz -C /tmp/ && \
  sudo cp /tmp/k9s /usr/local/bin/ && \
  rm /tmp/k9s*

RUN sudo apt install -y python3.$(python3 --version | cut -d '.' -f2)-venv && \
  sudo python3 -m venv /usr/local/ansible.venv && \
  sudo /usr/local/ansible.venv/bin/pip install ansible ansible-core ansible-lint && \
  sudo ln -sf /usr/local/ansible.venv/bin/ansible* /usr/local/bin

RUN curl -sL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz -o /tmp/google-cloud-cli-linux-x86_64.tar.gz && \
  sudo tar -xf /tmp/google-cloud-cli-linux-x86_64.tar.gz -C /usr/local/ && \
  sudo /usr/local/google-cloud-sdk/install.sh --usage-reporting false --command-completion false --path-update false
