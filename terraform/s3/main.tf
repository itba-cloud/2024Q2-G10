resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.frontend_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
    }]
  })
}

resource "null_resource" "build_frontend" {
  provisioner "local-exec" {
    working_dir = "${path.root}/../frontend"
        command     = <<EOT
      echo "export const url = '$API_ENDPOINT'" > ./src/lib/api.ts;
      echo "export const userPoolId = '$USER_POOL_ID'" > ./src/lib/cognito.ts;
      echo "export const clientId = '$CLIENT_ID'" >> ./src/lib/cognito.ts;
      echo "export const region = '$REGION'" >> ./src/lib/cognito.ts;

      npm ci;
      npm run build;
    EOT
    environment = {
      "API_ENDPOINT" = var.api_endpoint
      "USER_POOL_ID" = var.cognito_user_pool_id
      "CLIENT_ID"    = var.cognito_client_id
      "REGION"       = var.region
    }
    interpreter = ["bash", "-c"]
  }
    triggers = {
    "run_always" = plantimestamp()
  }
}

# NOTE: Our original idea was to uso this aws_s3_object resource to upload the files to the bucket, however this turned
# out to not be possible. Our front-end has to be generated with the API URL, which is not known until after the API
# Gateway is created. This is why our terraform contains a script to build the front end _after_ the API Gateway is up,
# injecting the API's URL into the frontend to then upload it to an S3 bucket.
# The issue is that by using `for_each = fileset("...", "**")`, terraform will plan the upload of each file as a
# resource, and planning occurs _before anything is run_, before we type "yes", and at that point in time the frontend
# is not build yet. To solve this catch-22, we are uploading the frontend files with the AWS CLI instead.
# resource "aws_s3_object" "bucket_files" {
#   depends_on = [null_resource.build_frontend]
#   for_each   = fileset("${path.root}/../frontend/build", "**")
#
#   bucket = aws_s3_bucket.frontend_bucket.bucket
#   key    = each.value
#   source = "${path.root}/../frontend/build/${each.value}"
#   etag   = filemd5("${path.root}/../frontend/build/${each.value}")
#   content_type = lookup({
#     "html" = "text/html",
#     "json" = "application/json",
#     "css"  = "text/css",
#     "js"   = "application/javascript",
#     "jpg"  = "image/jpeg",
#     "png"  = "image/png",
#     "gif"  = "image/gif",
#     "txt"  = "text/plain",
#     "ico"  = "image/x-icon"
#     },
#     reverse(split(".", each.value))[0],
#     "binary/octet-stream" # Default type
#   )
# }

resource "null_resource" "upload_frontend" {
  depends_on = [aws_s3_bucket.frontend_bucket, null_resource.build_frontend]
  provisioner "local-exec" {
    working_dir = "${path.root}/../frontend"
    command     = "aws s3 cp ./build s3://$BUCKET --recursive"
    environment = {
      "BUCKET" = var.bucket_name
    }
    interpreter = ["bash", "-c"]
  }
  triggers = {
    "run_always" = plantimestamp()
  }
}
