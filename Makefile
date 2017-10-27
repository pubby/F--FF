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
objlist := nrom init main globals palette line line_unrolled sprites player \
           multiply transform tokumaru menu gamepad delay flag


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

$(objdir)/%.o: $(srcdir)/%.s $(srcdir)/nes.inc $(srcdir)/globals.inc \
               $(srcdir)/clip.inc $(srcdir)/sin.inc $(srcdir)/recip.inc \
               $(srcdir)/foo.level.inc $(srcdir)/rad.inc \
               $(srcdir)/metasprites.inc $(srcdir)/flag_nt.inc \
               $(srcdir)/sin_scroll.inc $(srcdir)/flag_chr.inc
	$(AS65) $(CFLAGS65) $< -o $@

$(objdir)/%.o: $(objdir)/%.s
	$(AS65) $(CFLAGS65) $< -o $@

# Files that depend on .incbin'd files
$(objdir)/main.o: $(srcdir)/sprpack.cchr $(srcdir)/rad.cchr 

# Rules for CHR ROM

$(srcdir)/%16.chr: $(imgdir)/%.png
	python3 pilbmp2nes.py -H 16 $< $@

$(srcdir)/%.cchr: $(srcdir)/%.chr 
	./tokumaru -e $< $@

# cpp
chrc: chrc.cpp
	 $(CXX) -std=c++17 $< -o $@

line: line.cpp
	 $(CXX) -std=c++17 $< -o $@

clip: clip.cpp
	 $(CXX) -std=c++17 $< -o $@

editor: editor.cpp
	 $(CXX) -std=c++17 $< -o $@ -lsfml-system -lsfml-graphics -lsfml-window

3d: 3d.cpp
	 $(CXX) -std=c++17 $< -o $@ -lsfml-system -lsfml-graphics -lsfml-window

sin: sin.cpp
	 $(CXX) -std=c++17 $< -o $@

recip: recip.cpp
	 $(CXX) -std=c++17 $< -o $@

rad: rad.cpp
	 $(CXX) -std=c++17 $< -o $@

$(srcdir)/line.chr: chrc
	./chrc $@

$(srcdir)/sin.inc: sin
	./sin $@

$(srcdir)/line_unrolled.s: line
	./line $@

$(srcdir)/clip.inc: clip
	./clip $@

$(srcdir)/recip.inc: recip
	./recip $@

$(srcdir)/sprpack.chr: $(srcdir)/rad316.chr $(srcdir)/menutext16.chr $(srcdir)/ship16.chr $(srcdir)/ui16.chr
	cat $^ > $@

$(srcdir)/rad.inc: rad $(srcdir)/rad16.chr $(srcdir)/rad216.chr  $(srcdir)/rad316.chr
	./rad $(srcdir)/rad16.chr $(srcdir)/rad216.chr $(srcdir)/rad316.chr $(srcdir)/rad.chr $@

tokumaru: tokumaru.cc
	g++ -std=c++17 -o "$@" "$<" $(CXXFLAGS)

metaspritegen: metaspritegen.cpp
	 $(CXX) -std=c++17 $< -o $@

$(srcdir)/metasprites.inc: metaspritegen
	./metaspritegen $@

