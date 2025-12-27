# CHANGELOG

yyyy-mm-dd

# 2025-12-27

```bash
kubectl run --rm -it pg-tmp --image=postgres:16 bash
```

or (if already exist)

```bash
kubectl -n default attach -i -t pg-tmp
```

```bash
export PGPASSWORD=$(cat .pgpass)

pg_dump -U coder -h patroni-postgres-16.pool.svc.cluster.local -Fc coder > db_backup.dump
pg_restore -U coder -h pg-purple.pool.svc.cluster.local -d coder db_backup.dump
```
