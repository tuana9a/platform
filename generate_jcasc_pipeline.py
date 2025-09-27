#!/bin/env python3

import os
import sys
import glob
import hashlib

filepaths=sys.argv[1:]

body = ""

i = 1

for filepath in filepaths:
  filename = os.path.basename(filepath)
  # print(int(os.path.getmtime(filepath)))
  nameonly = os.path.splitext(filename)[0]
  # print(filepath, filename, nameonly)
  hasher = hashlib.md5()
  hasher.update(nameonly.encode('utf-8'))
  hex_digest = hasher.hexdigest()
  unique_id = int(hex_digest, 16)

  tmpl = """          multibranchPipelineJob('""" + nameonly + """') {
            branchSources {
              git {
                // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
                id('""" + str(unique_id) + """')
                remote('https://github.com/tuana9a/platform.git')
                includes('rock-n-roll')
              }
            }
            factory {
              workflowBranchProjectFactory {
                scriptPath('.jenkins/""" + nameonly + """.Jenkinsfile')
              }
            }
          }
"""
  body += tmpl
  i = i + 1

header = """apiVersion: v1
kind: ConfigMap
metadata:
  namespace: jenkins
  name: jobs-jcasc
  labels:
    jenkins-jenkins-config: "true"
data:
  jobs.yaml: |
    jobs:
      - script: |
"""

content = header + body

print(content, end='')