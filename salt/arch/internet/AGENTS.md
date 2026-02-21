# NetworkManager DNS Configuration

This directory contains Salt states for configuring NetworkManager with external DNS resolvers.

## Files

- `init.sls` - Main state that manages NetworkManager DNS configuration
- `dns.conf` - Configuration file for external DNS resolver (Cloudflare by default)
- `dns-systemd-resolved.conf` - Configuration file for systemd-resolved
- `internet.nmconnection` - Default WiFi connection profile template
- `openvpn.nmconnection` - OpenVPN connection profile template

## DNS Configuration Options

### External Resolver (Default)
Uses `dns=default` and `rc-manager=file` with Cloudflare DNS (1.1.1.1, 1.0.0.1).

### systemd-resolved
Uses `dns=systemd-resolved` and `rc-manager=symlink` for systemd-resolved integration.

## Pillar Configuration

Configure in `pillar/arch/internet/init.sls`:

```yaml
internet:
  dns:
    use_external: true  # Toggle between external and systemd-resolved
    servers:
      - 1.1.1.1
      - 1.0.0.1
```

## Usage

Apply the internet state:
```bash
salt-apply -s internet
```

Toggle DNS mode:
- Set `use_external: true` for external DNS (no systemd-resolved)
- Set `use_external: false` or remove for systemd-resolved
