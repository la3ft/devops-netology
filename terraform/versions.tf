terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = ""
  cloud_id  = "b1gu1gt5nqi6lqgu3t7s"
  folder_id = "b1gaec42k169jqpo02f7"
  zone      = "ru-central1-a"
}