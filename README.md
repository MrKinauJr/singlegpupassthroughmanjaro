# singlegpupassmanjaro

Run **1-update_things.sh** in terminal

Run **2-edit_grub.sh** in terminal. A text editor will open.
On the line **GRUB_CMDLINE_LINUX_DEFAULT=**, *inside* the quotation marks, add these:
## iommu=pt iommu=1 amd_iommu=on video=efifb:off
*If on Intel, change amd_iommu=on to intel_iommu=on*
Then, CTRL+X, Y, Enter.

Run **3-rebuild_grub.sh** in terminal
###### Which will require a reboot of your pc


Run **4-reboot.sh** in terminal. This will reboot you

When back, run **5-check_iommu.sh**, and hope it says those arguments you added earlier, along with a bunch of other stuff. If it does, you win! If not, you've epically failed, I can't help.

Run **6-show_devices.sh**, and look for a "VGA COMPATIBLE CONTROLLER", and it's Audio device. 
## If your VGA and AUDIO deivces are in the same IOMMU group, with nothing else in it, good.
## If your VGA and AUDIO devices aren't in the same IOMMU group, but they're each in their own group, with nothing else in either, good.
## If your VGA and AUDIO devices are in the same group as other stuff, not good. I can't help

Now, note down the numbers and letters which come just before the device names. 
My video adapter is 2b:00:0, and audio is 2b:00:1, for example.
Just make a text file somewhere to keep them safe.

Now, we're gonna install some software.
###### this next script will make 4 popups which want your password. This is ok, it is starting and enabling services.
Run **7-install_necessary_stuffs** in terminal. Say yes when it asks you to.
