SYSTEMD_STUB_FILE ?= /usr/lib/systemd/boot/efi/linuxx64.efi.stub
CMDLINE_FILE ?= ./assets/cmdline.txt
OSRELEASE_FILE ?= ./assets/os-release
KERNEL_FILE ?= ./assets/bzImage
INITRD_FILE ?= ./assets/rootfs.cpio
SPLASH_FILE ?= ./assets/splash.bmp
OUTPUT_EFI_FILE ?= ./assets/linux.efi
