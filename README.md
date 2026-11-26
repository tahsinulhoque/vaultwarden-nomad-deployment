# Vaultwarden — Self-Hosted Password Manager on HashiCorp Nomad

A self-hosted password manager deployment using **Vaultwarden, Docker, HashiCorp Nomad, persistent host storage, and Nginx**.

This project is part of **Springer Capital Assignment #3**.

## Project Overview

The objective is to deploy Vaultwarden on a single-node HashiCorp Nomad cluster, configure persistent storage, provide HTTPS access through an Nginx reverse proxy, and implement secure backup and restore procedures.

The deployment uses a local testing environment with a self-signed SSL certificate and test credentials only.

## Technology Stack

- **Vaultwarden** — Self-hosted Bitwarden-compatible password manager
- **Docker** — Container runtime
- **HashiCorp Nomad** — Workload orchestration
- **Consul** — Service discovery integration
- **Nginx** — HTTPS reverse proxy
- **SQLite3** — Database inspection and backup operations
- **OpenSSL** — Self-signed SSL certificate generation
- **Ubuntu WSL2** — Deployment environment

## Architecture

```text
Bitwarden-Compatible Client
          |
          | HTTPS
          |
   Nginx Reverse Proxy
          |
          | HTTP
          |
   Vaultwarden Service
     (Docker Container)
          |
    HashiCorp Nomad
          |
          |
   Persistent Host Volume
   /opt/vaultwarden/data
          |
          |
   SQLite Database &
   Application Data
          |
          |
    Backup Storage
     (Pending)
```

**HTTPS configuration:** Local self-signed certificate.

**Local domain:** `vaultwarden.local`

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

- Prepared Ubuntu WSL2 environment.
- Configured Nomad server and client.
- Verified Consul integration.
- Enabled Docker Desktop WSL integration.
- Verified Nomad Docker driver using a successful test job.
- Installed Nginx, SQLite3, OpenSSL, curl, and Git.

### 2. Persistent Storage Configuration — Completed

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

Verified the host volume using:

```bash
nomad node status -self -verbose
```

The volume is mounted inside the Vaultwarden container at `/data`.

**Note:** Persistence across an application restart still needs to be demonstrated.

### 3. Vaultwarden Deployment — Completed

Pulled the Vaultwarden Docker image:

```bash
docker pull vaultwarden/server:latest
```

Validated the Nomad job:

```bash
nomad job validate nomad/vaultwarden.nomad
```

Deployed Vaultwarden:

```bash
nomad job run nomad/vaultwarden.nomad
```

Verified the deployment:

```bash
nomad job status vaultwarden
```

Deployment details:

- Job ID: `vaultwarden`
- Orchestrator: HashiCorp Nomad
- Driver: Docker
- Container image: `vaultwarden/server:latest`
- Deployment status: Successful
- Allocation status: Running
- Health status: Healthy
- Vaultwarden version observed: `1.37.5`

Allocation IDs and dynamic ports can change after redeployment.

### 4. Application Verification — Completed

Checked application logs:

```bash
nomad alloc logs <allocation-id> vaultwarden
```

Confirmed that Vaultwarden started successfully and Rocket launched on port 80 inside the container.

Verified the HTTP response from the application backend:

```bash
curl -I http://<node-ip>:<dynamic-port>
```

The application returned:

```text
HTTP/1.1 200 OK
```

### 5. Nginx Reverse Proxy and HTTPS — Completed

Configured Nginx as a reverse proxy for Vaultwarden.

Created the local domain:

```text
vaultwarden.local
```

Generated a self-signed SSL certificate using OpenSSL:

```bash
sudo mkdir -p /etc/nginx/ssl

sudo openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/vaultwarden.key \
  -out /etc/nginx/ssl/vaultwarden.crt \
  -subj "/CN=vaultwarden.local" \
  -addext "subjectAltName=DNS:vaultwarden.local"
```

Configured:

- HTTP-to-HTTPS redirection.
- HTTPS listener on port 443.
- SSL certificate and private key.
- Nginx reverse proxy to the Nomad allocation.

Validated and reloaded Nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Verified HTTPS access:

```bash
curl -k -I https://vaultwarden.local
```

Result:

```text
HTTP/1.1 200 OK
```

**Note:** The certificate is self-signed and therefore not automatically trusted by browsers. This is a local testing setup, not a production-trusted certificate.

### 6. Test Account and Security Configuration — Completed

Created a test user account through the Vaultwarden web interface.

Updated the Nomad job environment:

```hcl
env {
  DOMAIN              = "https://vaultwarden.local"
  SIGNUPS_ALLOWED     = "false"
  INVITATIONS_ALLOWED = "false"
}
```

Generated a secure Admin Token and configured it through a local Nomad variable file rather than hardcoding it in the job source.

The Admin Token was successfully used to authenticate into the Vaultwarden Admin Panel.

Verified the environment variables inside the running allocation:

```bash
nomad alloc exec <allocation-id> env | grep -E 'SIGNUPS_ALLOWED|INVITATIONS_ALLOWED'
```

Admin authentication was successfully demonstrated.

**Note:** Registration restriction is configured, but final browser-side verification remains pending.

### 7. Admin Token and Secret Handling — Partially Completed

- Generated a random Admin Token using OpenSSL.
- Stored the token in `secrets/admin-token.vars`.
- Restricted local file permissions using `chmod 600`.
- Added an `admin_token` variable to the Nomad job.
- Used a variable file during validation and deployment.

Deployment command:

```bash
nomad job run \
  -var-file=secrets/admin-token.vars \
  nomad/vaultwarden.nomad
```

The token is not hardcoded in the Nomad job source file.

The secret file must remain excluded from Git. Further documentation and review of secret handling are pending.

## Remaining Tasks

- [ ] Complete Vaultwarden storage and database research with official documentation references.
- [ ] Document what data needs backing up and what the Admin Token protects.
- [ ] Demonstrate persistent data after restarting the Vaultwarden allocation.
- [ ] Verify Bitwarden client login using the test account.
- [ ] Complete browser-side verification of disabled registration.
- [ ] Configure scheduled backups.
- [ ] Restore a backup into a fresh Vaultwarden instance.
- [ ] Verify that restored test entries are available.
- [ ] Complete secret storage documentation.
- [ ] Document Vaultwarden's AGPL-3.0 license and implications for internal use.
- [ ] Capture final assignment evidence and screenshots.

## Security Considerations

- Use test credentials and test data only.
- Never commit Admin Tokens or sensitive credentials to Git.
- Keep local secret files protected with restrictive permissions.
- Disable open registration after creating test accounts.
- Protect the Admin Page using Admin Token authentication.
- Protect backup files because they contain sensitive password-manager data.
- Use HTTPS for client access.
- Review secret handling and backup procedures before production use.

## Current Project Status

| Component | Status |
|---|---|
| Environment preparation | Completed |
| Nomad deployment | Completed |
| Persistent host volume configuration | Completed |
| Persistent restart verification | Pending |
| Nginx reverse proxy | Completed |
| Local HTTPS configuration | Completed |
| Test account creation | Completed |
| Signup restriction configuration | Completed |
| Admin Token authentication | Completed |
| Bitwarden client verification | Pending |
| Scheduled backup | Pending |
| Backup restoration | Pending |
| Secret documentation | In progress |
| AGPL-3.0 documentation | Pending |
| Final assignment evidence | Pending |

## Project Information

**Project:** Springer Capital Assignment #3

**Title:** Vaultwarden — Run a Self-Hosted Password Manager on Nomad

**Environment:** Ubuntu WSL2, Docker Desktop, HashiCorp Nomad, Consul, and Nginx

**Repository:** [vaultwarden-nomad-deployment](https://github.com/tahsinulhoque/vaultwarden-nomad-deployment)

---

*This project is currently under development. All remaining acceptance criteria will be verified before final submission.*