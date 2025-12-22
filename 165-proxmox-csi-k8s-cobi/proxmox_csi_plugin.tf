resource "proxmox_virtual_environment_role" "CSI" {
  role_id = "CSI"

  privileges = [
    "Sys.Audit",
    "VM.Audit",
    "VM.Config.Disk",
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit",
  ]
}

# WARN: empty password, does login bypass password
resource "proxmox_virtual_environment_user" "kubernetes_csi" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.CSI.role_id
  }

  comment = "Proxmox CSI user; Managed by Terraform"
  user_id = "kubernetes-csi@pve"
}

resource "time_offset" "three_months_from_now" {
  offset_months = 3
}

resource "proxmox_virtual_environment_user_token" "kubernetes_csi" {
  comment         = "Managed by Terraform"
  expiration_date = time_offset.three_months_from_now.rfc3339
  token_name      = "kubernetes-csi"
  user_id         = proxmox_virtual_environment_user.kubernetes_csi.user_id

  privileges_separation = false
}

resource "helm_release" "proxmox_csi_plugin" {
  name      = "proxmox-csi-plugin"
  namespace = "csi-proxmox"

  create_namespace = true

  repository = "oci://ghcr.io/sergelogvinov/charts"
  chart      = "proxmox-csi-plugin"
  version    = "0.5.3"

  values = [templatefile("./templates/values.yaml", {
    pve_url          = var.proxmox_csi_pve_url
    pve_insecure     = var.proxmox_csi_pve_insecure
    pve_cluster_name = var.proxmox_csi_cluster_name
    pve_token_id     = proxmox_virtual_environment_user_token.kubernetes_csi.id
    pve_token_secret = split("=", proxmox_virtual_environment_user_token.kubernetes_csi.value)[1]
    pve_storage_id   = "local"
  })]
}
