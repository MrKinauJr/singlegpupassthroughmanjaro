# singlegpupassmanjaro

Run **1-update_things.sh** in terminal

Run **2-edit_grub.sh** in terminal. A text editor will open.
On the line **GRUB_CMDLINE_LINUX_DEFAULT=**, *inside* the quotation marks, add these:
iommu=pt iommu=1 amd_iommu=on video=efifb:off
## If on Intel, change amd_iommu=on to intel_iommu=on
