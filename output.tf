output "environment"  {  value = local.environment   }
output "vpc-id"       {  value = data.terraform_remote_state.infrastructure.outputs.vpc-id   }
output "account-id"   {  value = data.terraform_remote_state.infrastructure.outputs.account-id   }