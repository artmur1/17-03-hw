resource "yandex_compute_disk" "disk" {
  count = 3
  name     = "disk-${count.index+1}"
  zone     = local.zone
  type     = "network-hdd"
  size     = 1
  }

  resource "yandex_compute_instance" "storage" {
  name        = "storage"
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
      size     = 20
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
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk.*.id
    content {
      disk_id = secondary_disk.value
    }
  }
}