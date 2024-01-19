data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster_role" {
  name               = "eks-cluster_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

# Optionally, enable Security Groups for Pods
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "cluster" {
  name     = "cluster"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = [
      module.subnet_2.subnet_2_id,
      module.subnet.subnet_id
    ]
    security_group_ids = [module.security_group_public.security_group_id]
    endpoint_private_access = true
  }

  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy, aws_iam_role_policy_attachment.AmazonEKSVPCResourceController]
}

