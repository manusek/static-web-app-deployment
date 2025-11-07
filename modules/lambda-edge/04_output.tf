output "lambda_edge_arn" {
  value = aws_lambda_function.add_headers.qualified_arn
}