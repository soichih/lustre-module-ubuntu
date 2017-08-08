FROM ubuntu:16.04

MAINTAINER Soichi Hayashi <hayashis@iu.edu>

#install deps
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted" >> /etc/apt/sources.list
RUN apt-get update && \
	apt-get build-dep -y linux-image-$(uname -r) && \
	apt-get install -y build-essential debhelper devscripts fakeroot kernel-wedge libudev-dev pciutils-dev texinfo xmlto libelf-dev python-dev liblzma-dev libaudit-dev dh-systemd module-assistant libreadline-dev dpatch libsnmp-dev quilt uuid-dev libblkid-dev dietlibc-dev git ed linux-headers-$(uname -r)

#install kernel and lustre sources
RUN git clone git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/xenial /usr/local/src/xenial
RUN git clone git://git.hpdd.intel.com/fs/lustre-release.git /usr/local/src/lustre-release

#build kernel
WORKDIR /usr/local/src/xenial
RUN git tag | grep $(uname -r | cut -d- -f1)-$(uname -r | cut -d- -f2) > /branchname
RUN git checkout $(cat /branchname)
ADD config .config
RUN touch .scmversion
RUN sed -i "s/^VERSION = .*/VERSION = $(uname -r | cut -d. -f1)/" Makefile
RUN sed -i "s/^PATCHLEVEL = .*/PATCHLEVEL = $(uname -r | cut -d. -f2)/" Makefile
RUN sed -i "s/^SUBLEVEL = .*/SUBLEVEL = $(uname -r | cut -d. -f3 | cut -d- -f1)/" Makefile
RUN sed -i "s/^EXTRAVERSION =.*/EXTRAVERSION = -$(uname -r | cut -d- -f2)-generic/" Makefile
RUN cat Makefile
RUN make -j 4

#build lustre
WORKDIR /usr/local/src/lustre-release
RUN git checkout b2_10
RUN sh autogen.sh
RUN ./configure  --disable-server --with-linux=/usr/local/src/xenial
RUN make debs -j 4

