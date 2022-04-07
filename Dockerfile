FROM debian:stretch-slim
ENV DEBIAN_FRONTEND noninteractive

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && apt-get -y install \
	alien \
	autogen \
	bc \
	bison \
	build-essential \
	bzip2 \
	bzr \
	cmake \
	cmake-curses-gui \
	cpio \
	dejagnu \
	flex \
	gawk \
	git \
	libncurses5-dev \
	libtool-bin \
	lsb-core \
	make \
	python2.7-dev \
	rsync \
	scons \
	texinfo \
	tree \
	unzip \
	wget \
	zip \
	zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/workspace
WORKDIR /root

COPY support .

VOLUME /root/workspace
WORKDIR /root/workspace

CMD ["/bin/bash"]