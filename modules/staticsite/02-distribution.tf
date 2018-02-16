// Bucket
resource "aws_s3_bucket" "default" {
  bucket = "ah-${var.bucket}"
  acl    = "private" 

  tags {
    Name = "My bucket"
  }

  #logging {
  #  target_bucket = "${aws_s3_bucket.logs.bucket}"
  #}

  website {
    index_document = "${var.index_document}"
    error_document = "${var.error_document}"
  }
}

resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = ["s3:GetObject"]

 
    resources = ["${aws_s3_bucket.default.arn}/*"] #, "${aws_s3_bucket.default.arn}"

    principals {
      type        = "AWS"
      #identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E1KLR8YE2X1J4K"]
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
  statement {
    actions = ["s3:ListBucket", "s3:PutObject", "s3:GetObject", "s3:DeleteObject"]

 
    resources = ["${aws_s3_bucket.default.arn}/*", "${aws_s3_bucket.default.arn}"]

    principals {
      type        = "AWS"
      identifiers = [""]
    }
  }
}

# resource "aws_s3_bucket" "logs" {
#   bucket = "${var.bucket}-logs"
#   acl    = "log-delivery-write"
# }


// Distribution

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "terraform-origin-access-identity-for-s3-origin"
} # É recomendado utilizar a mesma identity pra todos caso ja possua..porem não encontrei alternativa via terraform. Sugestão: http://docs.aws.amazon.com/pt_br/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html#private-content-creating-oai-console


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.default.bucket_domain_name}"
    origin_id   = "${var.bucket}"


  s3_origin_config {
    origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  }

  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  aliases = ["${var.bucket}${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
      headers = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0 #3600
    max_ttl                = 0 #86400
  }

  price_class = "${var.price_class}"



  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "BR"]
    }
  }

  tags {
    Environment = "production"
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    ssl_support_method = "sni-only"
    acm_certificate_arn =	"${var.arn_certicate}"
    minimum_protocol_version = "TLSv1.2_2018"
                          
  }
}
