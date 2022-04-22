variable "project" {
  description = "Project Name"
  type        = string
}
variable "region" {
  description = "AWS Region"
  type        = string
}
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets for the VPC"
  type        = list(string)
}
variable "private_subnets" {
  description = "List of private subnets for the VPC"
  type        = list(string)
}
variable "azs" {
  description = "List of availability zone names in the region"
  type        = list(string)
}
variable "vpn_cidr_block" {
  description = "CIDR block to access public instance"
  type        = list(string)
}
variable "aws_key_pair" {
  default = "~/.aws/key_pairs/blake_coalfire.pem"
}
variable "s3_bucket" {
  description = "S3 bucket"
  type        = string
}
variable "folder_name" {
  description = "S3 folder names"
  type        = list(string)
}
