resource "terraform_data" "cluster_upgrade_00_prechecks" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "sudo cat /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-cache madison kubeadm",
    ]
  }
}

resource "terraform_data" "cluster_upgrade_01_kubectl_drain_primary_control_plane" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "sudo KUBECONFIG='/etc/kubernetes/admin.conf' kubectl drain --ignore-daemonsets --delete-emptydir-data --disable-eviction --force '${local.primary_control_plane.nodename}'",
    ]
  }
}

resource "terraform_data" "cluster_upgrade_02_change_apt_source_list" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${local.cluster_upgrade.next_version_channel}/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null",
      "cat /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "apt-cache madison kubeadm",
    ]
  }
}

resource "terraform_data" "cluster_upgrade_03_upgrade_apt_packages" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "sudo apt-mark unhold kubeadm",
      "sudo apt-get update && sudo apt-get install -y kubeadm='${local.cluster_upgrade.next_version}-*'",
      "sudo apt-mark hold kubeadm",
      "kubeadm version",
    ]
  }
}

resource "terraform_data" "cluster_upgrade_04_kubeadm_upgrade_plan_show" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [ 
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "sudo kubeadm upgrade plan"
     ]
  }
}

resource "terraform_data" "cluster_upgrade_05_kubeadm_upgrade_apply" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "sudo kubeadm upgrade apply -y --skip-phases=addon/kube-proxy v${local.cluster_upgrade.next_version}"
    ]
  }
}

resource "terraform_data" "cluster_upgrade_06_kubelet_upgrade_then_restart" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "sudo apt-mark unhold kubelet kubectl",
      "sudo apt-get update && sudo apt-get install -y kubelet='${local.cluster_upgrade.next_version}-*' kubectl='${local.cluster_upgrade.next_version}-*'",
      "sudo apt-mark hold kubelet kubectl",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart kubelet",
    ]
  }
}

resource "terraform_data" "cluster_upgrade_07_kubectl_uncordon_primary_control_plane" {
  triggers_replace = 1
  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "sudo KUBECONFIG='/etc/kubernetes/admin.conf' kubectl uncordon '${local.primary_control_plane.nodename}'",
    ]
  }
}


