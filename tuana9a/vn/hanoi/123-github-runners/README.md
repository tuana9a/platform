# github-runners

for deploying github self-hosted runners

# how to enable min, max number of runners

Look at [this](https://github.com/actions/actions-runner-controller/blob/088e2a3a9029f1c85e7bd3d2539f8b8ead5947f9/charts/gha-runner-scale-set/templates/autoscalingrunnerset.yaml#L1) bruh!

To enable min and max number of runners we need to set `resourceMeta.autoscalingRunnerSet` some dummy value

# known issues

(drama) "scale set runner is only supporting single label"

https://github.com/actions/actions-runner-controller/issues/3330

https://github.com/orgs/community/discussions/160422
