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
jenkins-plugin-cli --plugins git:5.7.0
jenkins-plugin-cli --plugins workflow-aggregator:600.vb_57cdd26fdd7
jenkins-plugin-cli --plugins job-dsl:1.90
jenkins-plugin-cli --plugins oidc-provider:111.v29fd614b_3617
jenkins-plugin-cli --plugins mask-passwords:199.va_0218b_a_59186
jenkins-plugin-cli --plugins pipeline-utility-steps:2.19.0
jenkins-plugin-cli --plugins timestamper:1.29
jenkins-plugin-cli --plugins kubernetes:4358.vcfd9c5a_0a_f51
jenkins-plugin-cli --plugins configuration-as-code:1971.vf9280461ea_89
jenkins-plugin-cli --plugins blueocean:1.27.19
jenkins-plugin-cli --plugins saferestart:102.v4dc1b_9636a_ee
jenkins-plugin-cli --plugins matrix-auth:3.2.6
jenkins-plugin-cli --plugins google-login:109.v022b_cf87b_e5b_
jenkins-plugin-cli --plugins dark-theme:524.vd675b_22b_30cb_
jenkins-plugin-cli --plugins pipeline-graph-view:619.v92f3fcdc39db_
```
