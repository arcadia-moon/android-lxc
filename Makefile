BUILD_DIR := ${PWD}
DESTDIR := ${BUILD_DIR}/build

API := 27
TARGET := android-${API}
NDK_TMP_DIR := ${BUILD_DIR}/android-ndk-r17b
NDK_DIR := ${BUILD_DIR}/ndk-${API}

SYSROOT := ${NDK_DIR}/sysroot
CFLAGS := -D__ANDROID_API__=${API} -DANDROID_PLATFORM=android-${API} -fomit-frame-pointer -DANDROID -pie -fPIE --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${SYSROOT}/arm-linux-androideabi
DEFAULT_CFLAGS := -fomit-frame-pointer -DANDROID -pie -fPIE -fPIC --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${DESTDIR}/system/ -isystem ${DESTDIR}/system/include -L${DESTDIR}/system/lib
all: setNDK setNDKToolchain libcap lxc lxc-templates perl libgpg-error libgcrypt libassuan libksba libksba npth ntbtls ncurses libiconv pinentry gnupg binutils-gdb openssl

build: libcap lxc lxc-templates perl libgpg-error libgcrypt libassuan libksba libksba npth ntbtls ncurses libiconv pinentry gnupg binutils-gdb openssl

setNDK:
	wget http://dl.google.com/android/repository/android-ndk-r17b-linux-x86_64.zip -O /tmp/android-ndk-r17b-linux-x86_64.zip
	unzip /tmp/android-ndk-r17b-linux-x86_64.zip -d ${BUILD_DIR}

setNDKToolchain:
	${NDK_TMP_DIR}/build/tools/make_standalone_toolchain.py --arch arm --api ${API} --install-dir ${NDK_DIR}

libcap: dummy
	cd ${BUILD_DIR}/libcap/libcap && \
	PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR} \
	DESTDIR=${BUILD_DIR}/build \
	SYSROOT=${NDK_DIR}/sysroot \
	CC=arm-linux-androideabi-gcc \
	CFLAGS="-fomit-frame-pointer -DANDROID -fPIC --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${SYSROOT}/arm-linux-androideabi" \
	LDFLAGS="--sysroot=${SYSROOT}" \
	BUILD_CC=gcc \
	make -e LIBATTR=no && \
	make DESTDIR=${DESTDIR}/system INCDIR=/include LIBDIR=/lib install

lxc: dummy
	cd ${BUILD_DIR}/lxc && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export CC=arm-linux-androideabi-gcc && \
	export LD=arm-linux-androideabi-ld && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS} -isystem ${DESTDIR}/system/include -L${DESTDIR}/system/lib" && \
	export CXXFLAGS="${CFLAGS}" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/lxc/autogen.sh && \
	${BUILD_DIR}/lxc/configure --host=arm-linux-androideabi --disable-api-docs --disable-lua --disable-python --disable-examples --prefix=/system --datadir=/system/usr/share --with-runtime-path=/cache/ --bindir=/system/bin --libexecdir=/system/libexec --sbindir=/system/bin --libdir=/system/lib  --localstatedir=/data/lxc --with-config-path=/data/lxc/containers/ --with-systemdsystemunitdir="/system/lib systemd" && \
	make && \
	make install

lxc-templates: dummy
	cd ${BUILD_DIR}/lxc-templates && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export CC=arm-linux-androideabi-gcc && \
	export LD=arm-linux-androideabi-ld && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/lxc-templates/autogen.sh && \
	${BUILD_DIR}/lxc-templates/configure --host=arm-linux-androideabi --disable-api-docs --disable-lua --disable-python --disable-examples --prefix=/system --datadir=/system/usr/share --with-runtime-path=/cache/ --bindir=/system/bin --libexecdir=/system/bin --sbindir=/system/bin --libdir=/system/lib --localstatedir=/data/lxc --with-config-path=/data/lxc/containers/ && \
	make && \
	make install

perl: dummy
	cd ${BUILD_DIR}/perl5 && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="-fomit-frame-pointer -DANDROID -pie -fPIE -fPIC --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${DESTDIR}/system/" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	cp -rf ../perl-cross/* ./  && \
	${BUILD_DIR}/perl5/configure --target=arm-linux-androideabi --sysroot=${SYSROOT} --prefix=/system --man1dir=/system/usr/local/share/man --man3dir=/system/usr/local/share/man && \
	make && \
	make install

gnupg: libgpg-error

libgpg-error: dummy
	cd ${BUILD_DIR}/libgpg-error/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/libgpg-error/autogen.sh && \
	${BUILD_DIR}/libgpg-error/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --disable-doc --enable-maintainer-mode && \
	make && \
	make install

libgcrypt: dummy#libgpg-error
	cd ${BUILD_DIR}/libgcrypt/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/libgcrypt/autogen.sh && \
	${BUILD_DIR}/libgcrypt/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --with-gpg-error-prefix=${DESTDIR}/system/ --disable-doc --enable-maintainer-mode && \
	make && \
	make install

libassuan: dummy#libgpg-error
	cd ${BUILD_DIR}/libassuan/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/libassuan/autogen.sh && \
	${BUILD_DIR}/libassuan/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --with-gpg-error-prefix=${DESTDIR}/system/ --disable-doc --enable-maintainer-mode && \
	make && \
	make install

libksba: dummy#libgpg-error
	cd ${BUILD_DIR}/libksba/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/libksba/autogen.sh && \
	${BUILD_DIR}/libksba/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --with-gpg-error-prefix=${DESTDIR}/system/ --disable-doc --enable-maintainer-mode && \
	make && \
	make install

npth: dummy
	cd ${BUILD_DIR}/npth/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/npth/autogen.sh && \
	${BUILD_DIR}/npth/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --disable-doc --enable-maintainer-mode && \
	make && \
	make install

ntbtls: dummy
	cd ${BUILD_DIR}/ntbtls/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/ntbtls/autogen.sh && \
	${BUILD_DIR}/ntbtls/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --with-libgpg-error-prefix=${DESTDIR}/system/ --with-libgcrypt-prefix=${DESTDIR}/system/ --with-ksba-prefix=${DESTDIR}/system/ --disable-doc --enable-maintainer-mode && \
	make && \
	make install

ncurses: dummy
	cd ${BUILD_DIR}/ncurses/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/ncurses/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --disable-doc && \
	make || \
	make install || \
	echo "PLEASE CHECK"

libiconv: dummy
	wget -c https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz && \
	tar -xf ${BUILD_DIR}/libiconv-1.15.tar.gz && \
	mv libiconv-1.15 libiconv && \
	cd ${BUILD_DIR}/libiconv/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/libiconv/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --disable-doc && \
	make && \
	make install

pinentry: dummy
	cd ${BUILD_DIR}/pinentry/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/pinentry/autogen.sh && \
	${BUILD_DIR}/pinentry/configure --host arm-linux-androideabi --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --disable-pinentry-qt --enable-pinentry-curses --with-gpg-error-prefix=${DESTDIR}/system/ --with-libassuan-prefix=${DESTDIR}/system/ --enable-ncurses --with-ncurses-include-dir=${DESTDIR}/system/ --with-libiconv-prefix=${DESTDIR}/system/ --disable-doc && \
	echo "all: " > ${BUILD_DIR}/pinentry/doc/Makefile && \
	echo "all: " > ${BUILD_DIR}/pinentry/doc/Makefile.am && \
	echo "all: " > ${BUILD_DIR}/pinentry/doc/Makefile.in && \
	make && \
	make install

gnupg: dummy
	cd ${BUILD_DIR}/gnupg/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/gnupg/autogen.sh && \
	${BUILD_DIR}/gnupg/configure --host arm-linux-androideabi --prefix="/system" --bindir=/system/bin --includedir=/system/include --libdir=/system/lib  --datarootdir=/system/usr/local --with-libgpg-error-prefix=${DESTDIR}/system/ --with-libgcrypt-prefix=${DESTDIR}/system/ --with-libassuan-prefix=${DESTDIR}/system/ --with-ksba-prefix=${DESTDIR}/system/ --with-npth-prefix=${DESTDIR}/system/ --enable-ntbtls --with-ntbtls-prefix=${DESTDIR}/system/ --enable-maintainer-mode --disable-doc && \
	make && \
	make install 

binutils-gdb: dummy
	cd ${BUILD_DIR}/binutils-gdb/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE -pie" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/binutils-gdb/configure --host arm-linux-androideabi --prefix="/system" --disable-nls --disable-werror --disable-gdb --disable-libdecnumber --disable-readline --disable-sim && \
	make && \
	make install 

openssl: dummy
	cd ${BUILD_DIR}/openssl/ && \
	export PATH=${PATH}:${NDK_DIR}/bin:${NDK_DIR}&& \
	export DESTDIR=${BUILD_DIR}/build && \
	export MANDIR=$(BUILD_DIR)/system/usr/local/share/man && \
	export DOCDIR=$(BUILD_DIR)/system/usr/local/share/doc/openssl && \
	export SYSROOT=${NDK_DIR}/sysroot && \
	export LDFLAGS="--sysroot=${SYSROOT}" && \
	export CFLAGS="${CFLAGS}" && \
	export CXXFLAGS="${CFLAGS}" && \
	export AR=arm-linux-androideabi-ar && \
	export LD=arm-linux-androideabi-ld && \
	export CC=arm-linux-androideabi-gcc && \
	export NM=arm-linux-androideabi-nm && \
	export RANLIB=arm-linux-androideabi-ranlib && \
	export READELF=arm-linux-androideabi-readelf && \
	export OBJDUMP=arm-linux-androideabi-objdump && \
	export MACHINE=armv7 && \
	export ARCH=arm64 && \
	export CFLAGS="${DEFAULT_CFLAGS}" && \
	export LDFLAGS="--sysroot=${SYSROOT} -fPIE" && \
	export BUILD_CC=gcc && \
	${BUILD_DIR}/openssl/config shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=${DESTDIR}/system/usr/local/ssl --prefix=${DESTDIR}/system && \
	make depend && \
	make && \
	make install_sw install_ssldirs 

dummy:

android-install: android-env-set android-lxc-install
	
android-env-set:
	adb root || \
	adb shell  mount -o rw,remount / && \
	adb shell  mount -o rw,remount /system && \
	adb shell mkdir -p /tmp && \
	adb shell ln -sf /system/bin /bin && \
	adb shell ln -sf /system/bin/sh /bin/sh && \
	adb shell ln -sf /system/bin/sh /bin/bash && \
	adb shell "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf" && \
	adb shell "echo 'nameserver 1.1.1.1' >> /etc/resolv.conf"

android-lxc-install:
	adb push ${DESTDIR}/* /

clean:
	cd ${BUILD_DIR}/libcap/libcap && \
	make clean && \
	cd ${BUILD_DIR}/lxc && \
	make clean
