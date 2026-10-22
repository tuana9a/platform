resource "terraform_data" "step01" {
  for_each = toset([var.node.nodename])

  triggers_replace = var.triggers_replace

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.private_key
    host        = var.primary_control_plane.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "echo ===01===",
      join(" ", [
        "sudo KUBECONFIG='/etc/kubernetes/admin.conf'",
        "kubectl drain --ignore-daemonsets --delete-emptydir-data --disable-eviction --force",
        "'${var.node.nodename}'"
      ]),
    ]
  }
}

resource "terraform_data" "step02" {
  depends_on = [terraform_data.step01]

  for_each = toset([var.node.nodename])

  triggers_replace = var.triggers_replace

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.private_key
    host        = var.node.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "echo ===02===",
      "sudo cat /etc/apt/sources.list.d/kubernetes.list",
      # replace apt source list with new channel
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${var.next_version_channel}/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null",
      "cat /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "apt-cache madison kubeadm",
      # install new kubeadm
      "sudo apt-mark unhold kubeadm",
      "sudo apt-get update && sudo apt-get install -y kubeadm='${var.next_version}-*'",
      "sudo apt-mark hold kubeadm",
      "kubeadm version",
      # kubeadm upgrade apply (for the first upgrade)
      var.node.is_the_first_upgrade ?
      "sudo kubeadm upgrade plan" :
      "echo 'not the first upgrade: skip kubeadm upgrade plan'",
      # kubeadm upgrade node (for the rest)
      var.node.is_the_first_upgrade ?
      "sudo kubeadm upgrade apply -y --skip-phases=addon/kube-proxy v${var.next_version}" :
      "sudo kubeadm upgrade node",
      # install new kubelet kubectl
      "sudo apt-mark unhold kubelet kubectl",
      "sudo apt-get update && sudo apt-get install -y kubelet='${var.next_version}-*' kubectl='${var.next_version}-*'",
      "sudo apt-mark hold kubelet kubectl",
      # reload and restart kubelet
      "sudo systemctl daemon-reload",
      "sudo systemctl restart kubelet",
    ]
  }
}

resource "terraform_data" "step03" {
  depends_on = [terraform_data.step02]

  for_each = toset([var.node.nodename])

  triggers_replace = var.triggers_replace

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.private_key
    host        = var.primary_control_plane.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "echo ===03===",
      join(" ", [
        "sudo KUBECONFIG='/etc/kubernetes/admin.conf'",
        "kubectl uncordon",
        "'${var.node.nodename}'"
      ]),
    ]
  }
}
