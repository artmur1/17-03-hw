locals {
  zone = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "example2" {
  depends_on = [yandex_compute_instance.db]
  count = 2
  name        = "netology-develop-platform-web-${count.index+1}"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  zone                      = local.zone

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}