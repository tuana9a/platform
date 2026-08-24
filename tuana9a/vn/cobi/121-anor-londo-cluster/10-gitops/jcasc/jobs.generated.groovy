// ./generate_jcasc_pipeline.py .jenkins/backup-coder-db.Jenkinsfile .jenkins/backup-kubernetes.Jenkinsfile .jenkins/defrag-etcd.Jenkinsfile .jenkins/test-aws-oidc.Jenkinsfile .jenkins/test-gcp-oidc.Jenkinsfile .jenkins/test.Jenkinsfile .jenkins/tfaa.Jenkinsfile .jenkins/vault-unseal.Jenkinsfile

multibranchPipelineJob('backup-coder-db') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('96284674747693728565873706922066664864')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/backup-coder-db.Jenkinsfile')
    }
  }
}

multibranchPipelineJob('backup-kubernetes') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('158728257535453146242078179482956900064')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/backup-kubernetes.Jenkinsfile')
    }
  }
}

multibranchPipelineJob('defrag-etcd') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('154308216165157218782697523002285390914')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/defrag-etcd.Jenkinsfile')
    }
  }
}

multibranchPipelineJob('test-aws-oidc') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('163954511379159881132487778335510043698')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/test-aws-oidc.Jenkinsfile')
    }
  }
}

multibranchPipelineJob('test-gcp-oidc') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('287402406923296937009564441310602818497')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/test-gcp-oidc.Jenkinsfile')
    }
  }
}

multibranchPipelineJob('test') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('12707736894140473154801792860916528374')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/test.Jenkinsfile')
    }
  }
}

multibranchPipelineJob('tfaa') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('164916891256846541262908425012071856868')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/tfaa.Jenkinsfile')
    }
  }
}

multibranchPipelineJob('vault-unseal') {
  branchSources {
    git {
      // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
      id('30604091230084558390226995134000180900')
      remote('https://github.com/tuana9a/platform.git')
      includes('rock-n-roll')
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('.jenkins/vault-unseal.Jenkinsfile')
    }
  }
}
