#!/bin/sh
export LANG=en_US.UTF-8

timezone=Europe/XXXX

defdisk=/dev/sda

user=XXXX
hostname=XXXX

echo -e "Arch Linux installer\nBy b0r3df0x\nFor a (soon to be) headless server.\n"

read -p "What disk should I use? Type the path or press enter(Default: $defdisk):" disk
disk=${disk:-$defdisk}

#echo $disk

timedatectl set-ntp true
timedatectl set-timezone $timezone

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Sy

parted -s $disk mklabel gpt
parted -sa optimal $disk mkpart "EFI" fat32 0% 1.5GiB set 1 boot on
parted -sa optimal $disk mkpart "SWAP" linux-swap 1.5GiB 10GiB
parted -sa optimal $disk mkpart "ROOT" ext4 10GiB 100%

mkfs.vfat -F32 ${disk}1
mkswap ${disk}2
mkfs.ext4 ${disk}3

mount ${disk}3 /mnt
swapon ${disk}2

pacstrap /mnt base base-devel linux linux-firmware linux-headers intel-ucode #amd-ucode if running on AMD cpu

mkdir /mnt/boot/EFI
mount ${disk}1 /mnt/boot/EFI

genfstab -U /mnt > /mnt/etc/fstab

arch-chroot /mnt sh -c '
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen;
echo "LANG=en_US.UTF-8" > /etc/locale.conf;
echo "KEYMAP=us" > /etc/vconsle.conf;
locale-gen;

echo "$hostname" > /etc/hostname;

#echo "127.0.0.1       localhost" > /etc/hosts;
#echo "::1             localhost" >> /etc/hosts;
#echo "127.0.1.1       $hostname.localdomain     $hostname" >> /etc/hosts;

echo "[multilib]" >> /etc/pacman.conf;
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf;

bootctl install --esp-path=/boot/EFI;

pacman -Sy;

pacman -S --noconfirm nano neovim trash-cli htop neofetch btop p7zip unrar zsh zsh-completions\
 screen smartmontools pkgstats ufw clamav dmidecode gvfs gvfs-smb gvfs-mtp gpart cabextract ntfs-3g\
 jfsutils f2fs-tools exfatprogs reiserfsprogs udftools nilfs-utils tar git go jdk11-openjdk jdk17-openjdk\
 python-setuptools python-pip python-wheel nodejs php npm groovy nginx wpa_supplicant rsync samba wget net-tools\
 dhclient bluez bluez-tools bluez-libs bluez-utils bluez-hid2hci bluez-plugins kismet\
 libvirt virt-install qemu-full qemu-arch-extra ffmpeg;

systemctl enable systemd-networkd;
systemctl enable wpa_supplicant;

useradd -m -G wheel,uucp,kismet,input,kvm,libvirt $user;

echo "---Root Password---";
passwd;

echo "---User Password---";
passwd $user;'

clear

sync
umount -R /mnt/boot/EFI
umount -R /mnt
swapoff ${disk}2

echo -e "ALL DONE!\a"
