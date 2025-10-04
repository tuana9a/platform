locals {
  servers = yamldecode(file(var.servers_file))
  apps = {
    "argocd"         = local.servers.orisis.ip
    "*.coder"        = local.servers.orisis.ip
    "coder"          = local.servers.orisis.ip
    "d9stbot"        = local.servers.orisis.ip
    "*.dev2"         = local.servers.orisis.ip
    "dev2"           = local.servers.orisis.ip
    "*.jnt724-dev"   = local.servers.orisis.ip
    "jnt724-dev"     = local.servers.orisis.ip
    "dkhptd-api"     = local.servers.orisis.ip
    "grafana"        = local.servers.orisis.ip
    "hcr"            = local.servers.orisis.ip
    "jenkins"        = local.servers.orisis.ip
    "paste"          = local.servers.orisis.ip
    "t9stbot"        = local.servers.orisis.ip
    "*.stuffs.kn"    = local.servers.orisis.ip # knative serverless
    "vault"          = local.servers.orisis.ip
    "neomorph"       = local.servers.orisis.ip
  }
  mx_cloudflare_routes = [
    {
      target   = "route1.mx.cloudflare.net.",
      priority = 64,
    },
    {
      target   = "route2.mx.cloudflare.net.",
      priority = 38,
    },
    {
      target   = "route3.mx.cloudflare.net.",
      priority = 47,
    },
  ]
}
