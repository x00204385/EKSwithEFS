
locals {
  public_subnets = [aws_subnet.public_us_east_1a.id, aws_subnet.public_us_east_1b.id]
}

resource "aws_efs_file_system" "eks-efs" {
  creation_token = "WP-INT-FS"
  encrypted      = false

  tags = {
    Name = "EKS-efs"
  }
}

resource "aws_efs_access_point" "eks-efs-ap" {
  file_system_id = aws_efs_file_system.eks-efs.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/wordpress"

    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = 777
    }
  }
}


resource "aws_efs_mount_target" "eks-mt" {
  count = length(local.public_subnets)

  file_system_id  = aws_efs_file_system.eks-efs.id
  subnet_id       = local.public_subnets[count.index]
  security_groups = [aws_security_group.allow-efs.id]
}

resource "aws_security_group" "allow-efs" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-efs"
  description = "EFS security group allow access to port 2049"

  ingress {
    description = "allow inbound NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "allow-efs"
    Purpose = "wordpress-POC"
  }
}
