#!/bin/bash

red="\033[31m"
green="\033[32m"
white="\033[0m"

out_dir=out
openwrt_dir=openwrt
boot_dir="/media/boot"
rootfs_dir="/media/rootfs"
device="nanopi-r1s-h5"
loop=



if [ -d $out_dir ]; then
    sudo rm -rf $out_dir
fi

mkdir -p $out_dir/openwrt
sudo mkdir -p $rootfs_dir

# 解压openwrt固件
cd $openwrt_dir
if [ -f *ext4-factory.img.gz ]; then
    gzip -d *ext4-factory.img.gz
elif [ -f *root.ext4.gz ]; then
    gzip -d *root.ext4.gz
elif [ -f *rootfs.tar.gz ] || [ -f *ext4-factory.img ] || [ -f *root.ext4 ]; then
    [ ]
else
    echo -e "$red \n openwrt目录下不存在固件或固件类型不受支持! $white" && exit
fi

# 挂载openwrt固件
if [ -f *rootfs.tar.gz ]; then
    sudo tar -xzf *rootfs.tar.gz -C ../$out_dir/openwrt

fi

# 拷贝openwrt rootfs
echo -e "$green \n 提取OpenWrt ROOTFS... $white"
cd ../$out_dir
if df -h | grep $rootfs_dir > /dev/null 2>&1; then
    sudo cp -r $rootfs_dir/* openwrt/ && sync
    sudo umount $rootfs_dir
fi

#复制并创建备份
echo -e "$green \n 复制基础包 $white"
sudo cp -r ../armbian/$device.img.gz ../$out_dir/ && sync
echo -e "$green \n 解压缩 $white"
sudo gzip -dv $device.img.gz
loop=$(sudo losetup -P -f --show $device.img)

sudo mount -o rw ${loop}p2 $rootfs_dir

sudo chown -R root:root openwrt/
# sudo sed -i '/FAILSAFE/a\\n\tulimit -n 51200' openwrt/etc/init.d/boot




# 拷贝文件到启动镜像
cd ../
echo -e "$green \n 拷贝文件到启动镜像... $white"
sudo cp -r $out_dir/openwrt/* $rootfs_dir
sync

# 取消挂载


if df -h | grep $rootfs_dir > /dev/null 2>&1 ; then
    sudo umount $rootfs_dir
fi

[ $loop ] && sudo losetup -d $loop
 
# 清理残余

sudo rm -rf $rootfs_dir
sudo rm -rf $out_dir/openwrt
cd ./$out_dir
sudo mv $device.img $device-$(date +%Y-%m-%d).img
sudo gzip $device-$(date +%Y-%m-%d).img
cd ../
echo -e "$green \n 制作成功, 输出文件夹 --> $out_dir $white"

