locals {
  servers = yamldecode(file(var.servers_file))
  apps = {
    "argocd"           = local.servers.xenomorph.ip
    "*.coder"          = local.servers.xenomorph.ip
    "coder"            = local.servers.xenomorph.ip
    "d9stbot"          = local.servers.xenomorph.ip
    "*.dev2"           = local.servers.xenomorph.ip
    "dev2"             = local.servers.xenomorph.ip
    "dkhptd-api"       = local.servers.xenomorph.ip
    "grafana"          = local.servers.xenomorph.ip
    "hcr"              = local.servers.xenomorph.ip
    "jenkins"          = local.servers.xenomorph.ip
    "paste.default.kn" = local.servers.xenomorph.ip
    "paste.stuffs.kn"  = local.servers.xenomorph.ip
    "paste"            = local.servers.xenomorph.ip
    "pve-xeno"         = local.servers.xenomorph.ip
    "t9stbot"          = local.servers.xenomorph.ip
    "uuid.stuffs.kn"   = local.servers.xenomorph.ip
    "vault"            = local.servers.xenomorph.ip
    "ryuu"             = local.servers.xenomorph.ip
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
