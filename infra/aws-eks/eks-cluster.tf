resource "aws_eks_cluster" "eks-cluster-tf" {
  name     = var.cluster-name
  role_arn = data.aws_iam_role.eks_role.arn

  vpc_config {
    security_group_ids = [data.aws_security_group.default_sg.id]
    subnet_ids = data.aws_subnet_ids.default_subnet_ids.ids
  }

  tags = {
        Owner       = "egor_petrochenkov@epam.com"
        Environment = "test"
      }
}