import {
  for_each = local.gitlab_projects # needs Terraform >= 1.7
  to       = module.gitlab_project[each.key].gitlab_project.this
  id       = "${local.gitlab_namespace}/${each.key}"
}

import {
  to = module.gitlab_project["bm-utils"].gitlab_project_membership.this["tuana91a"]
  id = "80693817:38898945"
}