locals {
  # Имя web VM
  vm_web_name = "${var.vpc_name}-${var.vm_web_name}-${var.default_zone}"
  
  # Имя db VM
  vm_db_name = "${var.vpc_name}-${var.vm_db_name}-${var.vm_db_zone}"
}