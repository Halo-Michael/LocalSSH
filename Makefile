TARGET = LocalSSH
VERSION = 0.2.1

.PHONY: all clean

all: clean postinst prerm
	mkdir com.michael.localssh_$(VERSION)_iphoneos-arm
	mkdir com.michael.localssh_$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.localssh_$(VERSION)_iphoneos-arm/DEBIAN
	mv postinst/.theos/obj/postinst prerm/.theos/obj/prerm com.michael.localssh_$(VERSION)_iphoneos-arm/DEBIAN
	dpkg -b com.michael.localssh_$(VERSION)_iphoneos-arm

postinst: clean
	sh make-postinst.sh

prerm: clean
	sh make-prerm.sh

clean:
	rm -rf com.michael.localssh_* postinst/.theos prerm/.theos
