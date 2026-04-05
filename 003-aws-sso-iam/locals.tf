locals {
  aws_accounts = {
    tuana9a = {
      id = 384588864907
    }
    t9st = {
      id = 445567113688
    }
    Atlantis = {
      id = 541645813908
    }
  }

  sso_arn               = tolist(data.aws_ssoadmin_instances.current.arns)[0]
  sso_identity_store_id = tolist(data.aws_ssoadmin_instances.current.identity_store_ids)[0]

}
