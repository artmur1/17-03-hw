resource "yandex_compute_instance" "db" {
  for_each = {
    for vm in var.each_vm: vm.vm_name => vm
  }

  name = each.value.vm_name
  platform_id               = "standard-v1"
  allow_stopping_for_update = true
  resources {
    core_fraction = 20
    cores         = each.value.cpu
    memory        = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = each.value.disk_volume
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