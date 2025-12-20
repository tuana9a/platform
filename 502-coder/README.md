# coder

https://coder.com/docs/v2/latest/install/kubernetes

https://coder.com/docs/v2/latest/install/offline

# setup

## postgres

```bash
kubectl run --rm -it pg-tmp --image=postgres:16 bash
```

```sql
CREATE USER coder WITH PASSWORD 'your_password_here';
CREATE DATABASE coder OWNER coder;
GRANT ALL PRIVILEGES ON DATABASE coder TO coder;
```

```sql
\c coder

GRANT ALL ON SCHEMA public TO coder;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO coder;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO coder;

-- Ensure future tables are included
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO coder;
```

## `coder-env`

```bash
# db
CODER_PG_CONNECTION_URL="postgres://coder:pass@postgres.coder.svc.cluster.local/coder?sslmode=disable"
# oidc
CODER_OIDC_CLIENT_ID=""
CODER_OIDC_CLIENT_SECRET=""
```

# docker images

TODO