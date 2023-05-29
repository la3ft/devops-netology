terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone = "ru-central1-a"
}

variable "yandex_cloud_id" {
  default = "b1gsui2eim1uv6p3172b"
}

variable "yandex_folder_id" {
  default = "b1gru686jbb7pugd8ed2"
}

variable "yandex_compute_image_id" {
  default = "fd80mrhj8fl2oe87o4e1"
}

resource "yandex_vpc_network" "default" {
  name = "vpc"
}

### Public segment:

resource "yandex_vpc_subnet" "public" {
  name = "public"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "vpc-nat-instance" {
  name = "vpc-nat-instance"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "${var.yandex_compute_image_id}"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = true
    ip_address = "192.168.10.254"
  }
}

resource "yandex_compute_instance" "public-instance" {
  name = "public-instance"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd89n8278rhueakslujo"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

output "internal_ip_address_public-instance_yandex_cloud" {
  value = "${yandex_compute_instance.public-instance.network_interface.0.ip_address}"
}

output "external_ip_address_public-instance_yandex_cloud" {
  value = "${yandex_compute_instance.public-instance.network_interface.0.nat_ip_address}"
}

### Private segment:

resource "yandex_vpc_route_table" "private" {
  network_id = "${yandex_vpc_network.default.id}"
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${yandex_compute_instance.vpc-nat-instance.network_interface.0.ip_address}"
  }
}

resource "yandex_vpc_subnet" "private" {
  name = "private"
  zone = "ru-central1-a"
  network_id = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private.id
}

resource "yandex_compute_instance" "private-instance" {
  name = "private-instance"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd89n8278rhueakslujo"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private.id}"
    nat = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

output "internal_ip_address_private-instance_yandex_cloud" {
  value = "${yandex_compute_instance.private-instance.network_interface.0.ip_address}"
}

output "external_ip_address_private-instance_yandex_cloud" {
  value = "${yandex_compute_instance.private-instance.network_interface.0.nat_ip_address}"
}