#------------------------------
# Lambda
#------------------------------
resource "aws_lambda_function" "lambda" {
  filename = "./handler.zip"
  function_name = "${var.project}-${var.env}-lambda"
  role          = aws_iam_role.lambda-role.arn
  handler       = "handler"
  runtime       = "go1.x"
  environment {
    variables = {
      USER = "dbuser"
    }
  }
  vpc_config {
    security_group_ids = [aws_security_group.lambda-sg.id]
    subnet_ids         = [aws_subnet.private_subnet-1a.id]
  }

  tags = {
    Name    = "${var.project}-${var.env}-lambda"
    Project = var.project
    Env     = var.env
  }
}