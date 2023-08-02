## Security group
resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = var.sg_subnet_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags       = merge({ Name = "${var.component}-${var.env}" }, var.tags)
}


resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${var.component}-${var.env}"
  description                = "${var.component}-${var.env}"
  engine                     =  var.engine
  engine_version             =  var.engine_version
  automatic_failover_enabled =  true
  node_type                  =  var.node_type
  num_cache_clusters         =  var.num_cache_clusters
  parameter_group_name       = "default.redis6.x.cluster.on"
  replicas_per_node_group    =  var.replicas_per_node_group
  security_group_ids         = [aws_security_group.main.id]
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  kms_key_id                = var.kms_key_arn
  at_rest_encryption_enabled = true


}