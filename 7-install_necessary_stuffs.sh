sudo pacman -S qemu libvirt edk2-ovmf virt-manager ebtables dnsmasq
systemctl enable libvirtd.service
systemctl start libvirtd
systemctl enable virtlogd.socket
systemctl start virtlogd.socket

sudo virsh net-autostart default
sudo virsh net-start default
