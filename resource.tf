variable "datacenter" {
  type        = "string"
  description = "Ex) tok02, tok04, tok05, ..."
  default = "tok04"
}

variable "os_reference_code" {
  type        = "string"
  description = "Ex) CENTOS_LATEST_64, CENTOS_7_64, REDHAT_LATEST, REDHAT_7_64, UBUNTU_LATEST, UBUNTU_18_64, WIN_LATEST_64, WIN_2019-STD_64, WIN_2016-STD_64, ..."
  default = "CENTOS_7_64"
}

variable "flavor_key_name" {
  type        = "string"
  description = "Ex) C1_1X1X100, B1_1X4X100, B1_2X4X100, B1_2X8X100, U1_1X2X100, U1_2X4X100, U1_4X8X100, ..."
  default = "B1_1X2X100"
}

variable "post_install_script_uri" {
  type        = "string"
  description = "The URI of the script to be downloaded and executed after installation is complete."
  default = ""
}

variable "hostname" {
  type        = "string"
  description = "Your hostname"
  default = "naka-test"
}


variable "var_root_public_key" {
 type        = "string"
  description = "Your ssh"
  default = "key"
}
data "ibm_compute_ssh_key" "root_public_key" {
    label = "${var.var_root_public_key}"
}

variable "var_private_sg" {
  type        = "string"
  description = "Your security group"
  default = "security_group"
}
data "ibm_security_group" "private_sg" {
    name = "${var.var_private_sg}"
}

resource "ibm_compute_vm_instance" "naka-test" {
    hostname = "${var.hostname}"
    domain = "ibmcloud.com"
    os_reference_code = "${var.os_reference_code}"
    datacenter = "${var.datacenter}"
    network_speed = 100
    hourly_billing = true
    transient = true
    local_disk = false
    private_network_only = false
    flavor_key_name = "${var.flavor_key_name}"
    public_security_group_ids = ["${data.ibm_security_group.public_sg.id}"]
    tags = ["owner:naka"]
    post_install_script_uri = "${var.post_install_script_uri}"
    notes = "naka Resource created by Schematics"
    ssh_key_ids = ["${data.ibm_compute_ssh_key.root_public_key.id}"]
}
