module "cloudfront_auth" {
  source = "../"

  auth_vendor             = "cognito"
  authz                   = "2"  # Is this a number or a name?
  cloudfront_distribution = "private.example.com"
  cloudfront_aliases      = ["secret.example.com"]
  base_uri                = "https://auth-xxxxxx.auth.us-east-1.amazoncognito.com"
  client_id               = "CHANGE_ME"
  client_secret           = "CHANGE_ME"
  nodejs_version          = "12.18.0"
  redirect_uri            = "https://private.example.com/callback"

  bucket_name                    = "private.example.com"
  region                         = "eu-west-1"
  # TODO: probably wrong
  bucket_access_roles_arn_list   = []
  cloudfront_acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
}

resource "aws_acm_certificate" "cert" {
  provider          = "aws.us-east-1"
  domain_name       = "example.com"
  validation_method = "EMAIL"
  subject_alternative_names = [
    "*.example.com"
  ]
}

// A test object for the bucket.
resource "aws_s3_bucket_object" "test_object" {
  bucket       = module.cloudfront_auth.s3_bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = md5(file("${path.module}/index.html"))
}
