ifneq ($(CHECKRA1N_MEMO),1)
$(error Use the main Makefile)
endif

GZIP_VERSION := 1.10
DEB_GZIP_V   ?= $(GZIP_VERSION)

ifneq ($(wildcard $(BUILD_WORK)/gzip/.build_complete),)
gzip:
	@echo "Using previously built gzip."
else
gzip: setup
	cd $(BUILD_WORK)/gzip && ./configure -C \
		--host=$(GNU_HOST_TRIPLE) \
		--prefix=/usr \
		--disable-dependency-tracking
	$(MAKE) -C $(BUILD_WORK)/gzip install \
		DESTDIR=$(BUILD_STAGE)/gzip
	touch $(BUILD_WORK)/gzip/.build_complete
endif

gzip-package: gzip-stage
	# gzip.mk Package Structure
	rm -rf $(BUILD_DIST)/gzip
	mkdir -p $(BUILD_DIST)/gzip
	
	# gzip.mk Prep gzip
	$(FAKEROOT) cp -a $(BUILD_STAGE)/gzip/usr $(BUILD_DIST)/gzip
	
	# gzip.mk Sign
	$(call SIGN,gzip,general.xml)
	
	# gzip.mk Make .debs
	$(call PACK,gzip,DEB_GZIP_V)
	
	# gzip.mk Build cleanup
	rm -rf $(BUILD_DIST)/gzip

.PHONY: gzip gzip-package
