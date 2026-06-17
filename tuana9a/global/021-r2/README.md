# r2

# scripts

```bash
export AWS_ACCESS_KEY_ID=$(vault kv get -field=aws_access_key_id kv/cloudflare/accounts/tuana9a/api-tokens/edit-r2)
export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=aws_secret_access_key kv/cloudflare/accounts/tuana9a/api-tokens/edit-r2)
export S3_ENDPOINT_URL="https://$(vault kv get -field=cloudflare_account_id kv/cloudflare/accounts/tuana9a/api-tokens/edit-r2).r2.cloudflarestorage.com"
```

```bash
alias r2='aws s3api --endpoint-url "$S3_ENDPOINT_URL"'
```

## List buckets

```bash
r2 list-buckets --query "Buckets[].Name" | jq -r ".[]"
```

## Select bucket

```bash
export BUCKET_NAME=$(r2 list-buckets --query "Buckets[].Name" | jq -r ".[]" | fzf)
```

## List objects in a bucket

```bash
r2 list-objects-v2 --bucket "$BUCKET_NAME" --query "Contents[].Key" | jq -r ".[]"
```

## List objects in a bucket with size

```bash
r2 list-objects-v2 --bucket "$BUCKET_NAME" --query "Contents[].{Key:Key,Size:Size}" | jq -r ".[] | [.Key,.Size] | @tsv"
```

## Search objects in a bucket by prefix

```bash
r2 list-objects-v2 --bucket "$BUCKET_NAME" --prefix $OBJECT_PREFIX --query "Contents[].Key" | jq -r ".[]"
```

## Search objects in a bucket by prefix with size

```bash
r2 list-objects-v2 --bucket "$BUCKET_NAME" --prefix $OBJECT_PREFIX --query "Contents[].{Key:Key,Size:Size}" | jq -r ".[] | [.Key,.Size] | @tsv"
```

## Get object

```bash
r2 get-object --bucket "$BUCKET_NAME" --key $OBJECT_KEY $FILEPATH
```

## Upload object

```bash
r2 put-object --bucket "$BUCKET_NAME" --key $OBJECT_KEY --body $FILEPATH
```

## Delete object

```bash
r2 delete-object --bucket "$BUCKET_NAME" --key $OBJECT_KEY
```
