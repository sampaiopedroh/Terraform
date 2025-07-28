resource "aws_iam_role" "beanstalk_ec2" {
  name = "beanstalk-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "beanstalk_ec2_policy" {
  name = "beanstalk-ec2-policy"
  role = aws_iam_role.beanstalk_ec2.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ds:*",
          "ec2:*",
          "logs:*",
          "ssm:*",
          "ec2messages:*",
          "ecr:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "beanstalk_ec2_profile" {
  name = "ec2-beanstalk-profile"
  role = aws_iam_role.beanstalk_ec2.name
}