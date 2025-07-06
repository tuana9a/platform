#!/bin/bash

# Example: generate.sh default dkhptd t9stbot

ns_arr=("$@")

for ns in "${ns_arr[@]}"; do
  cat <<EOF > ns-$ns-forward-kourier.yml
kind: Service
apiVersion: v1
metadata:
  name: forward-kourier
  namespace: $ns
spec:
  type: ExternalName
  externalName: kourier-internal.knative-serving.svc.cluster.local
  ports:
    - port: 80
EOF
done