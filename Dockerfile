FROM debian:testing

# http://xecdesign.com/compiling-a-kernel/

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential \
                       curl \
                       git \
                       lib32z1 \
                       lib32ncurses5 \
                       libncurses5-dev

RUN touch /etc/apt/sources.list.d/crosstools.list
RUN curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -

RUN dpkg --add-architecture armhf
RUN apt-get update

WORKDIR /root

RUN git clone https://github.com/raspberrypi/linux.git
RUN git clone https://github.com/raspberrypi/tools.git

ADD linux-arm.patch /root/linux-arm.patch
RUN patch -p1 -d /root/linux/ -i /root/linux-arm.patch


WORKDIR /root/linux

RUN make mrproper
RUN make ARCH=arm versatile_defconfig
# make ARCH=arm menuconfig
ADD config /root/linux/.config

ENV CCPREFIX /root/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-

# make ARCH=arm CROSS_COMPILE=${CCPREFIX}
# make ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=../modules modules_install
# docker cp CONTAINER:PATH HOSTPATH
