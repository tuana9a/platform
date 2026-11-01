resource "terraform_data" "setup01" {
  triggers_replace = 1

  connection {
    host        = local.host
    user        = local.ssh_user
    private_key = local.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "set -xeuo pipefail",
      "apt update -y && apt install -y htop haproxy fail2ban",
    ]
  }
}

resource "terraform_data" "setup02" {
  triggers_replace = 1

  connection {
    host        = local.host
    user        = local.ssh_user
    private_key = local.private_key
  }

  provisioner "file" {
    content     = local.node_exporter_service
    destination = "/tmp/node_exporter.service"
  }

  provisioner "file" {
    content     = local.node_exporter_script
    destination = "/tmp/install-node-exporter.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-node-exporter.sh",
      "sudo /tmp/install-node-exporter.sh",
      "rm -f /tmp/install-node-exporter.sh /tmp/node_exporter.service",
    ]
  }
}

resource "terraform_data" "setup03" {
  triggers_replace = 1

  connection {
    host        = local.host
    user        = local.ssh_user
    private_key = local.private_key
  }

  provisioner "file" {
    content     = local.fail2ban_jail_local
    destination = "/tmp/jail.local"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo install -o root -g root -m 0644 /tmp/jail.local /etc/fail2ban/jail.local",
      "rm -f /tmp/jail.local",
      # systemd: enabled + restarted
      "sudo systemctl enable fail2ban",
      "sudo systemctl restart fail2ban",
    ]
  }
}

resource "terraform_data" "apt_update_upgrade" {
  triggers_replace = 1

  connection {
    host        = local.host
    user        = local.ssh_user
    private_key = local.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "set -xeuo pipefail",
      "apt update -y",
      # --force-confdef Forces dpkg to keep your current (old) configuration file whenever a conflict arises.
      # --force-confold Allows dpkg to automatically overwrite configuration files that you have not modified
      "DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\"",
    ]
  }
}
