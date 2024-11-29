BUILD_DIR := build
TAP := $(BUILD_DIR)/panda48.tap
FONTBIN := $(BUILD_DIR)/font.bin

all: $(TAP)

$(TAP): loader.bas $(shell find . -name \*.z80) $(FONTBIN)
	mkdir -p $(BUILD_DIR)
	bas2tap -a loader.bas $@
	sjasmplus -DTAPNAME='"$@"' -DFONT=$(FONTBIN) --sym=symbols.txt main.z80

$(FONTBIN): font.yaml
	zxtools pack-font font.yaml -o $@

install-tools:
	cd tools && go install ./...

clean:
	rm -f $(TAP)

.PHONY: all clean install-tools
