# NixOS Config

```
sudo git clone <GIT_REMOTE_URL> /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch
```
  
```
cd /etc/nixos
sudo git pull --ff-only
sudo nixos-rebuild switch
```

- `hardware-configuration.nix` is host-specific and should be generated/stored on the NixOS machine.
- If `/etc/nixos/hardware-configuration.nix` is missing, run:

```bash
sudo nixos-generate-config
```
