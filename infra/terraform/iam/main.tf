# wordpress profile
resource "aws_iam_instance_profile" "wordpress_profile" {
  name = "wordpress_profile"
  role = aws_iam_role.wordpress_role.name
}

# Assume Role policy for EC2
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


# IAM Role
resource "aws_iam_role" "wordpress_role" {
  name               = "wordpress_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.wordpress_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3-access" {
  role       = aws_iam_role.wordpress_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}