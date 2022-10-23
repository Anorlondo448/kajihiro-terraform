###
#
# Launch Template
#
resource "aws_launch_template" "ecs_optimized" {
  name_prefix   = "optimized"
  image_id      = "${data.aws_ami.ecs_optimized.id}"
  instance_type = "m5.xlarge"

  user_data = base64encode(data.template_file.userdata.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance.name
  }

}

# AMI
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# userdata
data "template_file" "userdata" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    ecs_cluster_name = aws_ecs_cluster.main.name
  }
}