terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.26.0"
    }
  }
}

# Configure the HuaweiCloud Provider

provider "huaweicloud" {
  region     = "la-south-2"
  access_key = ""
  secret_key = ""
}

# Create a VPC
resource "huaweicloud_vpc" "vpc_impacta_iac" {
  name = "vpc_impacta_iac"
  cidr = "192.168.0.0/16"
}

# Create a Subnet
resource "huaweicloud_vpc_subnet" "subnet_impacta_iac" {
  name       = "subnet_impacta_iac"
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.1"
  vpc_id     = huaweicloud_vpc.vpc_impacta_iac.id
}

# Create a SECGROUP
resource "huaweicloud_networking_secgroup" "secgroup_impacta_iac" {
  name        = "secgroup_impacta_iac"
  description = "impacta_iac security group acceptance"
}

resource "huaweicloud_compute_instance" "basic" {
  name              = "basic"
  admin_pass        = "admin123"
  image_id          = data.huaweicloud_images_image.myimage.id
  flavor_id         = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  security_groups   = ["default"]

  network {
    uuid = data.huaweicloud_vpc_subnet.subnet_impacta_iac.id
  }
}


