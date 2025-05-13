terraform {
    backend "s3" {
        bucket = "terraform-cicd-statefile"
        key    = "rds"
        region = "us-east-1"
    }
}
