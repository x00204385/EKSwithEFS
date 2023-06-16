
resource "aws_db_subnet_group" "wordpress-db-subnetgroup" {
  name       = "wordpress-db-subnetgroup"
  # subnet_ids = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]

  subnet_ids = [
    aws_subnet.public_us_east_1a.id,
    aws_subnet.public_us_east_1b.id
  ]

  tags = {
    Name = "Wordpress DB subnet group"
  }
}


resource "aws_security_group" "allow-mysql" {
  name   = "allow-mysql"
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "allow-mysql"
    Purpose = "wordpress-POC"
  }

}

# Ingress Security Port 3306
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.allow-mysql.id
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Create MySQL RDS instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
#
resource "aws_db_instance" "wordpress-rds" {
  allocated_storage      = 20
  db_name                = "wp"
  identifier             = "wp-rdsdb"
  engine                 = "mysql"
  engine_version         = "5.7.42"
  storage_type           = "gp2"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  db_subnet_group_name   = "wordpress-db-subnetgroup"
  vpc_security_group_ids = ["${aws_security_group.allow-mysql.id}"]
  publicly_accessible    = true

  depends_on = [aws_db_subnet_group.wordpress-db-subnetgroup, aws_internet_gateway.igw]

  tags = {
    Name = "wordpress-internet-gw"
  }

}
