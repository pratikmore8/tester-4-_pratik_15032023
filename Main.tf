resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.selected.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.selected.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
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
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8"
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
