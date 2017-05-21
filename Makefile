#!/usr/bin/make -f
#
# Makefile for NES game
# Copyright 2011-2014 Damian Yerrick
# (Edited by Pubby)
#
# Copying and distribution of this file, with or without
# modification, are permitted in any medium without royalty
# provided the copyright notice and this notice are preserved.
# This file is offered as-is, without any warranty.
#

# These are used in the title of the NES program
title := nes3d
version := 0.01

# Space-separated list of assembly language files that make up the
# PRG ROM.  If it gets too long for one line, you can add a backslash
# (the \ character) at the end of the line and continue on the next.
objlist := nrom init main globals palette line line_unrolled sprites


AS65 := ca65
LD65 := ld65
CFLAGS65 := --cpu 6502X
objdir := obj/nes
srcdir := src
imgdir := tilesets

EMU := fceux
DEBUG_EMU := wine fceux/fceux.exe

TEXT2DATA := wine tools/text2data.exe
NSF2DATA := wine tools/nsf2data.exe

.PHONY: all run clean

all: $(title).nes editor 3d

run: $(title).nes
	$(EMU) $<

debug: $(title).nes
	$(DEBUG_EMU) $<

clean:
	-rm $(objdir)/*.o $(objdir)/*.s $(objdir)/*.chr

# Rules for PRG ROM

objlistntsc := $(foreach o,$(objlist),$(objdir)/$(o).o)

map.txt $(title).nes: uxrom.cfg $(objlistntsc)
	$(LD65) -o $(title).nes -m map.txt -C $^

$(objdir)/%.o: $(srcdir)/%.s $(srcdir)/nes.inc $(srcdir)/globals.inc $(srcdir)/clip.inc
	$(AS65) $(CFLAGS65) $< -o $@

$(objdir)/%.o: $(objdir)/%.s
	$(AS65) $(CFLAGS65) $< -o $@

# Files that depend on .incbin'd files
$(objdir)/main.o: $(srcdir)/line.chr

# Rules for CHR ROM

$(title).chr: $(objdir)/bg.chr $(objdir)/sprites16.chr
	cat $^ > $@

$(objdir)/%.chr: $(imgdir)/%.png
	tools/pilbmp2nes.py $< $@

$(objdir)/%16.chr: $(imgdir)/%.png
	tools/pilbmp2nes.py -H 16 $< $@

# cpp
chrc: chrc.cpp
	 $(CXX) -std=c++14 $< -o $@

line: line.cpp
	 $(CXX) -std=c++14 $< -o $@

clip: clip.cpp
	 $(CXX) -std=c++14 $< -o $@

editor: editor.cpp
	 $(CXX) -std=c++14 $< -o $@ -lsfml-system -lsfml-graphics -lsfml-window

3d: 3d.cpp
	 $(CXX) -std=c++14 $< -o $@ -lsfml-system -lsfml-graphics -lsfml-window

$(srcdir)/line.chr: chrc
	./chrc $@

$(srcdir)/line_unrolled.s: line
	./line $@

$(srcdir)/clip.inc: clip
	./clip $@
