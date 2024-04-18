variable "state_machine_name" {
  description = "The name of the state machine"
  type        = string
}
variable "state_machine_definition" {
  description = "The definition of the state machine"
  type        = string
  default     = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
      "End": true
    }
  }
}
EOF 
}

