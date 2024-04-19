locals {
  lambda_basic_exec_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  lambda_functions = [
    { name        = "kinesisToStepFunction"
      runtime     = "nodejs20.x"
      handler     = "index.handler"
      description = "Lambda function to trigger Step Function from Kinesis"
      source_code = "./modules/lambda/functions/kinesisToStepFunction/index.mjs"
      environment = {
        STATE_MACHINE_ARN = var.state_machine_arn
      }
      policies = [local.lambda_basic_exec_arn, var.pull_from_kinesis_policy_arn,
        var.invoke_step_function_policy_arn
      ]
    },
    {
      name        = "s3ToKinesis"
      runtime     = "nodejs16.x"
      handler     = "index.handler"
      description = "push new events from S3 to Kinesis data stream"
      source_code = "./modules/lambda/functions/s3ToKinesis/index.js"
      environment = {
        STREAM_NAME = var.stream_name
        REGION      = var.region
      }
      policies = [local.lambda_basic_exec_arn, var.kinesis_producer_policy_arn,
      var.s3_access_policy_arn]
    }
  ]

}


module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.2"
  count   = length(local.lambda_functions)

  function_name = local.lambda_functions[count.index].name
  runtime       = local.lambda_functions[count.index].runtime
  handler       = local.lambda_functions[count.index].handler
  description   = local.lambda_functions[count.index].description
  source_path   = local.lambda_functions[count.index].source_code

  environment_variables = local.lambda_functions[count.index].environment

  # attach policy to the Lambda Function to allow access other AWS services
  attach_policies    = true
  policies           = local.lambda_functions[count.index].policies
  number_of_policies = length(local.lambda_functions[count.index].policies)
}


#################### S3 event notification for Lambda Producer ####################
# grant s3 permission to invoke lambda function 
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function[1].lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_source_bucket_arn
  depends_on    = [module.lambda_function]
}

# s3 event notification 
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_source_bucket_id

  lambda_function {
    lambda_function_arn = module.lambda_function[1].lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "AWSLogs/"
    # filter_suffix       = ".log"
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}


#################### Kinesis event source mapping ####################
resource "aws_lambda_event_source_mapping" "kinesis_event_source_mapping" {
  event_source_arn  = var.stream_arn
  function_name     = module.lambda_function[0].lambda_function_arn
  enabled           = true
  starting_position = "LATEST"
  batch_size        = 100
  depends_on        = [module.lambda_function]
}

