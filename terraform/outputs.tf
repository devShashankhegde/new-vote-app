output "public_ip" {
  description = "Public IP of the voting app"
  value       = aws_eip.voting_app_eip.public_ip
}

output "app_url" {
  description = "URL to access the voting app"
  value       = "http://${aws_eip.voting_app_eip.public_ip}:5000"
}