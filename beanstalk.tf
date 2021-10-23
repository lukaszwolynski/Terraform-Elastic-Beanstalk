resource "aws_elastic_beanstalk_application" "application" {
  name        = var.appName
  description = var.appDescription
}

resource "aws_elastic_beanstalk_environment" "environment" {
  name                = var.envName
  application         = aws_elastic_beanstalk_application.application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.7 running Python 3.8"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  version_label = aws_elastic_beanstalk_application_version.default.name
}



resource "aws_s3_bucket" "appBucket" {
  bucket = local.bucketName
}

resource "aws_s3_bucket_object" "appBucketObject" {
  bucket = aws_s3_bucket.appBucket.id
  key    = "Application.zip"
  source = "Application.zip"
  etag   = filemd5("application.py")
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = var.appName
  application = var.appName
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.appBucket.id
  key         = aws_s3_bucket_object.appBucketObject.id

  depends_on = [aws_s3_bucket.appBucket, aws_s3_bucket_object.appBucketObject]
}
