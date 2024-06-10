resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
  
    { webservers = yandex_compute_instance.example2
      databases = yandex_compute_instance.db
      storage = [ yandex_compute_instance.storage ] } )

  filename = "${abspath(path.module)}/hosts.cfg"
}
