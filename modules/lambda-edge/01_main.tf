provider "aws" {
  alias  = "cloudfront"
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_edge_role" {
  name = "lambda-edge-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
           Service = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

# 2. Polityka wykonania dla funkcji Lambda
# Jest to standardowa polityka pozwalająca na zapis logów do CloudWatch.
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_edge_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 3. Dodanie uprawnień CloudFront do wywoływania funkcji Lambda
# Jest to kluczowy, brakujący element. CloudFront musi mieć uprawnienia do wywołania funkcji.
resource "aws_lambda_permission" "allow_cloudfront" {
  provider      = aws.cloudfront
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:GetFunction"
  function_name = aws_lambda_function.add_headers.function_name
  principal     = "cloudfront.amazonaws.com"
}

# 4. Kod źródłowy funkcji Lambda
# Upewnij się, że masz plik 'lambda/add_security_headers.zip' w swoim projekcie Terraform.
resource "aws_lambda_function" "add_headers" {
  provider      = aws.cloudfront
  filename      = "${path.module}/lambda/add_headers.zip"
  function_name = "add_security_headers"
  role          = aws_iam_role.lambda_edge_role.arn
  handler       = "add_headers.handler"
  runtime       = "nodejs22.x"
  publish       = true
}