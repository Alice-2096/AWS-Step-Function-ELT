output "state_machine_arn" {
  description = "The ARN of the state machine"
  value       = module.step-functions.state_machine_arn
}
