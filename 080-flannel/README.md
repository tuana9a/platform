# flannel

## Working with iptables

To see every thing

```bash
iptables-save
```

And to see only table names:

```bash
iptables-save | grep '^*'
```

See some flannel stuffs

```bash
iptables -t nat -L
```

An example route grafana service
- 10.233.208.212:80 -> 10.244.9.102:3000

```js
Chain KUBE-SERVICES (2 references)
target     prot opt source               destination         
KUBE-SVC-FQRDHG6MUQQJ56BJ  tcp  --  anywhere             10.233.208.212       /* grafana/grafana:service cluster IP */ tcp dpt:http
```

```js
Chain KUBE-SVC-FQRDHG6MUQQJ56BJ (1 references)
target     prot opt source               destination         
KUBE-MARK-MASQ  tcp  -- !10.244.0.0/16        10.233.208.212       /* grafana/grafana:service cluster IP */ tcp dpt:http
KUBE-SEP-GAZ5UDV6NTJ25A3T  all  --  anywhere             anywhere             /* grafana/grafana:service -> 10.244.9.102:3000 */
```

```js
Chain KUBE-SEP-GAZ5UDV6NTJ25A3T (1 references)
target     prot opt source               destination         
KUBE-MARK-MASQ  all  --  10.244.9.102         anywhere             /* grafana/grafana:service */
DNAT       tcp  --  anywhere             anywhere             /* grafana/grafana:service */ tcp to:10.244.9.102:3000
```
