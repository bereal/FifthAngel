BUILD_DIR := build
TAP := $(BUILD_DIR)/angel5.tap
SNA := $(BUILD_DIR)/angel5.sna

GEN := res/gen

SPRITE_SRC := $(shell find res/sprites/*.png)
SPRITE_BIN := $(addprefix res/gen/sprites/,$(notdir $(SPRITE_SRC:.png=.bin)))

LEVELS_SRC := $(shell find res/levels/*.tmx)
LEVELS_GEN := $(addprefix res/gen/levels/,$(notdir $(LEVELS_SRC:.tmx=.z80)))

FONTS_SRC := $(shell find res/fonts/*.yaml)

I18N_SRC := $(shell find res/i18n.yaml)

all: $(TAP)

$(GEN)/levels/%.z80: res/levels/%.tmx
	mkdir -p $(dir $@)
	zools encode-map $^ --encoding asm -o $@

$(GEN)/sprites/%.bin: res/sprites/%.png
	mkdir -p $(dir $@)
	zools encode-sprite -m --size 16x16 --invert $^ -e binary -d fifth-angel -o $@

$(GEN)/tiles.z80: res/tiles.tsx
	mkdir -p $(dir $@)
	zools encode-tiles $^ --encoding asm -o $@

$(GEN)/i18n.z80: $(I18N_SRC)
	mkdir -p $(dir $@)
	zools encode-text --langs en,ru $^ -o $@

$(GEN)/fonts.z80: $(FONTS_SRC)
	mkdir -p $(dir $@)
	zools encode-fonts $^ -o $@

$(TAP): loader.bas $(shell find . -name \*.z80) $(SPRITE_BIN) $(LEVELS_GEN) $(GEN)/tiles.z80 $(GEN)/fonts.z80 $(GEN)/i18n.z80
	mkdir -p $(BUILD_DIR)
	bas2tap -a loader.bas $@
	sjasmplus -DTAPNAME='"$@"' -DSNANAME='"$(SNA)"' --sym=symbols.txt --sld=build/angel5.sld main.z80

#$(FONTBIN): font.yaml
#	zxtools pack-font font.yaml -o $@

clean:
	rm -f $(TAP)

.PHONY: all clean install-tools
