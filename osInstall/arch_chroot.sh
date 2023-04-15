#!/bin/sh

hostname="Hostname"
user="Username"

#Setting and generating locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

export LANG=en_US.UTF-8

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "KEYMAP=us" > /etc/vconsle.conf

locale-gen

#Enabling multilib (the wrong way)
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

echo "$hostname" > /etc/hostname


echo "127.0.0.1       localhost" > /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain     $hostname" >> /etc/hosts

pacman -Sy

#Bootloader
pacman -S --noconfirm grub efibootmgr os-prober libisoburn fuse freetype2 mtools dosfstools
grub-install --target=x86_64-efi --bootloader-id=ArchSSD --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

#X and video drivers (AMD)
#pacman -S --noconfirm xorg xorg-server xorg-apps xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools vulkan-swrast vulkan-mesa-layers lib32-vulkan-mesa-layers

#X and video drivers (Intel)
pacman -S xorg xorg-apps xorg-server mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools vulkan-swrast libva-intel-driver lib32-libva-intel-driver vulkan-mesa-layers lib32-mesa-vdpau lib32-vulkan-mesa-layers

#Network
pacman -S net-tools wpa_supplicant networkmanager dhclient rsync samba wget 
