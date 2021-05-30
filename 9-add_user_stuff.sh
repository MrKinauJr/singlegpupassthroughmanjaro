sudo usermod -a -G libvirt $(whoami)
sudo usermod -a -G kvm $(whoami)
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
