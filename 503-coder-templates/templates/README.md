# coder templates

To push template to coder server first time

```bash
coder template push --variables-file vars.yml
```

following push

```bash
coder template push
```

## known issues

Mount docker data over nfs will not work, See https://github.com/docker/for-linux/issues/1172#issuecomment-771647647
