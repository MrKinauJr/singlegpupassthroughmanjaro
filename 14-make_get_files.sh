sudo mkdir /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sleep 2
sudo chmod +x /etc/libvirt/hooks/qemu
sudo systemctl restart libvirtd
sudo mkdir /etc/libvirt/hooks/qemu.d
sudo mkdir /etc/libvirt/hooks/qemu.d/win10
sudo mkdir /etc/libvirt/hooks/qemu.d/win10/prepare
sudo mkdir /etc/libvirt/hooks/qemu.d/win10/release
sudo mkdir /etc/libvirt/hooks/qemu.d/win10/prepare/begin
sudo mkdir /etc/libvirt/hooks/qemu.d/win10/release/end
