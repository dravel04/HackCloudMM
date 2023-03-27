provider "google" {
  project = "aiimdxghbalyvvw0ahpt6kz3uciv7i"
  region  = "us-central1"
}

resource "google_container_cluster" "cluster" {
  name               = "my-k8s-cluster"
  location           = "us-central1"
  remove_default_node_pool = true

  initial_node_count = 1
  node_config {
    machine_type = "n1-standard-2"
    disk_size_gb = 10
  }
}

resource "google_container_node_pool" "default_node_pool" {
  name               = "default-node-pool"
  location           = google_container_cluster.cluster.location
  cluster            = google_container_cluster.cluster.name
  node_count         = 1
  node_config {
    machine_type    = "n1-standard-2"
    disk_size_gb    = 10
    oauth_scopes    = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}

resource "null_resource" "apply_config" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.cluster.name} --zone=${google_container_cluster.cluster.location} && kubectl apply -f my-app.yml"
  }
}

