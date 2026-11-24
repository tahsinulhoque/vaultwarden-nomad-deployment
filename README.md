# Vaultwarden — Self-Hosted Password Manager on HashiCorp Nomad

A self-hosted password manager deployment using **Vaultwarden, Docker, HashiCorp Nomad, persistent host storage, and Nginx**.

This project is part of Springer Capital Assignment #3.

## Project Overview

The objective is to deploy Vaultwarden on a single-node HashiCorp Nomad cluster, configure persistent storage, provide HTTPS access through an Nginx reverse proxy, and implement secure backup and restore procedures.

## Technology Stack

- **Vaultwarden** — Self-hosted Bitwarden-compatible password manager
- **Docker** — Container runtime
- **HashiCorp Nomad** — Workload orchestration
- **Nginx** — Reverse proxy (installation completed; configuration pending)
- **SQLite3** — Installed for database inspection and backup operations
- **OpenSSL** — Installed for SSL certificate generation
- **Ubuntu WSL2** — Deployment environment
- **Consul** — Service discovery integration

## Architecture

```text
Bitwarden Client
       |
       | HTTPS (Pending)
       |
Nginx Reverse Proxy
       |
       | HTTP (Pending Configuration)
       |
Vaultwarden
(Docker Container)
       |
HashiCorp Nomad
       |
       |
Persistent Host Volume
/opt/vaultwarden/data
       |
       |
SQLite Database & Application Data
       |
       |
Backup Storage (Pending)
```

## Project Structure

```text
vaultwarden-nomad-deployment/
│
├── nomad/
│   ├── vaultwarden.nomad
│   └── vaultwarden-restore.nomad
│
├── nginx/
│   └── vaultwarden.conf
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── docs/
│   ├── research.md
│   ├── architecture.md
│   ├── storage-design.md
│   ├── security.md
│   ├── backup-restore.md
│   └── license.md
│
├── screenshots/
├── secrets/
├── backups/
│
├── .gitignore
└── README.md
```

## Implementation Progress

### 1. Environment Preparation — Completed

- Ubuntu WSL2 environment prepared.
- Nomad server and client configured.
- Consul integration verified.
- Docker Desktop WSL integration enabled.
- Nomad Docker driver verified through a successful test job.
- Nginx, SQLite3, OpenSSL, curl, and Git installed.

### 2. Persistent Storage — Completed

Created the Vaultwarden data directory:

```bash
sudo mkdir -p /opt/vaultwarden/data
sudo chown -R 1000:1000 /opt/vaultwarden
```

Configured a Nomad host volume:

```hcl
host_volume "vaultwarden-data" {
  path      = "/opt/vaultwarden/data"
  read_only = false
}
```

Verified the volume through:

```bash
nomad node status -self -verbose
```

### 3. Vaultwarden Deployment — Completed

Pulled the Docker image:

```bash
docker pull vaultwarden/server:latest
```

Created and validated the Nomad job:

```bash
nomad job validate nomad/vaultwarden.nomad
```

Deployed Vaultwarden:

```bash
nomad job run nomad/vaultwarden.nomad
```

Verified deployment status:

```bash
nomad job status vaultwarden
```

Current deployment details:

- Job ID: `vaultwarden`
- Allocation ID: `884a00b5`
- Deployment status: Successful
- Allocation status: Running
- Health: Healthy
- Vaultwarden version: `1.37.5`

### 4. Application Verification — Completed

Checked application logs:

```bash
nomad alloc logs 884a00b5
```

Confirmed that Vaultwarden started successfully and Rocket launched on port 80 inside the container.

Verified HTTP response:

```bash
curl -I http://172.23.28.192:27688
```

Result: `HTTP/1.1 200 OK`

## Remaining Tasks

- [ ] Research Vaultwarden storage, database, backup requirements, and admin token.
- [ ] Verify persistent data after restarting the application.
- [ ] Configure Nginx reverse proxy.
- [ ] Configure HTTPS and SSL certificate.
- [ ] Test Bitwarden client login with a test account.
- [ ] Disable open user registration.
- [ ] Disable or restrict the admin panel.
- [ ] Configure scheduled backups.
- [ ] Test restoration into a fresh Vaultwarden instance.
- [ ] Securely manage secrets outside Nomad job files and Git.
- [ ] Document AGPL-3.0 license implications.
- [ ] Complete technical documentation and screenshots.
- [ ] Update and finalize the GitHub repository.

## Security Considerations

- Never commit admin tokens or other sensitive credentials to Git.
- Use test credentials only.
- Disable public registration after creating test accounts.
- Restrict or disable the admin interface.
- Protect backup files because they contain sensitive password-manager data.
- Ensure HTTPS is configured before using the service with Bitwarden clients.

## Current Project Status

**Deployment:** Successful

**Application:** Running and Healthy

**Persistent Volume:** Configured

**HTTPS Reverse Proxy:** Pending

**Backup & Restore:** Pending

**Security Hardening:** Pending

**Documentation:** In Progress

---

*Project: Springer Capital Assignment #3 — Vaultwarden: Run a Self-Hosted Password Manager on Nomad.*