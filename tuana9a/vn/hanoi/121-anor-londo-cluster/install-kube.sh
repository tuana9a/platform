#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Combined provisioning script: runc, CNI plugins, containerd, kubernetes
# For fresh instances only - no idempotency/existing-file checks.
# Run as a non-root user with sudo privileges (passwordless or interactive)
# ============================================================

# ---------- Variables ----------
RUNC_VERSION="v1.1.13"
RUNC_URL="https://github.com/opencontainers/runc/releases/download/${RUNC_VERSION}/runc.amd64"
RUNC_DEST_PATH="/usr/local/sbin/runc"

CNI_VERSION="v1.5.1"
CNI_URL="https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz"
CNI_BIN_DIR="/opt/cni/bin"

CONTAINERD_VERSION="${CONTAINERD_VERSION:-2.2.3}"
CONTAINERD_OS="${CONTAINERD_OS:-linux}"
CONTAINERD_ARCH="${CONTAINERD_ARCH:-amd64}"
CONTAINERD_SERVICE_ENVS="${CONTAINERD_SERVICE_ENVS:-}"
CONTAINERD_ARCHIVE_NAME="containerd-${CONTAINERD_VERSION}-${CONTAINERD_OS}-${CONTAINERD_ARCH}.tar.gz"
CONTAINERD_ARCHIVE_URL="https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/${CONTAINERD_ARCHIVE_NAME}"

KUBERNETES_VERSION="${KUBERNETES_VERSION:?KUBERNETES_VERSION must be set, e.g. 1.31.0}"
KUBERNETES_CHANNEL="$(echo "${KUBERNETES_VERSION}" | cut -d. -f1,2)"  # e.g. "1.31.0" -> "1.31"

# ---------- Temp download dir (user-writable, cleaned up on exit) ----------
TMP_DOWNLOAD_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DOWNLOAD_DIR}"' EXIT

# ============================================================
# 1. Install runc
# ============================================================
echo "==> Installing runc ${RUNC_VERSION}"

curl -fsSL -o "${TMP_DOWNLOAD_DIR}/runc.amd64" "${RUNC_URL}"
sudo install -o root -g root -m 0755 "${TMP_DOWNLOAD_DIR}/runc.amd64" "${RUNC_DEST_PATH}"

# ============================================================
# 2. Install CNI plugins
# ============================================================
echo "==> Installing CNI plugins ${CNI_VERSION}"

curl -fsSL -o "${TMP_DOWNLOAD_DIR}/cni-plugins.tgz" "${CNI_URL}"

sudo install -d -o root -g root -m 0755 "${CNI_BIN_DIR}"
sudo tar -xzf "${TMP_DOWNLOAD_DIR}/cni-plugins.tgz" -C "${CNI_BIN_DIR}"
sudo chown -R root:root "${CNI_BIN_DIR}"

# ============================================================
# 3. Install containerd
# ============================================================
echo "==> Installing containerd ${CONTAINERD_VERSION}"

curl -fsSL -o "${TMP_DOWNLOAD_DIR}/containerd.tar.gz" "${CONTAINERD_ARCHIVE_URL}"
sudo tar -xzf "${TMP_DOWNLOAD_DIR}/containerd.tar.gz" -C "/usr/local"

sudo install -d -m 0755 "/etc/containerd"

sudo tee /lib/systemd/system/containerd.service > /dev/null <<EOF
# https://raw.githubusercontent.com/containerd/containerd/main/containerd.service

# Copyright The containerd Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target dbus.service

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd
${CONTAINERD_SERVICE_ENVS}

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF
sudo chown root:root /lib/systemd/system/containerd.service
sudo chmod 0644 /lib/systemd/system/containerd.service

sudo tee /etc/containerd/config.toml > /dev/null <<'EOF'
version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    [plugins."io.containerd.grpc.v1.cri".containerd]
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2" # kube
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true # kube
EOF
sudo chown root:root /etc/containerd/config.toml
sudo chmod 0644 /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

# ============================================================
# 4. Kubernetes prerequisites + install (kubeadm/kubelet/kubectl)
# ============================================================
echo "==> Loading kernel modules"

sudo tee /etc/modules-load.d/k8s.conf > /dev/null <<'EOF'
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

echo "==> Configuring sysctl"

sudo tee /etc/sysctl.d/k8s.conf > /dev/null <<'EOF'
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

echo "==> Installing kubelet/kubeadm/kubectl ${KUBERNETES_VERSION}"

sudo apt install -y gnupg2

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_CHANNEL}/deb/Release.key" \
  | sudo gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_CHANNEL}/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo apt-get update
sudo apt install -y kubelet="${KUBERNETES_VERSION}-*" kubeadm="${KUBERNETES_VERSION}-*" kubectl="${KUBERNETES_VERSION}-*"
sudo apt-mark hold kubelet kubeadm kubectl

kubelet --version

sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl restart kubelet

echo "==> Done."