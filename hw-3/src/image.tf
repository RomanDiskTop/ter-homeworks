variable "image_family" {
  type        = string
  description = "Image family for instance boot disks"
  default     = "ubuntu-2204-lts"
}

data "yandex_compute_image" "os" {
  family = var.image_family
}