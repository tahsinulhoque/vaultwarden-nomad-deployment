
# Vaultwarden on HashiCorp Nomad

## Project Overview

This project focuses on deploying a self-hosted Vaultwarden password manager using HashiCorp Nomad.

The deployment includes persistent storage, Nginx reverse proxy, HTTPS, security hardening, automated backups, and disaster recovery testing.

## Objectives

- Deploy Vaultwarden on HashiCorp Nomad.
- Configure persistent storage.
- Implement HTTPS using Nginx.
- Integrate Bitwarden-compatible clients.
- Disable open user registration.
- Secure administrative access.
- Implement secret management.
- Automate database and file backups.
- Test backup restoration on a fresh instance.

## Technology Stack

| Technology | Purpose |
|---|---|
| Ubuntu | Operating System |
| HashiCorp Nomad | Container Orchestration |
| Consul | Service Discovery |
| Docker | Container Runtime |
| Vaultwarden | Password Manager |
| SQLite | Database |
| Nginx | Reverse Proxy |
| TLS/HTTPS | Secure Communication |
| Bash | Automation |
| Cron | Scheduled Backups |
| GitHub | Version Control |

## Project Structure

```text
vaultwarden-nomad-deployment/
├── nomad/
├── nginx/
├── scripts/
├── docs/
├── screenshots/
├── secrets/
├── backups/
├── .gitignore
└── README.md
```

## Implementation Status

- [ ] Environment preparation
- [ ] Vaultwarden research
- [ ] Persistent storage
- [ ] Nomad deployment
- [ ] HTTPS configuration
- [ ] Security hardening
- [ ] Persistence testing
- [ ] Automated backup
- [ ] Disaster recovery
- [ ] Final documentation

## Security Notice

This project is intended for educational and testing purposes.

Only test accounts and dummy credentials will be used.

Never commit secrets, private keys, database files, or backup archives.

## License

Vaultwarden is licensed under AGPL-3.0.
This repository's own licensing and distribution terms will be documented separately.
