locals {
  gitlab_namespace = "tuana9a"

  gitlab_projects = {
    paste-go = {
      _has_variables         = true
      forked_from_project_id = 60390894
      visibility             = "public"
      description            = "paste-go"
      branch_protections = {
      }
    }
    bm-utils = {
      _has_variables = true
      description    = "bm-utils"
      members        = { tuana91a = "maintainer" }
      branch_protections = {
      }
    }
    dotfiles = {
      description = "dotfiles"
      visibility  = "public"
      branch_protections = {
      }
    }
    t9stbot = {
      _has_variables = true
      description    = "t9stbot"
      visibility     = "public"
      default_branch = "master"
      branch_protections = {
      }
    }
    uuid = {
      _has_variables = true
      description    = "uuid"
      visibility     = "public"
      branch_protections = {
      }
    }
    mom = {
      description = "mom"
      branch_protections = {
      }
    }
    test = {
      description = "test"
      branch_protections = {
      }
    }
  }
}
