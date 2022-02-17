data "aws_iam_role" "eks_role" {
  name = "eks_role"
}

data "aws_iam_role" "eks_nodegroup_role" {
  name = "EKS_nodegroup_role"
}