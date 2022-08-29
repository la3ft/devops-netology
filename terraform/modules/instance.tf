terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "instance" {
  count                     = var.instance_count
  name                      = "Server ${count.index}"
  zone                      = var.zone
  allow_stopping_for_update = true

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
#centos-7
      image_id    = data.yandex_compute_image.image.id
      type        = var.boot_disk
      size        = var.disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}