
job "vaultwarden" {
  datacenters = ["dc1"]
  type        = "service"

  group "vaultwarden" {
    count = 1

    network {
      port "http" {
        to = 80
      }
    }

    volume "vaultwarden-data" {
      type      = "host"
      source    = "vaultwarden-data"
      read_only = false
    }

    task "vaultwarden" {
      driver = "docker"

      config {
        image = "vaultwarden/server:latest"
        ports = ["http"]
      }

      env {
        DOMAIN         = "https://vaultwarden.local"
        SIGNUPS_ALLOWED = "false"
        INVITATIONS_ALLOWED = "false"
      }

      volume_mount {
        volume      = "vaultwarden-data"
        destination = "/data"
        read_only   = false
      }

      resources {
        cpu    = 300
        memory = 256
      }
    }
  }
}
