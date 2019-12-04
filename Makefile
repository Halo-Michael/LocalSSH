TARGET = LocalSSH
VERSION = 0.1.0
CC = xcrun -sdk iphoneos clang -arch arm64 -miphoneos-version-min=11.0
LDID = ldid

.PHONY: all clean

all: clean postinst prerm
	mkdir com.michael.localssh-$(VERSION)_iphoneos-arm
	mkdir com.michael.localssh-$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.localssh-$(VERSION)_iphoneos-arm/DEBIAN
	mv postinst com.michael.localssh-$(VERSION)_iphoneos-arm/DEBIAN
	mv prerm com.michael.localssh-$(VERSION)_iphoneos-arm/DEBIAN
	dpkg -b com.michael.localssh-$(VERSION)_iphoneos-arm

postinst: clean
	$(CC) postinst.c -o postinst
	strip postinst
	$(LDID) -Sentitlements.xml postinst

prerm: clean
	$(CC) prerm.c -o prerm
	strip prerm
	$(LDID) -Sentitlements.xml prerm

clean:
	rm -rf com.michael.localssh-*
	rm -f postinst prerm
