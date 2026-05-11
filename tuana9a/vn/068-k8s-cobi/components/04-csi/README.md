# proxmox csi

before removing any nodes, wait for detachment of volumes first

```bash
kubectl get volumeattachments.storage.k8s.io --no-headers | awk '{print $4}' | sort | uniq
```

# how-to

```bash
pveum role add CSI -privs "Sys.Audit VM.Audit VM.Config.Disk Datastore.Allocate Datastore.AllocateSpace Datastore.Audit"
pveum user add kubernetes-csi@pve
pveum aclmod / -user kubernetes-csi@pve -role CSI
pveum user token add kubernetes-csi@pve csi -privsep 0
```
