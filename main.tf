//  Setup the core provider information.
provider "aws" {
  region  = "${var.region}"
}


terraform {
  backend "s3" {
    bucket = "${var.bucket}"
    key    = "tfstate/camiloweslley"
    region = "us-east-1"
  }
}

module "staticsite" {
  source = "./modules/staticsite"

}
