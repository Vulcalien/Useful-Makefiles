# Vulcalien's generic library Makefile
# version 0.1.0
#
# Supported systems:
# - Linux
# - Windows
#
# Linux to Windows cross-compilation also supported

# --- Config ---
OUT_FILENAME := libvulcalien

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

CPPFLAGS := -Iinclude -MMD -MP
CFLAGS   := -Wall -pedantic
LDFLAGS  := -Llib
LDLIBS   :=
# !-- Config ---

# --- Platform Dependent ---
UNI_OBJ_EXT := .o
UNI_OUT_EXT := .a

WIN_OBJ_EXT := .obj
WIN_OUT_EXT := .lib

ifeq ($(OS),Windows_NT)
	CC      := gcc
	OBJ_EXT := $(WIN_OBJ_EXT)
	OUT_EXT := $(WIN_OUT_EXT)

	RM      := del
	RMFLAGS := /Q
else
	CC      := gcc
	OBJ_EXT := $(UNI_OBJ_EXT)
	OUT_EXT := $(UNI_OUT_EXT)

	RM      := rm
	RMFLAGS := -rfv
endif
# !-- Platform Dependent ---

SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%$(OBJ_EXT))
OUT := $(BIN_DIR)/$(OUT_FILENAME)$(OUT_EXT)

.PHONY: all build linux-to-windows clean

all: build

linux-to-windows:
	make CC=x86_64-w64-mingw32-gcc OBJ_EXT=$(WIN_OBJ_EXT) OUT_EXT=$(WIN_OUT_EXT)

build: $(OUT)

$(OUT): $(OBJ) | $(BIN_DIR)
	$(AR) rcs $@ $^

$(OBJ_DIR)/%$(OBJ_EXT): $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir $@

clean:
	@$(RM) $(RMFLAGS) $(BIN_DIR) $(OBJ_DIR)

-include $(OBJ:$(OBJ_EXT)=.d)