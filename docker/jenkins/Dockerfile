# ref: https://www.jenkins.io/doc/book/installing/docker/#on-macos-and-linux

ARG BUILD_TAG

FROM jenkins/jenkins:${BUILD_TAG}

USER root

RUN apt-get update && apt-get install -y lsb-release

USER jenkins

RUN jenkins-plugin-cli --plugins git:5.7.0 \
blueocean \
kubernetes:4314.v5b_846cf499eb_ \
workflow-aggregator:600.vb_57cdd26fdd7 \
configuration-as-code:1932.v75cb_b_f1b_698d \
oidc-provider:89.v3dfb_6d89b_618 \
job-dsl:1.90 \
timestamper:1.28
