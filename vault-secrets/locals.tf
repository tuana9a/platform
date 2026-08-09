locals {
  all_secrets    = merge([for x in fileset(path.cwd, "${var.secret_dir}/*.yml") : yamldecode(file(x))]...)
  all_secrets_v2 = merge([for x in fileset(path.cwd, "${var.secret_v2_dir}/*.yml") : yamldecode(file(x))]...)
}
