FROM ubuntu

ARG TERRAFORM_VERSION

ENV TERRAFORM_VERSION=${TERRAFORM_VERSION:-1.7.1}

RUN apt update

RUN apt install -y curl wget unzip openssh-client jq

RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && terraform -v

RUN apt install -y apt-transport-https ca-certificates gnupg curl \
    # Add the Google Cloud public key
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    # Add the gcloud CLI repository to your sources list
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    # Update the package index again to include the new repository
    && apt-get update && apt-get install -y google-cloud-cli \
    # Verify the installation
    && gcloud --version
