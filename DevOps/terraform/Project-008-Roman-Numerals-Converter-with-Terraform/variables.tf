variable "vpc_id" {
  default = "vpc-........."
}

variable "keyname" {
  default = "Comp-Wolf"
}

variable "awsprops" {
  type = map(string)
  default = {
    "vps_id" = "vpc_........."
    publicip = true
    subnet   = ""

  }
}

