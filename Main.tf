terraform{

resource "aws_subnet" "private" {
  vpc_id            = vpc-0de2bfe0f5fc540e0
  cidr_block        = "10.0.1.0/16"
  availability_zone = "eu-west-1"
}

resource "aws_route_table" "private" {
  vpc_id = vpc-0de2bfe0f5fc540e0
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = nat-07863fc48f5b99110
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "terraform-aws-modules/s3-bucket/aws" {
  S3_Bucket= "3.devops.candidate.exam"
  Region= "eu-west-1"
  Key= "<pratik>.<more>"
}
resource "aws_lambda_function" "example" {
  filename         = "example.zip"
  function_name    = "example_function"
  role             = data.aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = filebase64sha256("example.zip")
}

resource "aws_security_group" "example" {
  name_prefix = "example_security_group"
  vpc_id      = vpc-0de2bfe0f5fc540e0

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
}
