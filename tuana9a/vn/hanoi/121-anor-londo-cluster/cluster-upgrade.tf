module "upgrade_node" {
  source = "./modules/upgrade-node"

  ssh_user    = local.vm_user
  private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa

  node                  = local.cluster["i-124"]
  primary_control_plane = local.primary_control_plane
  next_version          = "1.33.13"
  next_version_channel  = "1.33"

  triggers_replace = 1792685923
}
