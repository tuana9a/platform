# ref: https://www.jenkins.io/doc/book/installing/docker/#on-macos-and-linux

FROM jenkins/jenkins:2.511

USER root

RUN apt-get update && apt-get install -y lsb-release

USER jenkins

RUN jenkins-plugin-cli --plugins \
git:5.7.0 \
blueocean:1.27.19 \
kubernetes:4349.v8fe8f2b_ee9f1 \
workflow-aggregator:600.vb_57cdd26fdd7 \
configuration-as-code:1971.vf9280461ea_89 \
oidc-provider:111.v29fd614b_3617 \
job-dsl:1.90 \
pipeline-utility-steps:2.19.0 \
timestamper:1.29
