FROM tuana9a/coder:base

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv

RUN sudo curl -sL "https://dl.k8s.io/release/v1.28.11/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && sudo chmod 0755 /usr/local/bin/kubectl
