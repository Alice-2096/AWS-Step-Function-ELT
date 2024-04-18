variable "region" {
  description = "The AWS region to deploy resources."
  default     = "us-east-1"
}
variable "project_name" {
  description = "Unique name for this project"
  type        = string
  default     = "nyu-al"
}

#################### Kinesis #################### 
variable "stream_name" {
  description = "The name of the Kinesis stream"
}
variable "shard_count" {
  description = "The number of shards for the Kinesis stream"
}
variable "retention_period" {
  description = "The number of hours to retain data in the stream"
  default     = 24
}

#################### Step function ####################
variable "state_machine_name" {
  description = "The name of the state machine"
}
variable "state_machine_definition" {
  description = "The definition of the state machine"
  type        = string
}
