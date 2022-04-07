data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = "../pawnflow"
  output_path = "build/source.zip"
}

data "archive_file" "lambda_exe" {
  depends_on  = [null_resource.build_code]
  type        = "zip"
  source_dir  = "../build/pawnflow"
  output_path = "build/pawnflow.zip"
}

resource "null_resource" "build_code" {
  triggers = {
    src_hash = data.archive_file.lambda_source.output_sha
  }

  provisioner "local-exec" {
    command = <<EOF
make build
       EOF
  }
}

resource "aws_lambda_function" "debug_endpoint_function" {
  depends_on       = [null_resource.build_code]
  function_name    = "${local.name_prefix}-debug"
  filename         = data.archive_file.lambda_exe.output_path
  handler          = "pawnflow"
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  runtime          = "go1.x"
  role             = aws_iam_role.iam_for_lambda.arn
  tags             = local.tags
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
