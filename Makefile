TARGET = LocalSSH
VERSION = 0.4.0
CC = xcrun -sdk ${THEOS}/sdks/iPhoneOS13.0.sdk clang -arch arm64 -arch arm64e -fobjc-arc -miphoneos-version-min=11.0
LDID = ldid

.PHONY: all clean

all: clean preinst postinst prerm
	mkdir com.michael.localssh_$(VERSION)_iphoneos-arm
	mkdir com.michael.localssh_$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.localssh_$(VERSION)_iphoneos-arm/DEBIAN
	cp triggers com.michael.localssh_$(VERSION)_iphoneos-arm/DEBIAN
	mv preinst postinst prerm com.michael.localssh_$(VERSION)_iphoneos-arm/DEBIAN
	dpkg -b com.michael.localssh_$(VERSION)_iphoneos-arm

preinst: clean
	$(CC) preinst.m -o preinst
	strip preinst
	$(LDID) -Sentitlements.xml preinst

postinst: clean
	$(CC) postinst.m -o postinst
	strip postinst
	$(LDID) -Sentitlements.xml postinst

prerm: clean
	$(CC) prerm.m -o prerm
	strip prerm
	$(LDID) -Sentitlements.xml prerm

clean:
	rm -rf com.michael.localssh_* preinst postinst prerm
