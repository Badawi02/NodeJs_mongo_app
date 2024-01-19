
resource "aws_ecr_repository" "ECR" {
  name   = "node-js_app"
  image_scanning_configuration {
    scan_on_push = true
  }
}

