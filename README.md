sshd-service
============

This is a utility cookbook that ensures a recent version of OpenSSH server is installed.

## Platforms

Should work on:
- Arch
- Fedora
- RHEL
- Suse
- Ubuntu
- Debian
- FreeBSD

## Recipes

### sshd-service::default

Upgrades the openssh server package to the newest available version.

In the special case of ancient Ubuntus (<=12.04), uses our own backport from https://launchpad.net/~conjur
