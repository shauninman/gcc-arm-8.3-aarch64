# Creating an aarch64/arm64-compatible GCC 8.3 Toolchain

Equivalent to [GNU Toolchain for the A-profile Architecture Version 8.3-2019.03](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads/8-3-2019-03) (for use with docker on M1 Macs).

## Installation

With Docker installed and running, `make shell` builds the image and drops into a shell inside the container. To minimize conflicts I tried to pick a distro released shortly before the original precompiled toolchains were produced.

After building the first time, `make shell` will skip building and drop into the shell.

## Compilation

Building was a manual process because the blob and repo downloading kept timing out or dropping the connection (I might be having unrelated networking issues). It went something like this:

	wget -P /usr/local/bin https://raw.githubusercontent.com/git/git/master/contrib/workdir/git-new-workdir
	chmod +x /usr/local/bin/git-new-workdir
	
	cd ~/
	git clone https://git.linaro.org/toolchain/abe.git
	cd abe
	git checkout -f 1acedaed7871ea2c37dba9a899742d5c1b17a0f1
	
	./configure
	
	# these timeout a lot (blobs on armkeil.blob.core.windows.net especially)
	# so we retrieve them manually individually, saving the largest for last,
	# then disable automatic retrieval so --build all goes smoothly
	
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve python
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve gmp
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve mpfr
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve mpc
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve expat
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve libiconv
	
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve dejagnu
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve glibc
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve binutils
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve gcc
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --retrieve linux
	
	git apply ../0001-abe-tmp-disable-retrieve.patch
	
	# this takes _ages_ but possibly worth it to never have to checkout linux again...
	# the tar.xz ends up being ~7GB (I wonder if that has some build products in it...)
	
	# tar --xz -cvf snapshots.tar.xz snapshots/
	# mv snapshots.tar.xz ~/workspace
	# rm snapshots.tar.xz
	
	./abe.sh --manifest /root/gcc-arm-arm-linux-gnueabihf-abe-manifest.txt --disable make_docs --build all 
	
	cd builds/destdir/
	mv aarch64-unknown-linux-gnu gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf
	tar --xz -cvf gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf.tar.xz gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf/
	mv gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf aarch64-unknown-linux-gnu
	mv gcc-arm-8.3-2019.03-aarch64-arm-linux-gnueabihf.tar.xz ~/workspace
	cd -

I hope I never have to do anything like this again...
