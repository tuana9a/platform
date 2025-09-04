# ref: https://www.jenkins.io/doc/book/installing/docker/#on-macos-and-linux

FROM jenkins/jenkins:2.511

USER root

RUN apt-get update && apt-get install -y lsb-release

USER jenkins

RUN jenkins-plugin-cli --plugins git
RUN jenkins-plugin-cli --plugins workflow-aggregator
RUN jenkins-plugin-cli --plugins job-dsl
RUN jenkins-plugin-cli --plugins oidc-provider
RUN jenkins-plugin-cli --plugins mask-passwords
RUN jenkins-plugin-cli --plugins pipeline-utility-steps
RUN jenkins-plugin-cli --plugins timestamper
RUN jenkins-plugin-cli --plugins kubernetes
RUN jenkins-plugin-cli --plugins configuration-as-code
RUN jenkins-plugin-cli --plugins blueocean
RUN jenkins-plugin-cli --plugins saferestart
RUN jenkins-plugin-cli --plugins matrix-auth
RUN jenkins-plugin-cli --plugins google-login
RUN jenkins-plugin-cli --plugins dark-theme
RUN jenkins-plugin-cli --plugins pipeline-graph-view
RUN jenkins-plugin-cli --plugins github
