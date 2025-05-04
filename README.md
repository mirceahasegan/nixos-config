# Simple NixOS config

- Scripts assume configuration files are in the same dir as the scripts

## Scripts

- `switch.sh <hostname> [update]` runs `nixos-rebuild` for the <hostname>.
  Optionally runs flakes update if `update` is used

## Enable wireless in minimal iso / no UI setup

[Alternate resource](https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking)

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

## Partitioning instructions

https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning

Overall steps are:
1. Create 3 partitions using `cfdisk`: EFI, nixos, swap.
1. Format them accordingly.
1. Mount the linux partition in `/mnt`
1. Mount the boot partition in `/mnt/boot`

## Bootstrap a new system

1. Boot into NixOS installer
1. Ensure you are root `sudo -i`
1. Follow the "Partitioning instructions" step
1. Run:
```sh
nixos-generate-config --root /mnt
```
1. `cd /mnt/etc/nixos`
1. Clone this repo: `git clone https://github.com/mirceahasegan/nixos-config.git`
1. Create a new `hosts/<new-host-name>` folder in the repo
1. Copy the new hardware-configuration.nix file in this new folder
1. Copy the configuration.nix file from one of the other hosts and update the hostName to match the new one.
1. Add a new entry in the `flake.nix` file `nixosConfigurations` for the new host
1. `cd` back into the install dir, not the `/mnt` folder.
1. Run `sudo nixos-install --flake /mnt/etc/nixos/nixos-config#vm-2`.
1. At the end of the install process, your are prompted to set a root password.
1. Once done, reboot into the new system and set a password for the user
```sh
# switch to root
su
# Set password for the user
passwd mircea
```
