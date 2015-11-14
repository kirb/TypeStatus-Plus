include $(THEOS)/makefiles/common.mk

SUBPROJECTS = api app messages prefs springboard watch-app $(wildcard api/providers/*)

include $(THEOS_MAKE_PATH)/aggregate.mk

after-stage::
	mkdir -p $(THEOS_STAGING_DIR)/System/Library/Frameworks/UIKit.framework
	cp Resources/*.png $(THEOS_STAGING_DIR)/System/Library/Frameworks/UIKit.framework

after-install::
	install.exec "killall -9 Preferences"
