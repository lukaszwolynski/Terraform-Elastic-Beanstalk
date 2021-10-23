variable "appName" {
  type    = string
  default = "pokemon-api"
}

variable "appDescription" {
  type    = string
  default = "Allows you to list cool attributes about your favourite Pokemons"
}

variable "envName" {
  type    = string
  default = "Pokemon-environment"
}

resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

locals {
  #type    = string
  bucketName = random_string.bucket_name.result
}
