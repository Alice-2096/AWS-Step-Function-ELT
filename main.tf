terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.region
}

#################### Kinesis ####################
module "kms" {
  source = "./modules/kms"
}

module "kinesis" {
  source              = "./modules/kinesis"
  stream_name         = var.stream_name
  shard_count         = var.shard_count
  retention_period    = var.retention_period
  kinesis_kms_key_arn = module.kms.kinesis_kms_key_arn
}

#################### Step Functions ####################
module "step_functions" {
  source                   = "./modules/step_functions"
  state_machine_name       = var.state_machine_name
  state_machine_definition = var.state_machine_definition
}

#################### S3 #################### 
module "s3" {
  source       = "./modules/s3"
  kms_key_arn  = module.kms.s3_source_kms_key_arn
  project_name = var.project_name
}

#################### IAM ####################
module "iam" {
  source               = "./modules/iam"
  s3_source_bucket_arn = module.s3.bucket_arn
  stream_arn           = module.kinesis.stream_arn
  state_machine_arn    = module.step_functions.state_machine_arn
}

#################### Lambda ####################
module "lambda" {
  source                          = "./modules/lambda"
  region                          = var.region
  state_machine_arn               = module.step_functions.state_machine_arn
  stream_name                     = module.kinesis.stream_name
  s3_source_bucket_arn            = module.s3.bucket_arn
  s3_source_bucket_id             = module.s3.bucket_id
  s3_access_policy_arn            = module.iam.s3_access_policy_arn
  pull_from_kinesis_policy_arn    = module.iam.kinesis_consumer_access_policy_arn
  invoke_step_function_policy_arn = module.iam.invoke_step_function_policy_arn
  kinesis_producer_policy_arn     = module.iam.kinesis_producer_access_policy_arn
}

