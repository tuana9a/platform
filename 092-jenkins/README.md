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
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins git
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins oidc-provider
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins mask-passwords
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins pipeline-utility-steps
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins timestamper
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins kubernetes
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins configuration-as-code
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins saferestart
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins matrix-auth
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins google-login
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins dark-theme
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins pipeline-graph-view
jenkins-plugin-cli -d /var/jenkins_home/plugins --plugins ssh-agent
```

# How I configured google-login

see [093-jenkins-JCasC/README.md#how-i-config-google-login-and-found-the-way-to-inject-secrets-into-jcasc](../093-jenkins-JCasC/README.md#how-i-config-google-login-and-found-the-way-to-inject-secrets-into-jcasc)