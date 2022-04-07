# Creating an aarch64/arm64-compatible GCC 8.3 Toolchain

Equivalent to [GNU Toolchain for the A-profile Architecture Version 8.3-2019.03](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads/8-3-2019-03) (for use with docker on M1 Macs).

## Installation

With Docker installed and running, `make shell` builds the image and drops into a shell inside the container. To minimize conflicts I tried to pick a distro released shortly before the original precompiled toolchains were produced.

After building the first time, `make shell` will skip building and drop into the shell.

## Compilation

Building was a manual process because ABE no longer included `isl` by default. It went something like this:

	wget -P /usr/local/bin https://raw.githubusercontent.com/git/git/master/contrib/workdir/git-new-workdir
	chmod +x /usr/local/bin/git-new-workdir
	
	cd ~/
	git clone https://git.linaro.org/toolchain/abe.git
	cd abe
	git checkout -f 1acedaed7871ea2c37dba9a899742d5c1b17a0f1
	
	./configure
	
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve isl
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve all
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --disable make_docs --build gmp
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --disable make_docs --build isl
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --disable make_docs --build all 
	
	cd builds/destdir/
	mv aarch64-unknown-linux-gnu gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf
	tar --xz -cvf gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf.tar.xz gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf/
	mv gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf aarch64-unknown-linux-gnu
	mv gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf.tar.xz ~/workspace
	cd -

I hope I never have to do anything like this again...except I did. The very next day.