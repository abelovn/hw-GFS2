variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_token" {
  type = string
}

variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "image_id" {
  type = string

  default = "fd816jiq3n13qtli6fh3" #centos 8 stream
}
