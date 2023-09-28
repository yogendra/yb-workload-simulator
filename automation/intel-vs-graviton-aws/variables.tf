variable "keypair-name" {
  type = string
}
variable "db-sg" {
  type = list(string)
}
variable "app-sg" {
  type = list(string)
}

variable "vpc" {
  type = string
}

variable "subnets" {
  type = list(string)
}
variable "name"{
  type = string
}
