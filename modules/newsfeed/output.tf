output "newsfeed_dns_name" {
  description = "The DNS name of the newsfeed ALB"
  value       = "${element(concat(aws_lb.backend_alb.*.dns_name, list("")), 0)}"
}

output "newsfeed_security_group_id" {
  description = "security group ID of newsfeed"
  value       = "${aws_security_group.backend_newsfeed_sg.*.id}"
}
