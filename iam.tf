resource "aws_iam_role" "this" {
  name               = "eks-cluster"
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.policy)
  policy_arn = join("/", ["arn:aws:iam::aws:policy", lookup(var.policy[count.index], "name")])
  role       = aws_iam_role.this.name
}