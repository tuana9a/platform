# coder

https://coder.com/docs/v2/latest/install/kubernetes

https://coder.com/docs/v2/latest/install/offline

# images

See [docker/coder/](../docker/coder/)

# config

`postgres`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-env
  namespace: coder
data:
  POSTGRES_USER: "root"
  POSTGRES_PASSWORD: ""
```

`coder-env`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coder-env
  namespace: coder
data:
  # db
  CODER_PG_CONNECTION_URL: "postgres://coder:pass@postgres.coder.svc.cluster.local/coder?sslmode=disable"
  # login with google
  CODER_OIDC_ALLOW_SIGNUPS: "false"
  CODER_OIDC_SIGN_IN_TEXT: "Login with Google"
  CODER_OIDC_ISSUER_URL: "https://accounts.google.com"
  CODER_OIDC_EMAIL_DOMAIN: "gmail.com"
  CODER_OIDC_CLIENT_ID: ""
  CODER_OIDC_CLIENT_SECRET: ""
  # bellow is for offline deployment https://coder.com/docs/v2/latest/install/offline
  CODER_TELEMETRY_ENABLE: "false"
  CODER_DERP_SERVER_STUN_ADDRESSES: "disable" # Only use relayed connections
  CODER_BLOCK_DIRECT: "true" # force SSH traffic through control plane's DERP proxy
```
