# Simple NixOS config

- Scripts assume configuration files are in the same dir as the scripts

## Scripts

- `switch.sh <hostname> [update]` runs `nixos-rebuild` for the <hostname>.
  Optionally runs flakes update if `update` is used

## Enable wireless in minimal iso / no UI setup

[Instructions source](https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking)

```
sudo -i

systemctl start wpa_supplicant

wpa_cli

## Below outputs is from wpa_cli
> add_network
0
> set_network 0 ssid "myhomenetwork"
OK
> set_network 0 psk "mypassword"
OK
> enable_network 0
OK

# Look for a line similar to: `<3>CTRL-EVENT-CONNECTED - Connection to 32:85:ab:ef:24:5c completed [id=0 id_str=]`
# `quit` after the connection is successfully established

# Check: has IP and that interface is UP
ip addr show
```

## Partitioning instructions

https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning

Overall steps are:
1. Create 3 partitions using `cfdisk`: EFI, nixos, swap.
1. Format them accordingly:
```sh
mkfs.ext4 -L nixos /dev/sss1
mkswap -L swap /dev/sss2
mkfs.fat -F 32 -n EFI /dev/sss3
```
1. Mount the linux partition in `/mnt`: `mount /dev/disk/by-label/nixos /mnt`
1. Mount the boot partition in `/mnt/boot`:
```sh
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/EFI /mnt/boot
```

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
1. Copy the configuration.nix file from one of the other hosts AND update the hostName to match the new one.
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
1. Move the configuration folder in the user home dir: `mv /etc/nixos/nixos-config ~/`
1. Push the changes to preserve the configuration
