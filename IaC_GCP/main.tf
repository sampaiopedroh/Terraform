terraform {
    required_providers {
       google = {
        source  = "hashicorp/google"
        version = "6.8.0"
       }
    }
}

provider "google" {
    credentials = file("<chave>.json")

    project = "<id_projeto>"
    region  = "us-central1"
    zone    = "us-central1-c"
}

resource "google_compute_instance" "primeiraVMGCP" {
    name         = "primeiravmgcp"
    machine_type = "e2-micro"
    zone         = "us-central1-c" 

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
        }
    }

    network_interface {
        network = "default"
        access_config {
            // Ephemeral public IP
        }
    }

    metadata_startup_script = "echo oi > /test.txt"
}