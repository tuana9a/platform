# k8s-web-forwarder

TODO: make it into jenkins pipeline

## amon-tuana9a-com

```bash
helm upgrade --install -n k8s-forwarder --debug amon-tuana9a-com ./charts/k8s-web-forwarder --values ./650-k8s-web-forwarder/amon-tuan9a-com.values.yaml
helm upgrade --install -n k8s-forwarder --debug wildcard-amon-tuana9a-com ./charts/k8s-web-forwarder --values ./650-k8s-web-forwarder/wildcard-amon-tuan9a-com.values.yaml
```

```bash
helm uninstall -n k8s-forwarder amon-tuana9a-com
helm uninstall -n k8s-forwarder wildcard-amon-tuana9a-com
```

## namnd-tuana9a-com

```bash
helm upgrade --install -n k8s-forwarder --debug namnd-tuana9a-com ./charts/k8s-web-forwarder --values ./650-k8s-web-forwarder/namnd-tuana9a-com.values.yaml
helm upgrade --install -n k8s-forwarder --debug wildcard-namnd-tuana9a-com ./charts/k8s-web-forwarder --values ./650-k8s-web-forwarder/wildcard-namnd-tuana9a-com.values.yaml
```

```bash
helm uninstall -n k8s-forwarder namnd-tuana9a-com
helm uninstall -n k8s-forwarder wildcard-namnd-tuana9a-com
```

## netchat-site

```bash
helm upgrade --install -n k8s-forwarder --debug netchat-site ./charts/k8s-web-forwarder --values ./650-k8s-web-forwarder/netchat-site.values.yaml
```

```bash
helm uninstall -n k8s-forwarder netchat-site
```

## trithuctre-com

```bash
helm upgrade --install -n k8s-forwarder --debug trithuctre-com ./charts/k8s-web-forwarder --values ./650-k8s-web-forwarder/trithuctre-com.values.yaml
```

```bash
helm uninstall -n k8s-forwarder trithuctre-com
```
