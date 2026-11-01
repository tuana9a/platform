locals {
  inventory_yml = yamldecode(file("./inventory.yml"))

  private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
  host        = keys(local.inventory_yml.megatron.hosts)[0]
  ssh_user    = local.inventory_yml.megatron.hosts[local.host].ansible_user

  node_exporter_version = "1.9.1"
  node_exporter_service = <<-EOT
    [Unit]
    Description=Node Exporter
    After=network.target

    [Service]
    Type=simple
    ExecStart=/opt/node_exporter-${local.node_exporter_version}.linux-amd64/node_exporter

    [Install]
    WantedBy=multi-user.target
  EOT

  node_exporter_script = <<-EOT
    #!/usr/bin/env bash
    set -exuo pipefail

    VERSION="${local.node_exporter_version}"
    OWNER="${local.ssh_user}"

    TARBALL="/opt/node_exporter-$VERSION.linux-amd64.tar.gz"
    DIR="/opt/node_exporter-$VERSION.linux-amd64"
    URL="https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz"

    # get_url + unarchive (remote_src, owner/group)
    if [ ! -x "$DIR/node_exporter" ]; then
      curl -fsSL -o "$TARBALL" "$URL"
      tar -xzf "$TARBALL" -C /opt
      chown -R "$OWNER:$OWNER" "$DIR"
    fi

    # clean up downloaded tarball
    rm -f "$TARBALL"

    # template (uploaded by Terraform to /tmp)
    install -m 0644 /tmp/node_exporter.service /etc/systemd/system/node_exporter.service

    # daemon-reload + enable + restart
    systemctl daemon-reload
    systemctl enable node_exporter
    systemctl restart node_exporter
  EOT

  fail2ban_jail_local = <<-EOT
    [sshd]
    enabled = true
    mode = aggressive
    backend = systemd
    maxretry = 5
    bantime = 60 # 1 minutes
    bantime.increment = true
    bantime.multipliers = 1 5 60 1440 43200 525600
  EOT
}
