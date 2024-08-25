# kubernetes

First push

```bash
coder template push --variables-file vars.yml
```

# known issues

Mount docker data over nfs will not work

https://github.com/docker/for-linux/issues/1172#issuecomment-771647647

>@jjengla Is your $HOME/.local/share/docker is on NFS? Then probably it does not work.
