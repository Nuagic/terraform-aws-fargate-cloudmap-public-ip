resource "aws_cloudwatch_event_rule" "this" {
  event_bus_name = "default"
  event_pattern = jsonencode(
    {
      detail = {
        clusterArn    = [var.ecs_cluster_arn]
        desiredStatus = ["RUNNING"]
        group         = ["service:${var.ecs_service_name}"]
        lastStatus    = ["RUNNING"]
      }
      detail-type = ["ECS Task State Change"]
      source      = ["aws.ecs"]
    }
  )
  is_enabled = true
  name       = var.name
  tags       = var.tags
}

resource "aws_lambda_function" "this" {
  function_name    = var.name
  handler          = "lambda_function.lambda_handler"
  memory_size      = 128
  role             = "arn:aws:iam::340589625048:role/service-role/register-fluence-node-dev"
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = "python3.9"
  tags             = var.tags
  timeout          = 10
  environment {
    variables = {
      "instance_id" = var.cloudmap_instance_id
      "service_id"  = var.cloudmap_service_id
    }
  }
  depends_on = [aws_cloudwatch_log_group.this]
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_function.py"
  output_path = "lambda.zip"
}

resource "aws_iam_role" "this" {
  name = var.name
  path = "/service-role/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  inline_policy {
    name = "policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ec2:Describe*",
            "servicediscovery:RegisterInstance"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "${aws_cloudwatch_log_group.this.arn}:*"
        },
      ]
    })
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.name}"
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  arn            = aws_lambda_function.this.arn
  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.this.name
}

