#!/bin/bash
# TOREVIEW https://gist.github.com/brendenyule/17159fc35d4d94c38895e8c1035c935f
# SD CARD https://stackoverflow.com/a/64451008

set -ex

export CI_PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )/../"

virtfs_share=""
#virtfs_share="-virtfs local,path=/tmp/virt-share,mount_tag=host0,security_model=mapped,id=host0"

#KVMDISPLAY="-display gtk,gl=on -vga virtio"
#KVMDISPLAY="-display gtk,gl=on,grab-on-hover=on -device virtio-vga,xres=1280,yres=800"
KVMDISPLAY="-display gtk"
#KVMDISPLAY="-display sdl,gl=on"

DISKIMG=${CI_PROJECT_DIR}/output/disk.img

  #-net nic,model=virtio -net user \

  #-netdev user,id=mynet0,hostfwd=tcp::${VMN}2222-:22 \
  #-device virtio-net-pci,netdev=mynet0,bootindex=4,romfile="" \
qemu-system-x86_64 -no-reboot -enable-kvm \
  -bios /usr/share/ovmf/x64/OVMF.fd \
  -drive file=${DISKIMG},index=0,media=disk,if=virtio \
  -cpu host \
  -smp cpus=2 \
  -m 4096 \
  -machine type=pc,accel=kvm \
  -net none \
  $KVMDISPLAY \
  $virtfs_share

