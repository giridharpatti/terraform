terraform {
 backend "s3" {
   bucket         = "giriterraform"
   key            = "tfstate/terraform.tfstate"
   region         = "ap-south-1"
 }
}
