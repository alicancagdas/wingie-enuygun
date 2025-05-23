FROM ubuntu:22.04

# Sistem güncellemeleri ve temel araçlar
RUN apt-get update && apt-get install -y \
    curl unzip wget gnupg software-properties-common \
    apt-transport-https ca-certificates lsb-release \
    vim git bash python3 python3-pip

# Terraform kurulumu
RUN wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip && \
    unzip terraform_1.7.5_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.7.5_linux_amd64.zip

# Google Cloud SDK
RUN mkdir -p /usr/share/keyrings && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y google-cloud-sdk

# kubectl kurulumu
RUN curl -LO https://dl.k8s.io/release/v1.30.1/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

# Helm kurulumu
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Çalışma klasörü
WORKDIR /workspace

CMD ["/bin/bash"]
