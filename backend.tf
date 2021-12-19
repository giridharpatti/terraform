terraform {
 backend "s3" {
   bucket         = "giriterraform"
   key            = "terraform.tfstate"
   region         = "ap-south-1"
 }
}
