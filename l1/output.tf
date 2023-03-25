output "db_arn" {
  value = aws_db_instance.this.arn
}

output "script" {
  value = data.external.dbuser.result
}