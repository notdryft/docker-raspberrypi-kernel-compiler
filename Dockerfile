FROM debian:testing

WORKDIR /root

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential curl git lib32z1 lib32ncurses5 libncurses5-dev

RUN touch /etc/apt/sources.list.d/crosstools.list
RUN curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -

RUN dpkg --add-architecture armhf
RUN apt-get update

RUN git clone https://github.com/raspberrypi/linux.git
RUN git clone https://github.com/raspberrypi/tools.git

ADD linux-arm.patch linux-arm.patch
# RUN sed -i "s/^KVER:=\"[^\"]*\"/KVER:=\"3.18.5+\"/g" ~/rtl8188eu/config.mk

RUN patch -p1 -d linux/ < linux-arm.patch

RUN cd /root/linux && make ARCH=arm versatile_defconfig
# make ARCH=arm menuconfig

ADD config /root/linux/.config

ENV CCPREFIX /root/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-

# make ARCH=arm CROSS_COMPILE=${CCPREFIX}
# make ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=../modules modules_install
# docker cp CONTAINER:PATH HOSTPATH
