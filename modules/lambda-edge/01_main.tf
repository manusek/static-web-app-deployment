provider "aws" {
  alias  = "cloudfront"
  region = "us-east-1"
}


###### IAM ROLE FOR LAMBDA

resource "aws_iam_role" "lambda_edge_role" {
  name = "lambda-edge-role"


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


###### LAMBDA POLICY CONFIGURATION

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_edge_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


###### LAMBDA PERMISSION CONFIGURATION

resource "aws_lambda_permission" "allow_cloudfront" {
  provider      = aws.cloudfront
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:GetFunction"
  function_name = aws_lambda_function.add_headers.function_name
  principal     = "cloudfront.amazonaws.com"
}


###### LAMBDA ADD_HEADERS FUNCTION CONFIGURATION

resource "aws_lambda_function" "add_headers" {
  provider      = aws.cloudfront
  filename      = "${path.module}/lambda/add_headers.zip"
  function_name = "add_security_headers"
  role          = aws_iam_role.lambda_edge_role.arn
  handler       = "add_headers.handler"
  runtime       = "nodejs22.x"
  publish       = true
}