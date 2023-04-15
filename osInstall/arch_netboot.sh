#!/bin/sh

timezone="Region"/"Country"

timedatectl set-ntp true
timedatectl set-timezone $timezone

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

pacman -Sy 

efi=/dev/"sdXX"
swap=/dev/"sdXX"
root=/dev/"sdXX"
#home=/dev/"sdXX"
#tmp=/dev/"sdXX"
#opt=/dev/"sdXX"

mkfs.vfat -F32 $efi
mkswap $swap
mkfs.ext4 $root
#mkfs.ext4 $home
#mkfs.ext4 $tmp
#mkfs.ext4 $opt

mount $root /mnt

pacstrap /mnt base base-devel linux linux-firmware linux-headers intel-ucode #change to amd-ucode if running on amd cpu

mkdir /mnt/boot/efi

swapon $swap
mount $home /mnt/home
mount $efi /mnt/boot/efi
#mount $tmp /mnt/tmp
#mount $opt /mnt/opt

genfstab -U /mnt > /mnt/etc/fstab

echo "Base installation completed. Proceed to chroot.\n\a"
