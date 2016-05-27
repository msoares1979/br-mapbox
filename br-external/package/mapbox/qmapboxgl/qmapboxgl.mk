QMAPBOXGL_VERSION = 6abd3d7
QMAPBOXGL_SITE = git://github.com/mapbox/mapbox-gl-native.git
QMAPBOXGL_LICENSE = BSD-3-Clause
QMAPBOXGL_LICENSE_FILES = LICENSE

QMAPBOXGL_DEPENDENCIES += host-pkg-conf
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

#QMAPBOXGL_DEPENDENCIES += qttools-native
#QMAPBOXGL_DEPENDENCIES += qtlocation

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
        -Dqt_moc="$(shell $(QT5_QMAKE) -query QT_INSTALL_BINS)/moc" \
        -Dqt_rcc="$(shell $(QT5_QMAKE) -query QT_INSTALL_BINS)/rcc" \
        -Dqt_core_cflags="`pkg-config --cflags Qt5Core`" \
        -Dqt_core_ldflags="`pkg-config --libs Qt5Core`" \
        -Dqt_gui_cflags="`pkg-config --cflags Qt5Gui`" \
        -Dqt_gui_ldflags="`pkg-config --libs Qt5Gui`" \
        -Dqt_location_cflags="`pkg-config --cflags Qt5Location`" \
        -Dqt_location_ldflags="`pkg-config --libs Qt5Location`" \
        -Dqt_network_cflags="`pkg-config --cflags Qt5Network`" \
        -Dqt_network_ldflags="`pkg-config --libs Qt5Network`" \
        -Dqt_opengl_cflags="`pkg-config --cflags Qt5OpenGL`" \
        -Dqt_opengl_ldflags="`pkg-config --libs Qt5OpenGL`" \
        -Dqt_positioning_cflags="`pkg-config --cflags Qt5Positioning`" \
        -Dqt_positioning_ldflags="`pkg-config --libs Qt5Positioning`" \
        -Dqt_qml_cflags="`pkg-config --cflags Qt5Qml`" \
        -Dqt_qml_ldflags="`pkg-config --libs Qt5Qml`" \
        -Dqt_quick_cflags="`pkg-config --cflags Qt5Quick`" \
        -Dqt_quick_ldflags="`pkg-config --libs Qt5Quick`" \
        -Dsqlite_cflags="`pkg-config --cflags sqlite3`" \
        -Dsqlite_ldflags="`pkg-config --libs sqlite3`" \
        -Dzlib_cflags="`pkg-config --cflags zlib`" \
        -Dzlib_ldflags="`pkg-config --libs zlib`" \
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
