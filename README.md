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
* Press f12 and type htop. At the top you'll see a bunch of charts going horizontally at the top, which are numbered. On a Ryzen 3600, they go from 0-11, meaning there are 12 threads, or 2x the core count, meaning it has hyperthreading. If you have double as many bars as cores, set threads on your VM to 2. If it's the same as the physical cores you have, set threads to 1.

* 
