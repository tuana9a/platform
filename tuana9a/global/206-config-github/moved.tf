moved {
  from = github_repository.platform
  to   = module.repo["platform"].github_repository.this
}

moved {
  from = github_repository_ruleset.platform_main
  to   = module.repo["platform"].github_repository_ruleset.this["main"]
}

moved {
  from = github_repository_ruleset.platform_rock-n-roll
  to   = module.repo["platform"].github_repository_ruleset.this["rock-n-roll"]
}

moved {
  from = github_repository_webhook.platform
  to   = module.repo["platform"].github_repository_webhook.this["jenkins"]
}

moved {
  from = github_repository.helm-charts
  to   = module.repo["helm-charts"].github_repository.this
}
