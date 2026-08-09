# coder templates

contains coder templates for using with kubernetes

# how-to

To push template to coder server first time

```bash
coder login coder.tuana9a.com
```

```bash
cd statefulset
```

```bash
coder template push --variables-file vars.yml
```

To update template just

```bash
coder template push
```

# known issues

Mount docker data over nfs will not work, See https://github.com/docker/for-linux/issues/1172#issuecomment-771647647
