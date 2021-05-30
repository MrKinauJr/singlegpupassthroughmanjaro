# singlegpupassmanjaro

Run **1-update_things.sh** in terminal

Run **2-edit_grub.sh** in terminal. A text editor will open.
On the line **GRUB_CMDLINE_LINUX_DEFAULT=**, *inside* the quotation marks, add these:
## iommu=pt iommu=1 amd_iommu=on video=efifb:off
*If on Intel, change amd_iommu=on to intel_iommu=on*
Then, **CTRL+X**, Y, Enter.

Run **3-rebuild_grub.sh** in terminal
###### Which will require a reboot of your pc


Run **4-reboot.sh** in terminal. This will reboot you

When back, run **5-check_iommu.sh** in terminal, and hope it says those arguments you added earlier, along with a bunch of other stuff. If it does, you win! If not, you've epically failed, I can't help.

Run **6-show_devices.sh** in terminal, and look for a "VGA COMPATIBLE CONTROLLER", and it's Audio device. 
## If your VGA and AUDIO deivces are in the same IOMMU group, with nothing else in it, good.
## If your VGA and AUDIO devices aren't in the same IOMMU group, but they're each in their own group, with nothing else in either, good.
## If your VGA and AUDIO devices are in the same group as other stuff, not good. I can't help

Now, note down the numbers and letters which come just before the device names. 
My video adapter is 2b:00:0, and audio is 2b:00:1, for example.
Just make a text file somewhere to keep them safe.

Now, we're gonna install some software.
###### this next script will make 4 popups which want your password. This is ok, it is starting and enabling services.
Run **7-install_necessary_stuffs.sh** in terminal. Say yes when it asks you to.

Run **8-edit_libvirt.sh** in terminal
You're now in a text editor. Do **CTRL+W**, and search for: unix_sock 
Remove the # from the line it's on.
Then, **CTRL+W**, search for: unix_sock_rw
Remove the # from the line it's on
**CTRL+X, Y, Enter**

Run **9-add_user_stuff.sh** in terminal,
then run **10-reboot.sh** to reboot.

Go to [the windows 10 download page](https://www.microsoft.com/en-gb/software-download/windows10ISO) and get the iso, let it fully download. You don't need it yet, but this is so it'll be done downloading once you need it. Smart, I know

Run **11-edit_qemu.sh** in terminal, and CTRL+W to search for: user = "r
Remove the # from the line, and change root within the quotes, to your username.
Remove the # from the line a little below named: group = "root", and also swap root for your username
Now **CTRL+X, Y, Enter**.

Run **12-restart_libvirtd** to restart libvirtd

Now, some GPUs need patched firmware to work in VMs. In this example, we won't be patching it, since at the time of writing, I have an AMD Vega 64, which doesn't need patching, however we will be saving a bios anyway to pass through to the VM.
Go to the [Techpowerup Bios Repository](https://www.techpowerup.com/vgabios/), and search for your GPU. Download it's bios. You want to find your exact model. E.G: MSI AIR BOOST VEGA 64, as opposed to just "Vega 64". Once you have your rom, rename it to "gpubios.rom", and ensure it's in your Downloads folder. 

Now run **13-move_bios.sh**, which makes a folder in your libvirt folder, and moves the bios there. 


Open Virtual Machine Manager, which should've been installed earlier, click QEMU/KVM, and then the New VM button in the top left. Here are the buttons to press:
* Local Install Media
* Forward
* Browse
* Browse Local
* Downloads
* Double Click The Windows 10 ISO file
* Forward
* 80% of your Ram in the Memory section
* Leave CPU settings alone for later
* Forward
* Untick "Enable Storage For This Machine", we'll handle it later.
* Forward
* Keep the Name at win10
* Tick customise config before install
* Finish
* Click BIOS, and change it to the UEFI *not ending in secboot*
* Apply
* Go to CPUs
* Click topology, and manually set topology.
* Sockets to 1, set cores to -1 from whatever your CPU has, so a 6 core processor would have 5.
* Go to a terminal and type htop. At the top you'll see a bunch of charts going horizontally at the top, which are numbered. On a Ryzen 3600, they go from 0-11, meaning there are 12 threads, or 2x the core count, meaning it has hyperthreading. If you have double as many bars as cores, set threads on your VM to 2. If it's the same as the physical cores you have, set threads to 1.

* Click add hardware in the bottom left of the virtual machine manager, and select storage, which is normally at the top
* Set however many GB you want it to have (keep in mind, the virtual disk only takes as much space as the VM is actually using, so don't worry about it immediately eating all your storage space on the Host)
* Set the Bus Type to VirtIO instead of SATA
* Go to [the VirtIO Driver Download link](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) and download it. Once downloaded, add hardware to your VM again, select storage, and set the device type to CDROM Device. Press finish
* Click on SATA CDROM 2, and click browse, then browse local, and head to your downloads, where you'll double click the VirtIO drivers iso. Press apply.
* Now, go to the top, and press begin installation.
* When you see a menu which says press any key to boot from CD, press any key. If you miss the time window, close the VM, right click it and force off, then try again.
![Windows10install](https://i.imgur.com/V2tIQDD.png)
* You're now here. Well done!
* Keep in mind, during first install, graphics and framerate will be pretty bad
* Go through installation as normal for the first bit.
* Next, install now, I don't have a product key, any version not ending in N, read and accept, next, custom install.
* Now, press load drivers, then ok, and select the driver that appears with W10 in the name. Click it and press next.
* Now click on Drive 0 unallocated space, and press next. Windows will install. 
* When windows restarts, you may be put into windows, but you may be put into a terminal. If in the terminal,click the dropdown near the power icon at the top of the VM, and force it off.
* Press the info icon, and press boot options, and tick VFIO disk 1. Then, go to the 2 CDROM drives, and remove + delete them.
* Now press play, and go back to the view icon next to the info icon. You'll go through the windows personalisation setup now.
* When you're on the windows desktop, shut down windows. You can X out of it in Linux afterwards.
## Hooks Time
 Run **15-make_get_files.sh** in terminal. This will download files to do with VM hooks, and make directories, along with restarting libvertd.
 
 Run **16-edit_kvmconf.sh** in terminal.
 In the text editor that opened, copy this, remembering that pasting into a terminal is CTRL+SHIFT+V: 
**VIRSH_GPU_VIDEO=pcie_0000_**

 **VIRSH_GPU_AUDIO=pcie_0000_**
 
 Now, add your PCIE IOMMU IDs you saved before. The formatting is as so...
 If I have an ID of 2b:00:1, I would enter is as 2b_00_1 after the underscore in the text file.
 So, for me, it's VIRSH_GPU_VIDEO=pcie_0000_2b_00_0, and VIRSH_GPU_AUDIO=pcie_0000_2b_00_1
 
 Now, **CTRL+X, Y, Enter**
 
 Run **16-edit_start.sh** in terminal.
 
 Let's take a look at this.
````
#debug
set -x

#Vendor Reset (prevent AMD card reset break)
modprobe vendor-reset

#load variables defined earlier
source "/etc/libvirt/hooks/kvm.conf"

#Stop disp manager
systemctl stop sddm.service

#unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

#Unbind efi-framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

#Avoid race condition
sleep 10

#unload AMDGPU
modprobe -r amdgpu

#unbind GPU 
virsh nodedev-detatch $VIRSH_GPU_VIDEO
virsh nodedev-detatch $VIRSH_GPU_AUDIO

#load vfio
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

````
Copy This into the text editor, and we'll edit to fit your PC.

The first 4 sections should be left alone, other than that if you have an AMD GPU, go to the package manager, press the three lines, and enable AUR. Then seach Vendor-Reset. Get the one with a longer title, it was made on the 18th November 2020.

For the VTconsoles bit, go into another terminal and run **17-view_vt.sh**. For however many vtcons there are, copy the lines that are already in this code, changing the number to match. Most people just have vtcon0 and 1, which is already setup.

Leave the EFI framebuffer section. The avoid race condition section basically just waits to ensure previous bits of code are excecuted before continuing. For most people, this does not need to be 10, but for some it does. Start at 10, and then once wer'e done, try lowering it and seeing what works. Personally, I use 4.

If on AMD, leave the AMDGPU section alone, if on nvidia, **remove modprobe -r amdgpu**, and replace it with 
````
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r drm_kms_helper
modprobe -r nvidia
modprobe -r i2c_nvidia_gpu
modprobe -r drm
modprobe -r nvidia_uvm
````

Then, leave the rest of the script alone, and **CTRL+X, Y, ENTER**

Run **18-edit_end.sh** in terminal
In the text editor, paste this
````
#debug
set -x

#load variables
source "/etc/libvirt/hooks/kvm.conf"

#unload vfio-pci
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

#Rebind GPU
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

#Rebind VTconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

#Bind EFI-framebuffer
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

#Load AMDGPU
modprobe amdgpu

#Restart Display Service
systemctl start sddm.service
````
The first 4 sections should be left alone always. 

For VTconsoles, make the same changes, if any, you made in the start script.

Leave the framebuffer alone, and then for AMD, leave the rest alone too.
On NVIDIA, remove modprobe amdgpu, and replace with this:
````
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe drm_kms_helper
modprobe nvidia
modprobe i2c_nvidia_gpu
modprobe drm
modprobe nvidia_uvm
````

Now, **CTRL+X, Y, ENTER**

Also, run **19-perms.sh**, to make these scripts excecutable.

# We're nearly there! Give yourself a pat on the back
