GEOMETRYHPP_VERSION = v0.5.0
GEOMETRYHPP_SITE = $(call github,mapbox,geometry.hpp,$(GEOMETRYHPP_VERSION))
GEOMETRYHPP_INSTALL_STAGING = YES
GEOMETRYHPP_LICENSE = ICS
GEOMETRYHPP_LICENSE_FILES = LICENSE

define GEOMETRYHPP_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/mapbox
	cp -R $(@D)/include/mapbox/* $(STAGING_DIR)/usr/include/mapbox
endef

$(eval $(generic-package))
