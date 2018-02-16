 #### Terraform-CloudFront


Go to the project terraform-cloudfront and change the fields below:

- ./variables.tf

```

variable "bucket" {
  description = "The name of the S3 bucket  to create."
  default = "camiloweslley"
}


variable "domain" {
  description = "Your domain name."
  default = "camiloweslley.com.br"

}

Go to AWS Certificate Manager and request a certificate, after it insert the arn code in the variable below.

variable arn_certicate {
	description = "Define the arn Certificate which you would like to use" 
	default = ""

}

```

- ./main.tf

```

Define the name of the project which you would like to save on s3.

terraform {
  backend "s3" {
    bucket = "${var.bucket}"
    key    = "tfstate/<PROJETO>"
    region = "us-east-1"
  }
}

```

- ./02-distribution.tf

```

Get the arn of the user which has the permission to create the cloudfront settings.

    principals {
      type        = "AWS"
      identifiers = ["<arn of the user>"]
    }


```

   - cd terraform-cloudfrot 
   - terraform init
   - terraform apply 


