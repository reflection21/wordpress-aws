# service role
resource "aws_iam_role" "wordpress_role" {
  name               = "wordpress_role_test"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
# for ssm access
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.wordpress_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# wordpress profile
resource "aws_iam_instance_profile" "wordpress_profile" {
  name       = "wordpress_profil_test"
  role       = aws_iam_role.wordpress_role.name
  depends_on = [aws_iam_role.wordpress_role]
}
# resource "aws_iam_role_policy_attachment" "s3-access" {
#   role       = aws_iam_role.wordpress_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }
