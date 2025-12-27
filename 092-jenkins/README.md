# jenkins

# oidc provider

https://plugins.jenkins.io/oidc-provider/

# job dsl

https://plugins.jenkins.io/job-dsl/

https://jenkinsci.github.io/job-dsl-plugin/

https://your.jenkins.installation/plugin/job-dsl/api-viewer/index.html

# plugins

Jenkins's home dir is persisted by PVC, plugins are persisted in Jenkins's home dir so changing plugins during building docker image of Jenkins does not work.

*NOTE*: *Actual plugin's versions may be changed by applying updates from Jenkins UI, below is just a reference.*

```bash
jenkins-plugin-cli --plugins git
jenkins-plugin-cli --plugins oidc-provider
jenkins-plugin-cli --plugins mask-passwords
jenkins-plugin-cli --plugins pipeline-utility-steps
jenkins-plugin-cli --plugins timestamper
jenkins-plugin-cli --plugins kubernetes
jenkins-plugin-cli --plugins configuration-as-code
jenkins-plugin-cli --plugins saferestart
jenkins-plugin-cli --plugins matrix-auth
jenkins-plugin-cli --plugins google-login
jenkins-plugin-cli --plugins dark-theme
jenkins-plugin-cli --plugins pipeline-graph-view
```

# How I configured google-login

see [093-jenkins-JCasC/README.md#how-i-config-google-login-and-found-the-way-to-inject-secrets-into-jcasc](../093-jenkins-JCasC/README.md#how-i-config-google-login-and-found-the-way-to-inject-secrets-into-jcasc)