FROM debian:testing

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y bc \
                       curl \
                       gcc \
                       git \
                       make \
                       lib32z1 \
                       lib32ncurses5 \
                       libncurses5-dev

WORKDIR /root

RUN git clone https://github.com/raspberrypi/linux.git
RUN git clone https://github.com/raspberrypi/tools.git

ADD linux-arm.patch /root/linux-arm.patch
RUN patch -p1 -d /root/linux/ -i /root/linux-arm.patch

WORKDIR /root/linux

ENV CCPREFIX /root/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-

RUN apt-get install -y build-

RUN make mrproper
RUN make ARCH=arm CROSS_COMPILE=${CCPREFIX} versatile_defconfig
# make ARCH=arm menuconfig
# check http://xecdesign.com/compiling-a-kernel/

# make ARCH=arm CROSS_COMPILE=${CCPREFIX}
# make ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=../modules modules_install

# docker cp CONTAINER:PATH HOSTPATH
