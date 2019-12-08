### NanoPi R1s H5 一键制作OpenWrt镜像脚本

#### Intro
此项目参考N1构建Openwrt的脚本，使用 FriendlyWrt的镜像作为基础启动镜像，并合并Openwrt的rootfs包来构建 NanoPi R1s H5 使用的Openwrt镜像。
可直接使用Lean的代码构建Openwrt rootfs，使用本脚本构建可启动的openwrt。

#### Usage
1. 编译, 不会的可以去 [Lean's OpenWrt source](https://github.com/coolsnowwolf/lede "Lean's OpenWrt source")  
   target选 "QEMU ARM Virtual Machine" > "ARMv8 multiplatform"
2. 将编译好的固件放入到"openwrt"目录  
   注意: 固件格式只支持 " *rootfs.tar.gz "、" *ext4-factory.img[.gz] "、" *root.ext4[.gz] "
3. 执行bash mk.sh, 默认输出路径"out/xxx.img.gz"
4. 写入U盘启动OpenWrt

#### Build Script
```
git clone https://github.com/jerrykuku/mkr1s.git
cd mkr1s
sudo ./mk.sh
```

#### 已知的问题
1. 生成的固件，外壳上的 LAN WAN口将会对调 即：原生G口为LAN口 USB->8153B的G口为WAN。
2. 目前无wifi支持。  

#### 感谢
https://github.com/tuanqing/mknop