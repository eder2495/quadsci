data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_role" "dev_ssm" {
  name = "${var.name_prefix}-dev-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.dev_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "dev_ssm" {
  name = "${var.name_prefix}-dev-instance-profile"
  role = aws_iam_role.dev_ssm.name
}

resource "aws_instance" "dev" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = aws_iam_instance_profile.dev_ssm.name
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    home_mount = "/home/ec2-user"
    home_user  = "ec2-user"
  })

  tags = { Name = "${var.name_prefix}-dev-al2023" }
}

resource "aws_ebs_volume" "home_data" {
  availability_zone = aws_instance.dev.availability_zone
  size              = var.home_volume_size
  type              = "gp3"
  encrypted         = true

  tags = { Name = "${var.name_prefix}-dev-home-ebs" }
}

resource "aws_volume_attachment" "home_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.home_data.id
  instance_id = aws_instance.dev.id
}

output "instance_id" {
  value = aws_instance.dev.id
}

output "private_ip" {
  value = aws_instance.dev.private_ip
}