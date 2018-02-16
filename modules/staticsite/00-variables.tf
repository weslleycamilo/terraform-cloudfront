# Bucket and Domain 

variable "bucket" {
  description = "The name of the S3 bucket"
}

variable "domain" {
  description = "Your domain name."

}

# Pages

variable "index_document" {
  description = "Path for the index page ."
  default     = "index.html"
}


variable "error_document" {
  description = "Path for a page to return on 404 and other errors."
  default     = "error.html"
}



# Costs 

variable price_class {
	description = "Price classes provide you an option to lower the prices you pay to deliver content out of Amazon CloudFront" 
	default = "PriceClass_All"
  #https://aws.amazon.com/pt/cloudfront/pricing/
}

# Security


variable arn_certicate {
	description = "Define the arn Certificate which you would like to use" 
	default = ""

}

