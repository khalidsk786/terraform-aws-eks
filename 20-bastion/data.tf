data "aws_ssm_parameter" "bastion_sg_id" { # this is for Query parameter store value
  name = "/${var.project_name}/${var.environment}/bastion_sg_id" # This is the path to the parameter
}
data "aws_ssm_parameter" "public_subnet_ids" { # this is for Query parameter store value
  name = "/${var.project_name}/${var.environment}/public_subnet_ids" # This is the path to the parameter
}