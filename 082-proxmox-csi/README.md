# proxmox-csi

https://github.com/sergelogvinov/proxmox-csi-plugin?tab=readme-ov-file#method-2-by-helm

# requirements

```bash
for x in $(kubectl get nodes -o json | jq -r '.items[].metadata.name'); do
    kubectl get node $x --show-labels;
done
```

```bash
for x in $(kubectl get nodes -o json | jq -r '.items[].metadata.name'); do
    kubectl label nodes $x topology.kubernetes.io/region=pve-cobi topology.kubernetes.io/zone=pve-cobi
done
```
