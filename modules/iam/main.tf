resource "aws_iam_policy" "kinesis_producer_access" {
  name        = "LambdaToKinesis"
  description = "Allow Lambda to put records to Kinesis"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ],
        "Resource" : var.stream_arn
      }
    ]
  })
}

resource "aws_iam_policy" "invoke_step_function" {
  name        = "InvokeStepFunction"
  description = "Allow Lambda to invoke Step Function"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "states:*",
        "Resource" : var.state_machine_arn
      }
    ]
  })
}

resource "aws_iam_policy" "pull_from_kinesis" {
  name        = "allow_kinesis_access"
  description = "Allow lambda to access kinesis data stream"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "kinesis:*",
        "Resource" : var.stream_arn
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access" {
  name        = "allow_s3_access"
  description = "Allow lambda to access S3 bucket"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [var.s3_source_bucket_arn, "${var.s3_source_bucket_arn}/*"]
      }
    ]
  })
}

resource "aws_iam_policy" "kms_decrypt_kinesis_policy" {
  name        = "KMSDecryptKinesis"
  description = "Allow Lambda to decrypt Kinesis data stream"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "kms:Decrypt",
        "Resource" : "*" //! This is a security risk
      }
    ]
  })
}
