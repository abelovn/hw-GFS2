provider "tls" {}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "private_ssh" {
  filename        = "id_rsa"
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
}

resource "local_file" "public_ssh" {
  filename        = "id_rsa.pub"
  content         = tls_private_key.ssh.public_key_openssh
  file_permission = "0600"
}

resource "local_file" "hosts" {
  filename = "../ansible/hosts"
  content = templatefile("hosts.tpl",
    {
      gfs_workers   = yandex_compute_instance.gfs.*.network_interface.0.ip_address
      iscsi_workers = yandex_compute_instance.iscsi.*.network_interface.0.ip_address
    }
  )
  depends_on = [
    yandex_compute_instance.gfs,
    yandex_compute_instance.iscsi,
  ]
}
