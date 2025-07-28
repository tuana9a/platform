# ref: https://www.jenkins.io/doc/book/installing/docker/#on-macos-and-linux

FROM jenkins/jenkins:2.511

USER root

RUN apt-get update && apt-get install -y lsb-release

USER jenkins

RUN jenkins-plugin-cli --plugins git:5.7.0
RUN jenkins-plugin-cli --plugins workflow-aggregator:600.vb_57cdd26fdd7
RUN jenkins-plugin-cli --plugins job-dsl:1.90
RUN jenkins-plugin-cli --plugins oidc-provider:111.v29fd614b_3617
RUN jenkins-plugin-cli --plugins mask-passwords:199.va_0218b_a_59186
RUN jenkins-plugin-cli --plugins pipeline-utility-steps:2.19.0
RUN jenkins-plugin-cli --plugins timestamper:1.29
RUN jenkins-plugin-cli --plugins kubernetes:4349.v8fe8f2b_ee9f1
RUN jenkins-plugin-cli --plugins configuration-as-code:1971.vf9280461ea_89
RUN jenkins-plugin-cli --plugins blueocean:1.27.19
RUN jenkins-plugin-cli --plugins saferestart:102.v4dc1b_9636a_ee
RUN jenkins-plugin-cli --plugins matrix-auth:3.2.6
RUN jenkins-plugin-cli --plugins google-login:109.v022b_cf87b_e5b_
