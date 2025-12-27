locals {
  all_secrets = merge([for x in fileset(path.cwd, "${var.secret_dir}/*.yml") : yamldecode(file(x))]...)
}
