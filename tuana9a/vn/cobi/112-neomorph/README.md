# neomorph

It's a `Mini PC AMD R7 5825u GMKtec M5 Plus`

<https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm>

# [`/etc/network/interfaces`](./interfaces)

# debug iptables with NAT setup

```bash
iptables -t nat -L -v --line-numbers
iptables -t nat -D POSTROUTING 1 # Delete rule in a chain by line number
```

```bash
iptables -t nat -F # Delete all rules in all chains
iptables -t nat -F POSTROUTING # Delete all rules in a chain
```
