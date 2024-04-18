#! need to dynamically inject the lambda arn's into the state machine definition
locals {
  definition_template = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Parallel",
  "States": {
    "Parallel": {
      "Type": "Parallel",
      "Next": "Choice",
      "Branches": [
        {
          "StartAt": "processor-1",
          "States": {
            "processor-1": {
              "Type": "Task",
              "Resource": "arn:aws:states:::lambda:invoke",
              "Parameters": {
                "Payload.$": "$",
                "FunctionName": "arn:aws:lambda:us-east-1:789264351109:function:processData:$LATEST"
              },
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 1,
                  "MaxAttempts": 3,
                  "BackoffRate": 2
                }
              ],
              "End": true,
              "OutputPath": "$.Payload"
            }
          }
        },
        {
          "StartAt": "processor-2",
          "States": {
            "processor-2": {
              "Type": "Task",
              "Resource": "arn:aws:states:::lambda:invoke",
              "Parameters": {
                "Payload.$": "$",
                "FunctionName": "arn:aws:lambda:us-east-1:789264351109:function:processData-2:$LATEST"
              },
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 1,
                  "MaxAttempts": 3,
                  "BackoffRate": 2
                }
              ],
              "End": true,
              "OutputPath": "$.Payload"
            }
          }
        }
      ]
    },
    "Choice": {
      "Type": "Choice",
      "Choices": [
        {
          "Or": [
            {
              "Or": [
                {
                  "Variable": "$[0].Payload.status",
                  "StringEquals": "FAILED"
                },
                {
                  "Variable": "$[1].Payload.status",
                  "StringEquals": "FAILED"
                }
              ]
            }
          ],
          "Next": "handleFailure"
        }
      ],
      "Default": "PutObject"
    },
    "handleFailure": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:us-east-1:789264351109:function:HandleStepfunctionFailure:$LATEST"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 1,
          "MaxAttempts": 3,
          "BackoffRate": 2
        }
      ],
      "End": true
    },
    "PutObject": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "Body": {
          "status.$": "$[0].Payload.status"
        },
        "Bucket": "lab-bucket-1234",
        "Key": "MyData"
      },
      "Resource": "arn:aws:states:::aws-sdk:s3:putObject"
    }
  }
}
EOF
}

module "step-functions" {
  source      = "terraform-aws-modules/step-functions/aws"
  version     = "4.2.0"
  name        = var.state_machine_name
  definition  = var.state_machine_definition
  create_role = true
  publish     = true
  logging_configuration = {
    include_execution_data = true
    level                  = "ALL"
  }

  # TODO 
  #   service_integrations = { # will automatically create policies to attach to the role 
  #     lambda = {
  #       lambda = [var.lambda_sf_1.arn]
  #     }
  #   }

  type = "STANDARD"
}
