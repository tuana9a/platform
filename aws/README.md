# Output

ec2 instances

![](./imgs/Screenshot%20from%202022-06-21%2018-29-27.png)

cloudflare dns

![](./imgs/Screenshot%20from%202022-06-21%2018-30-29.png)

# How to run

remove **`.example`** from `variables.auto.tfvars.example*`

variables.auto.tfvars explaination

| Name                           | Example                  | Description                                                                                          |
| ------------------------------ | ------------------------ | ---------------------------------------------------------------------------------------------------- |
| `aws_region`                   | `us-east-1`              |                                                                                                      |
| `aws_credential_files`         | `["~/.aws/credentials"]` | See [AWS doc](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for details |
| `aws_ec2_instance_names`       | `["1", "2", "3"]`        | list.length is number of instance                                                                    |
| `aws_ec2_instance_tyoe`        | `t2.mirco`               | **OPTIONAL**                                                                                         |
| `aws_key_pair_name`            |                          |                                                                                                      |
| `aws_key_pair_public_key_file` | `~/.ssh/id_rsa.pub`      | path to public key file                                                                              |
| `cloudflare_email`             |                          |                                                                                                      |
| `cloudflare_api_token`         |                          |                                                                                                      |
| `cloudflare_zone_id`           |                          |                                                                                                      |
