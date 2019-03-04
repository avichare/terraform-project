output "quotes_dns_name" {
  description = "The DNS name of the quotes ALB"
  value       = "${element(concat(aws_lb.backend_alb.*.dns_name, list("")), 0)}"
}

output "quotes_security_group_id" {
  description = "security group ID of quotes"
  value       = "${aws_security_group.backend_quotes_sg.*.id}"
}
