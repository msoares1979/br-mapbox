GEOJSONVT_VERSION = v4.1.2
GEOJSONVT_SITE = $(call github,mapbox,geojson-vt-cpp,$(GEOJSONVT_VERSION))
GEOJSONVT_INSTALL_STAGING = YES
GEOJSONVT_LICENSE = BSD
GEOJSONVT_LICENSE_FILES = LICENSE

GEOJSONVT_DEPENDENCIES += host-python
GEOJSONVT_DEPENDENCIES += rapidjson variant

define GEOJSONVT_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		PYTHON=$(HOST_DIR)/usr/bin/python2 \
		$(HOST_DIR)/usr/bin/python2 ./deps/run_gyp \
    	geojsonvt.gyp --depth=$(@D) -Goutput_dir=$(@D) --generator-output=$(@D)/build \
		-Dinstall_prefix=$(STAGING_DIR)/usr \
	    -Drapidjson_cflags=""\
		-Dvariant_cflags="" \
		-Dgtest=0 \
		-Dglfw=0 \
	)
endef

GEOJSONVT_MAKE_OPTS += CXXFLAGS=-fPIC
define GEOJSONVT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(GEOJSONVT_MAKE_OPTS) -C $(@D)/build
endef

define GEOJSONVT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build install
endef

$(eval $(generic-package))
