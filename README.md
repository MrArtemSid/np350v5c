# np350v5c
Windows:
If u face BSOD or error 31 on HD 7730m + HD 4000 then install Leshcat gpu drivers, which are included in this repo

Linux:
1. https://gist.github.com/DDoSolitary/ce7a005f9a139e0547484508a78259f7 (Enables hw acceleration and switches to external gpu)
$ sudo cp hwaccel-auto-config.sh /etc/profile.d/ 

2. radeon.si_support=0 amdgpu.si_support=1 to GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub

3. Enable 3 GB ZRAM
$ su
$ nano /etc/modules-load.d/zram.conf

zram

$ nano /etc/modprobe.d/zram.conf

options zram num_devices=4

$ nano /etc/udev/rules.d/99-zram.rules

KERNEL=="zram0", ATTR{disksize}="768Mb" RUN="/usr/bin/mkswap /dev/zram0", TAG+="systemd"
KERNEL=="zram1", ATTR{disksize}="768Mb" RUN="/usr/bin/mkswap /dev/zram1", TAG+="systemd"
KERNEL=="zram2", ATTR{disksize}="768Mb" RUN="/usr/bin/mkswap /dev/zram2", TAG+="systemd"
KERNEL=="zram3", ATTR{disksize}="768Mb" RUN="/usr/bin/mkswap /dev/zram3", TAG+="systemd"

$ nano /etc/fstab

/dev/zram0 none swap defaults 0 0
/dev/zram1 none swap defaults 0 0
/dev/zram2 none swap defaults 0 0
/dev/zram3 none swap defaults 0 0

$ echo "vm.swappiness=20" > /etc/sysctl.d/swap.conf

