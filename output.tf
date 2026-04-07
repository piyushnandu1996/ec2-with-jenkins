output "server_name" {
  description = "server name"
  value       = aws_instance.gloabl_server
}

output "security_group_name" {
  description = "firewall"
  value       = aws_security_group.firewall

}