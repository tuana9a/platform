data "vault_kv_secret_v2" "ci" {
  mount = "kvv2"
  name  = "ci"
}

ephemeral "vault_kv_secret_v2" "ci" {
  mount = "kvv2"
  name  = "ci"
}

data "external" "id_rsa" {
  program = ["bash", "./scripts/id_rsa.sh"]
  query = {
    file_content = data.vault_kv_secret_v2.ci.data.id_rsa
  }
}

data "external" "mkdir_tmp" {
  program = ["bash", "-c", "mkdir -p ./tmp && echo '{\"dir\":\"./tmp\"}'"]
}

data "external" "install_etcdctl" {
  program = ["bash", "./scripts/install-etcdctl.sh"]

  query = {
    node_ip  = local.primary_control_plane_ip
    ssh_user = local.vm_user
    key_file = local.key_file
  }
}

data "external" "get_join_command" {
  program = ["bash", "./scripts/get_join_command.sh"]

  query = {
    node_ip  = local.primary_control_plane_ip
    ssh_user = local.vm_user
    tmp_dir  = data.external.mkdir_tmp.result.dir
    key_file = local.key_file
  }
}

data "external" "get_kube_certs" {
  program = concat(["bash", "./scripts/get_kube_certs.sh"], local.primary_control_plane.kube_certs)

  query = {
    node_ip  = local.primary_control_plane_ip
    ssh_user = local.vm_user
    key_file = local.key_file
    tmp_dir  = data.external.mkdir_tmp.result.dir
  }
}

data "external" "variable_files" {
  program = ["bash", "./scripts/variable_files.sh", data.external.mkdir_tmp.result.dir]
  query = merge(
    {
      vm_user                  = local.vm_user
      key_file                 = local.key_file
      primary_control_plane_ip = local.primary_control_plane_ip
      tmp_dir                  = data.external.mkdir_tmp.result.dir
    },
    {
      for k, v in local._cluster :
      "${k}_node_ip" => v.ip_address
    }
  )
}
