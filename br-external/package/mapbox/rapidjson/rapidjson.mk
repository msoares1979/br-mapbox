RAPIDJSON_VERSION = 1.0.2
RAPIDJSON_SITE = https://github.com/miloyip/rapidjson/archive
RAPIDJSON_SOURCE = v$(RAPIDJSON_VERSION).tar.gz
RAPIDJSON_INSTALL_STAGING = YES
RAPIDJSON_LICENSE = BDS-3-Clause
RAPIDJSON_LICENSE_FILES = LICENSE

define RAPIDJSON_INSTALL_STAGING_CMDS
	cp -r $(@D)/include/rapidjson $(STAGING_DIR)/usr/include
endef

$(eval $(generic-package))
