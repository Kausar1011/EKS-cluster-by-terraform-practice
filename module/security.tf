# Security Group for EKS Cluster
resource "aws_security_group" "eks_security_group" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  # Allow inbound traffic from worker nodes to control plane
  ingress {
    description      = "Allow worker nodes communication with control plane"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-security-group"
  }
}

# Security Group for Worker Nodes
resource "aws_security_group" "worker_nodes_security_group" {
  name        = "${var.cluster_name}-worker-nodes-sg"
  description = "Security group for worker nodes"
  vpc_id      = module.vpc.vpc_id

  # Allow inbound traffic from control plane to worker nodes
  ingress {
    description      = "Allow control plane communication to worker nodes"
    from_port        = 1025
    to_port          = 65535
    protocol         = "tcp"
    security_groups  = [aws_security_group.eks_security_group.id]
  }

  # Allow inbound traffic from within the same security group
  ingress {
    description      = "Allow internal traffic within worker nodes"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-worker-nodes-security-group"
  }
}

# Security Group Rules for Additional Ports (Optional)
resource "aws_security_group_rule" "allow_k8s_api_server" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_security_group.id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Restrict this to trusted IPs in production
  security_group_id = aws_security_group.worker_nodes_security_group.id
}

# Tags for Resources
output "eks_security_group_id" {
  value = aws_security_group.eks_security_group.id
}

output "worker_nodes_security_group_id" {
  value = aws_security_group.worker_nodes_security_group.id
}
