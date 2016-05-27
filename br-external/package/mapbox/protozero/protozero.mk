PROTOZERO_VERSION = v1.3.0
PROTOZERO_SITE = $(call github,mapbox,protozero,$(PROTOZERO_VERSION))
PROTOZERO_INSTALL_STAGING = YES
PROTOZERO_LICENSE = BDS-3-Clause
PROTOZERO_LICENSE_FILES = LICENSE

define PROTOZERO_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/protozero
	cp -R $(@D)/include/protozero/* $(STAGING_DIR)/usr/include/protozero
endef

$(eval $(generic-package))
