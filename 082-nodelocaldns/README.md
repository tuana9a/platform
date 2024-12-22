# NodeLocal DNS

https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns

```bash
kubedns=`kubectl get svc kube-dns -n kube-system -o jsonpath={.spec.clusterIP}`
domain=cluster.local
localdns=169.254.0.53
```

how to check kube-proxy is working in which mode

```bash
curl localhost:10249/proxyMode
```

kube-proxy is in iptables mode

```bash
sed -i "s/__PILLAR__LOCAL__DNS__/$localdns/g; s/__PILLAR__DNS__DOMAIN__/$domain/g; s/__PILLAR__DNS__SERVER__/$kubedns/g" nodelocaldns.yaml
```

kube-proxy is in ipvs mode

```bash
sed -i "s/__PILLAR__LOCAL__DNS__/$localdns/g; s/__PILLAR__DNS__DOMAIN__/$domain/g; s/,__PILLAR__DNS__SERVER__//g; s/__PILLAR__CLUSTER__DNS__/$kubedns/g" nodelocaldns.yaml
```