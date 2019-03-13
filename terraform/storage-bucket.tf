provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"

  # Имена поменяйте на другие
  name = ["my-storage-bucket-test", "my-storage-bucket-test2"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
