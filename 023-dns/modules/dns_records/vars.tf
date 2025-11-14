variable "zone_id" {
  type      = string
  sensitive = true
}

variable "name" {
  type = string
}

variable "records" {
  type = list(object({
    type  = optional(string, "A")
    content = string
  }))
}
