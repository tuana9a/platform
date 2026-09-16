#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Install etcdctl binary
# For fresh instances - no idempotency/existing-file checks.
# Run as a non-root user with sudo privileges.
# ============================================================

ETCD_VER="${ETCD_VER:-v3.5.15}"
ETCD_DOWNLOAD_URL="${ETCD_DOWNLOAD_URL:-https://github.com/etcd-io/etcd/releases/download}"

ETCD_ARCHIVE_NAME="etcd-${ETCD_VER}-linux-amd64.tar.gz"
ETCD_ARCHIVE_URL="${ETCD_DOWNLOAD_URL}/${ETCD_VER}/${ETCD_ARCHIVE_NAME}"
ETCD_EXTRACTED_DIR="etcd-${ETCD_VER}-linux-amd64"

# ---------- Skip if etcdctl already installed ----------
if command -v etcdctl >/dev/null 2>&1; then
    echo "==> etcdctl already installed at $(command -v etcdctl); skipping installation."
    etcdctl version
    exit 0
fi

# ---------- Temp download dir ----------
TMP_DOWNLOAD_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DOWNLOAD_DIR}"' EXIT

# ---------- Download ----------
echo "==> Downloading etcd ${ETCD_VER}"
curl -fsSL -o "${TMP_DOWNLOAD_DIR}/${ETCD_ARCHIVE_NAME}" "${ETCD_ARCHIVE_URL}"

# ---------- Extract ----------
echo "==> Extracting etcd ${ETCD_VER}"
tar -xzf "${TMP_DOWNLOAD_DIR}/${ETCD_ARCHIVE_NAME}" -C "${TMP_DOWNLOAD_DIR}"

# ---------- Install etcdctl binary ----------
echo "==> Installing etcdctl to /usr/local/bin"
sudo install -m 0755 "${TMP_DOWNLOAD_DIR}/${ETCD_EXTRACTED_DIR}/etcdctl" /usr/local/bin/etcdctl

etcdctl version

echo "==> Done."