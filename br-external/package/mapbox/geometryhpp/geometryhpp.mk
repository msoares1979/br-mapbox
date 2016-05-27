GEOMETRYHPP_VERSION = 0.5.0
GEOMETRYHPP_SITE = https://github.com/mapbox/geometry.hpp/archive/
GEOMETRYHPP_SOURCE = v$(GEOMETRYHPP_VERSION).tar.gz
GEOMETRYHPP_LICENSE = ICS
GEOMETRYHPP_LICENSE_FILES = LICENSE

define GEOMETRYHPP_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/mapbox
	cp -R $(@D)/include/mapbox/* $(STAGING_DIR)/usr/include/mapbox
endef

$(eval $(generic-package))
