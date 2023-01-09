#!/bin/bash

# Install livefs tool
apt install xorriso squashfs-tools python3-debian gpg liblz4-tool python3-pip zip -y
cd livefs-editor/
python3 -m pip install .

cd ..

export ORIG_ISO="{{ iso_file }}"
rm -rf mnt && mkdir mnt && mount -o loop $ORIG_ISO mnt
cp --no-preserve=all mnt/boot/grub/grub.cfg /tmp/grub.cfg
cp --no-preserve=all mnt/isolinux/txt.cfg /tmp/txt.cfg
sed -i 's/vmlinuz   quiet  ---/vmlinuz autoinstall quiet ---/g' /tmp/grub.cfg
sed -i 's/quiet  ---/autoinstall quiet ---/g' /tmp/txt.cfg
sed -i 's/timeout=30/timeout=1/g' /tmp/grub.cfg
export MODDED_ISO="{{ iso_file[:-4] }}-{{ modified_iso_extension }}.iso"
livefs-edit $ORIG_ISO $MODDED_ISO --cp /tmp/grub.cfg new/iso/boot/grub/grub.cfg --cp /tmp/txt.cfg new/iso/isolinux/txt.cfg --action-yaml iso-config.yaml

umount mnt
