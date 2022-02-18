data "aws_instances" "instances-data" {
  instance_tags = {
    Owner = "egor_petrochenkov@epam.com"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "alb-diplom-epetr"

  load_balancer_type = "application"

  vpc_id             = data.aws_vpc.default_vpc_id.id
  subnets            = data.aws_subnet_ids.default_subnet_ids.ids
  security_groups    = [data.aws_security_group.default_sg.id]

  target_groups = [
    {
      name_prefix      = "test-"
      backend_protocol = "HTTP"
      backend_port     = 30700
      target_type      = "instance"
      targets = [
        {
          target_id = "${data.aws_instances.instances-data.ids}"[0]
          port = 30700
        },
        {
          target_id = "${data.aws_instances.instances-data.ids}"[1]
          port = 30700
        },
        {
          target_id = "${data.aws_instances.instances-data.ids}"[2]
          port = 30700
        }
      ]
    },
    {
      name_prefix      = "prod-"
      backend_protocol = "HTTP"
      backend_port     = 30900
      target_type      = "instance"
      targets = [
        {
          target_id = "${data.aws_instances.instances-data.ids}"[0]
          port = 30900
        },
        {
          target_id = "${data.aws_instances.instances-data.ids}"[1]
          port = 30900
        },
        {
          target_id = "${data.aws_instances.instances-data.ids}"[2]
          port = 30900
        }
      ]
    }
  ]

  http_tcp_listeners = [
    {
      port               = 81
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 1
    }
  ]

  tags = local.tags
}