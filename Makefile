rwildcard		=	$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

ASM = rgbasm
LINK = rgblink
FIX = rgbfix

INCDIR = include
BUILDDIR = build
SYMDIR = $(BUILDDIR)\sym
OBJDIR = $(BUILDDIR)\obj

#Change the following lines
ROM_NAME = game-of-life
ASM_SOURCES := $(call rwildcard, src/, *.asm)
OBJ_FILES := $(addprefix $(OBJDIR)/, $(ASM_SOURCES:src/%.asm=%.o))
FIX_FLAGS := -v -p 0

all: $(ROM_NAME)

$(ROM_NAME): $(OBJ_FILES)
	$(LINK) -o $(BUILDDIR)\$@.gb -n $(SYMDIR)\$@.sym $(OBJ_FILES)
	$(FIX) $(FIX_FLAGS) $(BUILDDIR)\$@.gb

$(OBJDIR)/%.o : src/%.asm
	$(ASM) -i $(INCDIR)/ -o $@ $<

clean:
	del $(BUILDDIR)\$(ROM_NAME).gb $(SYMDIR)\$(ROM_NAME).sym $(OBJECTS)

print-%  : ; @echo $* = $($*)
