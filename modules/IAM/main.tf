data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "consul-redis" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = ["ec2:DescribeInstances"]
  }
}


//creating a role
resource "aws_iam_role" "ec2-role" {
  name = var.role_name
  description = "The role definition"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

//creating a policy
resource "aws_iam_policy" "aws-policies" {
  name   = var.policy_name
  description = "The policy definition"
  policy = data.aws_iam_policy_document.consul-redis.json
}

//Attach the policy
resource "aws_iam_policy_attachment" "consul-redis" {
  name       = "consul-redis"
  roles      = [aws_iam_role.ec2-role.name]
  policy_arn = aws_iam_policy.aws-policies.arn
}

//Creating instance profile

resource "aws_iam_instance_profile" "consul-redis" {
  name = "consul-redis"
  role = aws_iam_role.ec2-role.name
}