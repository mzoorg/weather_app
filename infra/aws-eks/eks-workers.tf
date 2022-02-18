data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks-cluster-tf.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster-tf.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster-tf.certificate_authority[0].data}' '${var.cluster-name}'
USERDATA

}

resource "aws_launch_configuration" "launch-config-tf" {
  associate_public_ip_address = true
  iam_instance_profile = data.aws_iam_role.eks_nodegroup_role.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t3.medium"
  name_prefix = "launch-eks-epetr"
  security_groups = [data.aws_security_group.default_sg.id, data.aws_security_group.vpn_sg.id]
  user_data_base64 = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "as-group-tf" {
  desired_capacity = 3
  launch_configuration = aws_launch_configuration.launch-config-tf.id
  max_size = 5
  min_size = 2
  name = "as-eks-epetr"

  vpc_zone_identifier = data.aws_subnet_ids.default_subnet_ids.ids

  tag {
    key = "kubernetes.io/cluster/${var.cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }

  tag {
    key = "Owner"
    value = "egor_petrochenkov@epam.com"
    propagate_at_launch = true
  }
}

