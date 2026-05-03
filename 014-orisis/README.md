# orisis

https://github.com/openpubkey/opkssh/

`sshd_config`

```conf
AuthorizedKeysCommand /usr/local/bin/opkssh verify %u %k %t
AuthorizedKeysCommandUser opksshuser
```

add a user

```bash
sudo opkssh add tuana91a tuana91a@gmail.com google
```
