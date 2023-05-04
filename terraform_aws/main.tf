//create ecr
resource "aws_ecr_repository" "test" {
  name                 = "rabindra-test"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
//Create eks