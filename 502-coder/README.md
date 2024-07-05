# coder

https://coder.com/docs/v2/latest/install/kubernetes

https://coder.com/docs/v2/latest/install/offline

# uninstall

```bash
helm -n coder uninstall coder
```

# operate

## postgres

```bash
kubectl -n coder port-forward svc/postgres --address ${address:-0.0.0.0} ${port:-5432}:5432
```

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
