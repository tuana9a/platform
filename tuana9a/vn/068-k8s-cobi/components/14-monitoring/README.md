# loki

```promql
sum by (namespace) (count_over_time({namespace=~".+"} [1h]))
```

# promtail
