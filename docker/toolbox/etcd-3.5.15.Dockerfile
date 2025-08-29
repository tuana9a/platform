FROM ubuntu

RUN apt update && apt install -y curl wget unzip openssh-client

ENV ETCD_VER=v3.5.15

# choose either URL
ENV GOOGLE_URL=https://storage.googleapis.com/etcd
ENV GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ENV DOWNLOAD_URL=${GOOGLE_URL}

RUN mkdir -p /tmp/etcd-download \
    && curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
    && tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download --strip-components=1 \
    && cp /tmp/etcd-download/etcd* /usr/local/bin/ \
    && /usr/local/bin/etcdctl version
