QMAPBOXGL_VERSION = 6abd3d7
QMAPBOXGL_SITE = git://github.com/mapbox/mapbox-gl-native.git
QMAPBOXGL_LICENSE = BSD-3-Clause
QMAPBOXGL_LICENSE_FILES = LICENSE

QMAPBOXGL_DEPENDENCIES += host-pkgconf
QMAPBOXGL_DEPENDENCIES += host-python
QMAPBOXGL_DEPENDENCIES += sqlite
QMAPBOXGL_DEPENDENCIES += boost
QMAPBOXGL_DEPENDENCIES += qt5base
QMAPBOXGL_DEPENDENCIES += geometryhpp
QMAPBOXGL_DEPENDENCIES += nunicode
QMAPBOXGL_DEPENDENCIES += rapidjson
QMAPBOXGL_DEPENDENCIES += variant
QMAPBOXGL_DEPENDENCIES += geojsonvt
QMAPBOXGL_DEPENDENCIES += protozero
QMAPBOXGL_DEPENDENCIES += gtest
QMAPBOXGL_DEPENDENCIES += openssl

#QMAPBOXGL_DEPENDENCIES += qttools-native
QMAPBOXGL_DEPENDENCIES += qt5location

QMAPBOXGL_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
QMAPBOXGL_CONF_OPTS += -DCMAKE_CXX_FLAGS=-fPIC

ifeq ($(BR2_PACKAGE_QMAPBOXGL_GLES2),y)
	QMAPBOXGL_OPENGL_CFLAGS = -DMBGL_USE_GLES2
	QMAPBOXGL_OPENGL_LFLAGS = -lGLESv2
	QMAPBOXGL_DEPENDENCIES += libgles
else
	QMAPBOXGL_OPENGL_LFLAGS = -lGL
	QMAPBOXGL_DEPENDENCIES += libgl
endif

# macro to help fetching pkg-config settings
QMAPBOXGL_PKGCONF = $(PKG_CONFIG_HOST_BINARY) $1 $2

pkg-conf-cflags = $(call QMAPBOXGL_PKGCONF,--cflags,$1)
pkg-conf-libs   = $(call QMAPBOXGL_PKGCONF,--libs  ,$1)

define QMAPBOXGL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		PYTHON=$(HOST_DIR)/usr/bin/python2 \
		$(HOST_DIR)/usr/bin/python2 ./deps/run_gyp \
        --depth=$(@D) $(@D)/platform/qt/platform.gyp \
        -I $(@D)/config.gypi \
        -Dqt_image_decoders=1 \
        -Dopengl_cflags="$(QMAPBOXGL_OPENGL_CFLAGS)" \
        -Dopengl_ldflags="$(QMAPBOXGL_OPENGL_LFLAGS)" \
        -Dgeojsonvt_static_libs="-lgeojsonvt" \
        -Dnunicode_static_libs="-lnu" \
        -Dqt_moc="$(HOST_DIR)/usr/bin/moc" \
        -Dqt_rcc="$(HOST_DIR)/usr/bin/rcc" \
        -Dqt_core_cflags="`$(call pkg-conf-cflags,Qt5Core)`" \
        -Dqt_core_ldflags="`$(call pkg-conf-libs,Qt5Core)`" \
        -Dqt_gui_cflags="`$(call pkg-conf-cflags,Qt5Gui)`" \
        -Dqt_gui_ldflags="`$(call pkg-conf-libs,Qt5Gui)`" \
        -Dqt_location_cflags="`$(call pkg-conf-cflags,Qt5Location)`" \
        -Dqt_location_ldflags="`$(call pkg-conf-libs,Qt5Location)`" \
        -Dqt_network_cflags="`$(call pkg-conf-cflags,Qt5Network)`" \
        -Dqt_network_ldflags="`$(call pkg-conf-libs,Qt5Network)`" \
        -Dqt_opengl_cflags="`$(call pkg-conf-cflags,Qt5OpenGL)`" \
        -Dqt_opengl_ldflags="`$(call pkg-conf-libs,Qt5OpenGL)`" \
        -Dqt_positioning_cflags="`$(call pkg-conf-cflags,Qt5Positioning)`" \
        -Dqt_positioning_ldflags="`$(call pkg-conf-libs,Qt5Positioning)`" \
        -Dqt_qml_cflags="`$(call pkg-conf-cflags,Qt5Qml)`" \
        -Dqt_qml_ldflags="`$(call pkg-conf-libs,Qt5Qml)`" \
        -Dqt_quick_cflags="`$(call pkg-conf-cflags,Qt5Quick)`" \
        -Dqt_quick_ldflags="`$(call pkg-conf-libs,Qt5Quick)`" \
        -Dsqlite_cflags="`$(call pkg-conf-cflags,sqlite3)`" \
        -Dsqlite_ldflags="`$(call pkg-conf-libs,sqlite3)`" \
        -Dzlib_cflags="`$(call pkg-conf-cflags,zlib)`" \
        -Dzlib_ldflags="`$(call pkg-conf-libs,zlib)`" \
        --generator-output=$(@D)/build \
        -f make \
	)
endef

QMAPBOXGL_MAKE_OPTS += BUILDTYPE=Release
QMAPBOXGL_MAKE_OPTS += V=1

define QMAPBOXGL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(QMAPBOXGL_MAKE_OPTS) -C $(@D)/build
endef

define QMAPBOXGL_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/mapbox
	cp -r $(@D)/platform/qt/include/* $(STAGING_DIR)/usr/include/mapbox

	$(INSTALL) -m 755 $(@D)/build/out/Release/qmapboxgl $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 $(@D)/build/out/Release/qquickmapboxgl $(TARGET_DIR)/usr/bin

	$(INSTALL) -C $(@D)/build/out/Release/lib.target/ libqmapboxgl $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
