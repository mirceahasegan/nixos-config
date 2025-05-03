# Simple NixOS config

- Scripts assume configuration files are in the same dir as the scripts

## Scripts

- `switch.sh <hostname> [update]` runs `nixos-rebuild` for the <hostname>.
  Optionally runs flakes update if `update` is used

## Enable wireless in minimal iso / no UI setup

```
sudo su

# Add the proper tools in the nix-shell. 
nix-shell -p iw wpa_supplicant dhcpcd

# Discover the wireless interface
ip link

# Configure the wifi network to connect to
wpa_passphrase "YourSSID" "YourPassword" > wpa_supplicant.conf
wpa_supplicant -B -i wlan0 -c wpa_supplicant.conf

# dhcpcd cmd might fail but I'm unsure if it's needed on not
dhcpcd wlan0

# should show the WNIC (e.g. wlp3s0) interface as "up"
ip link

# After a while will show an address
ip addr show
```

## Bootstrap a new system

1. Boot into NixOS installer
2. Mount the target drive (/mnt) as usual
3. Run:
```sh
nixos-generate-config --root /mnt
```
4. Copy the new `hardware-configuration.nix` into the flake repo
