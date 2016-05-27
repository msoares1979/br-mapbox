GEOJSONVT_VERSION = 4.1.2
GEOJSONVT_SITE = https://github.com/mapbox/geojson-vt-cpp/archive
GEOJSONVT_SOURCE = v$(GEOJSONVT_VERSION).tar.gz
GEOJSONVT_INSTALL_STAGING = YES
GEOJSONVT_LICENSE = BDS-3-Clause
GEOJSONVT_LICENSE_FILES = LICENSE

GEOJSONVT_DEPENDENCIES += rapidjson variant

define GEOJSONVT_CONFIGURE_CMDS
	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		PYTHON=$(HOST_DIR)/usr/bin/python2 \
		$(HOST_DIR)/usr/bin/python2 ./deps/run_gyp \
    	geojsonvt.gyp --depth=$(@D) -Goutput_dir=$(@D) --generator-output=$(@D)/build \
		-Dinstall_prefix=$(STAGING_DIR)/usr \
	    -Drapidjson_cflags=""\
		-Dvariant_cflags="" \
		-Dgtest=0 \
		-Dglfw=0" \
	)
endef

GEOJSONVT_MAKE_OPTS += CXXFLAGS=-fPIC
define GEOJSONVT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build
endef

define GEOJSONVT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(GEOJSONVT_MAKE_OPTS) -C $(@D)/build install
endef

$(eval $(generic-package))
