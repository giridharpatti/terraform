terraform {
 backend "s3" {
   bucket         = "giriterraform"
   key            = "terraform.tfstate"
   region         = "var.region"
 }
}
