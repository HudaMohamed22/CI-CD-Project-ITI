# Step 1: Create RDS DB Subnet Group
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [module.network.M-subnets["private1"].id ,module.network.M-subnets["private2"].id] # Specify private subnets ID
}

# Step 2: Create Security Group for RDS
resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "Allow inbound traffic on port 3306 for RDS"
  vpc_id      = module.network.M-vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere
  }
}

# Step 3: Create RDS DB Instance
resource "aws_db_instance" "my_db_instance" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  db_name              = "tfDB"
  username             = "admin"
  password             = "password123"
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name //(create subnet group in case i need by DB on more that one private subnet )
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.rds_security_group.id, ]
                             # Include any other security groups if needed

}


# Step 4: Create Elasticache Subnet Group
resource "aws_elasticache_subnet_group" "my_elasticache_subnet_group" {
  name       = "my-elasticache-subnet-group"
  subnet_ids = [module.network.M-subnets["private1"].id] # Specify private subnet ID
}

# Step 5: Create Security Group for ElastiCache
resource "aws_security_group" "elasticache_security_group" {
  name        = "elasticache-security-group"
  description = "Allow inbound traffic on port 6379 for ElastiCache"
  vpc_id      = module.network.M-vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# Step 6: Create ElastiCache Cluster
resource "aws_elasticache_cluster" "my_elasticache_cluster" {
  cluster_id               = "my-elasticache-cluster"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.my_elasticache_subnet_group.name
  security_group_ids = [aws_security_group.elasticache_security_group.id,]

}
