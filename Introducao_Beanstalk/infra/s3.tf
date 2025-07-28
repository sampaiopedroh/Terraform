resource "aws_s3_bucket" "beanstalk_deploys" {
  bucket = "${var.nomeBucket}-deploys"
}

resource "aws_s3_bucket_object" "docker" {
    depends_on = [
      aws_s3_bucket.beanstalk_deploys
    ]
  bucket = "${var.nomeBucket}-deploys"
  key    = "${var.nomeBucket}.zip"
  source = "${var.nomeBucket}.zip"
  
  etag = filemd5("${var.nomeBucket}.zip")
}