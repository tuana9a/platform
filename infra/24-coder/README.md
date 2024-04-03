# coder

# setup

## prepare database

create user coder

```sql
TODO
```

create database coder

```sql
TODO
```

change owner of database to coder

```sql
TODO
```

## install

https://coder.com/docs/v2/latest/install/kubernetes

https://coder.com/docs/v2/latest/install/offline

```bash
kubectl create namespace coder
```

```bash
kubectl apply -f coder-database-url.yaml
```

```bash
echo -n 'postgres://coder:12341234@192.168.56.11/coder?sslmode=disable' | base64 -w 0
```

```bash
helm install coder coder-v2/coder --namespace coder --values values.yaml
```

```bash
helm uninstall coder -n coder
```
