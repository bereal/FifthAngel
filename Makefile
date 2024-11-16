BUILD_DIR := build
TAP := $(BUILD_DIR)/panda48.tap

all: $(TAP)

$(TAP): loader.bas $(shell find . -name \*.z80)
	mkdir -p $(BUILD_DIR)
	bas2tap -a loader.bas $@
	sjasmplus -DTAPNAME='"$@"' main.z80

clean:
	rm -f $(TAP)

.PHONY: all clean
