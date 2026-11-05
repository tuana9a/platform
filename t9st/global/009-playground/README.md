# playground

```bash
kubeadm init \
  --control-plane-endpoint='3.1.164.162' \
  --pod-network-cidr='10.244.0.0/16' \
  --service-cidr='10.233.0.0/16'
```

```bash
kubectl annotate node ip-10-2-2-13 io.cilium.network.ipv4-pub-ip=52.74.37.76
```

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

helm repo add cilium https://helm.cilium.io/
helm repo update

helm install cilium cilium/cilium \
  --namespace kube-system \
  -f values.yml

helm upgrade cilium cilium/cilium -n kube-system -f ./values.yml 
```

```bash
wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb
sudo apt install ./k9s_linux_amd64.deb
rm k9s_linux_amd64.deb
```
