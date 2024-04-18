resource "aws_kms_key" "encryption_key" {
  description             = "This key is used to encrypt kinesis streams"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Name = "kinesis-kms-key"
  }
}

resource "aws_kms_key" "encryption_key_s3_source_bucket" {
  description             = "This key is used to encrypt the source s3 bucket"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Name = "s3-source-kms-key"
  }
}

resource "aws_kms_key" "encryption_key_s3_destination_bucket" {
  description             = "This key is used to encrypt the destination s3 bucket"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Name = "s3-destination-kms-key"
  }
}
