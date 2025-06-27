resource "random_password" "amon" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "coderd_user" "amon" {
  username   = "adrazaamon"
  email      = "adrazaamon@gmail.com"
  name       = "Amon Ad-Raza"
  login_type = "password"
  password   = random_password.amon.result

  lifecycle {
    ignore_changes = [password]
  }
}

resource "coderd_user" "long7" {
  username   = "longduongxx86"
  email      = "longduongxx86@gmail.com"
  login_type = "oidc"
}
