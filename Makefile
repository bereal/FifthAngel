BUILD_DIR := build
TAP := $(BUILD_DIR)/angel5.tap
#FONTBIN := $(BUILD_DIR)/font.bin

all: $(TAP)

$(TAP): loader.bas $(shell find . -name \*.z80) $(shell find . -name \*.bin)
	mkdir -p $(BUILD_DIR)
	bas2tap -a loader.bas $@
	sjasmplus -DTAPNAME='"$@"' --sym=symbols.txt main.z80

#$(FONTBIN): font.yaml
#	zxtools pack-font font.yaml -o $@

clean:
	rm -f $(TAP)

.PHONY: all clean install-tools
