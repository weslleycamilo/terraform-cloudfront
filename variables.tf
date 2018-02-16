

//  The region we will deploy our cluster into.
variable "region" {
  description = "Region to deploy the cluster into"
  //  The default below will be fine for many, but to make it clear for first
  //  time users, there's no default, so you will be prompted for a region.
  default = "us-east-1"
}

variable "bucket" {
  description = "The name of the S3 bucket."
  default = "camiloweslley"
}


variable "domain" {
  description = "Your domain name."
  default = "camiloweslley.com.br"

}
