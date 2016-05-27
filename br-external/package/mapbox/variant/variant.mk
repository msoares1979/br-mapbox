VARIANT_VERSION = v1.1.0
VARIANT_SITE = $(call github,mapbox,variant,$(VARIANT_VERSION))
VARIANT_INSTALL_STAGING = YES
VARIANT_LICENSE = BDS-3-Clause
VARIANT_LICENSE_FILES = LICENSE

define VARIANT_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/mapbox
	cp $(@D)/*.hpp $(STAGING_DIR)/usr/include/mapbox
endef

$(eval $(generic-package))
