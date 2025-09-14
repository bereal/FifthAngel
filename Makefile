BUILD_DIR := build
TAP_RU := $(BUILD_DIR)/angel5_ru.tap
TAP_EN := $(BUILD_DIR)/angel5_en.tap
LOCALE := ru
TAP := $(BUILD_DIR)/angel5_$(LOCALE).tap
SNA := $(BUILD_DIR)/angel5.sna
TMP := $(BUILD_DIR)/tmp
GEN := res/gen
I18N := $(GEN)/i18n_$(LOCALE).z80

SPRITE_SRC := $(shell find res/sprites/*.png)
SPRITE_BIN := $(addprefix res/gen/sprites/,$(notdir $(SPRITE_SRC:.png=.bin)))

ICON_SRC := $(shell find res/icons/*.png)
ICON_BIN := $(addprefix res/gen/icons/,$(notdir $(ICON_SRC:.png=.bin)))

LEVELS_SRC := $(shell find res/levels/*.tmx)
LEVELS_BIN := $(addprefix res/gen/levels/,$(notdir $(LEVELS_SRC:.tmx=.zx0)))

FONTS_SRC := $(shell find res/fonts/*.yaml)

I18N_SRC := $(shell find res/i18n.yaml)

all: $(TAP)

$(GEN)/levels/%.zx0: res/levels/%.tmx
	mkdir -p $(dir $@)
	zools encode-map $^ --encoding binary --zx0 -o $@

$(GEN)/sprites/%.bin: res/sprites/%.png
	mkdir -p $(dir $@)
	zools encode-sprite -m --size 16x16 --invert $^ -e binary -d fifth-angel -o $@

$(GEN)/icons/%.bin: res/icons/%.png
	mkdir -p $(dir $@)
	zools encode-sprite --size 16x16 --invert $^ -e binary -d rows -o $@

$(GEN)/tiles.z80: res/tiles.tsx
	mkdir -p $(dir $@)
	zools encode-tiles $^ --encoding asm -o $@

$(I18N): $(I18N_SRC)
	mkdir -p $(dir $@)
	zools encode-text --langs $(LOCALE) --mono $^ -o $@

$(GEN)/fonts.z80: $(FONTS_SRC)
	mkdir -p $(dir $@)
	zools encode-fonts $^ -o $@

$(TAP): loader.bas $(shell find . -name \*.z80) $(SPRITE_BIN) $(LEVELS_BIN) $(GEN)/tiles.z80 $(GEN)/fonts.z80 $(I18N) $(ICON_BIN)
	mkdir -p $(BUILD_DIR)
	bas2tap -a loader.bas $@
	sjasmplus -DTAPNAME='"$@"' -DSNANAME='"$(SNA)"' -DI18N='"$(I18N)"' --sym=symbols.txt --sld=build/angel5.sld main.z80

#$(FONTBIN): font.yaml
#	zxtools pack-font font.yaml -o $@

clean:
	rm -f build/*

.PHONY: all clean
