# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  type        = string
  description = "AWS region for all resources."
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile name"
}

variable "environment" {
  type        = string
  description = "name of environment"
}
