#Create S3 bucket
resource "aws_s3_bucket" "coalfirebucket" {
  bucket    = var.s3_bucket
  acl       = "private"

  force_destroy = true

  lifecycle_rule {
    id      = "demo"
    prefix  = "demo/"

    enabled = true

    expiration {
      days = 90
    }
  }
}

#Create bucket folders
resource "aws_s3_bucket_object" "s3_folder" {
    count    = "${length(var.folder_name)}"
    bucket   = "${aws_s3_bucket.coalfirebucket.id}"
    acl      = "private"
    key      =  "${var.folder_name[count.index]}/"
    source   = "/dev/null"
}
