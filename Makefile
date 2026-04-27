# Compiler settings
LATEXMK = latexmk
LATEXMK_FLAGS = -pdflua -synctex=1 -interaction=nonstopmode -shell-escape -file-line-error

# Default values (can be overridden from the command line)
# Usage: make build LAB=lab1
LAB ?= lab1

# Include the configuration file for the specific lab
# We expect a config.mk file inside the lab directory with HAUPTAUTOR, DOC, and VERSUCH settings.
-include $(LAB)/config.mk

# Fallback values if they are not defined in config.mk
HAUPTAUTOR ?= Nachname_Vorname
VERSUCH ?= $(LAB)
DOC ?= bericht.tex

# Derived PDF names
DOC_BASE = $(basename $(DOC))
ORIGINAL_PDF = $(DOC_BASE).pdf
TARGET_PDF = $(HAUPTAUTOR)_$(VERSUCH).pdf

.PHONY: all build clean

# "make" or "make build" will compile the specified LAB
all: build

build:
	@if [ "$(suffix $(DOC))" = ".typ" ]; then \
		echo "Compiling Typst document..."; \
		(cd $(LAB) && typst compile $(DOC) $(ORIGINAL_PDF)); \
	else \
		echo "Compiling LaTeX document..."; \
		(cd $(LAB) && $(LATEXMK) $(LATEXMK_FLAGS) $(DOC) && $(LATEXMK) -c $(DOC)); \
	fi
	@echo "Copying to target PDF format..."
	(cd $(LAB) && cp $(ORIGINAL_PDF) ../$(TARGET_PDF))
	@echo "Success! The compiled PDF is: $(LAB)/$(TARGET_PDF)"

# Clean everything including the generated PDFs for the specified lab
clean:
	@if [ -d $(LAB) ]; then \
		echo "Cleaning $(LAB)..."; \
		if [ "$(suffix $(DOC))" = ".tex" ]; then \
			(cd $(LAB) && $(LATEXMK) -C $(DOC)); \
		fi; \
		(cd $(LAB) && rm -rf _minted-*/ $(ORIGINAL_PDF) ../$(TARGET_PDF) *.synctex.gz); \
	fi
