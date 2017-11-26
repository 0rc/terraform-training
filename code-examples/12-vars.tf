variable "active" {
  default = false
}

variable "key" {
  type        = "string"
  description = "my string variable"
}

variable "images" {
  type = "map"

  default = {
    us-east-1 = "image-1234"
    us-west-2 = "image-4567"
  }

  description = "my images map"
}

variable "zones" {
  default     = ["us-east-1a", "us-east-1b"]
  description = "zone list"
}
