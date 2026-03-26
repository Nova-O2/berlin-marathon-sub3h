# Research Project — Manuscript Build
# Usage: make all | make docx | make tables | make title | make cover | make figures | make clean

PANDOC = pandoc
SRC = manuscript/manuscript.md
META = manuscript/metadata.yaml
BIB = manuscript/references.bib
JOURNAL_TEMPLATE = manuscript/templates/default.docx
EXPORT_DIR = manuscript/exports
TABLE_DIR = manuscript/tables
TABLE_SRCS = $(wildcard $(TABLE_DIR)/Table*.md)
TABLE_DOCX = $(patsubst $(TABLE_DIR)/%.md,$(EXPORT_DIR)/%.docx,$(TABLE_SRCS))
FIGURE_SRCS = $(wildcard figures/*.tiff)
FIGURE_COPY = $(patsubst figures/%,$(EXPORT_DIR)/%,$(FIGURE_SRCS))

REF_DOC = $(if $(wildcard $(JOURNAL_TEMPLATE)),--reference-doc=$(JOURNAL_TEMPLATE),)

PANDOC_OPTS = --metadata-file=$(META) \
              --citeproc \
              --bibliography=$(BIB) \
              --wrap=none

.PHONY: all docx pdf tables title cover figures clean

all: title cover docx tables figures

docx: $(EXPORT_DIR)/manuscript.docx

pdf: $(EXPORT_DIR)/manuscript.pdf

tables: $(TABLE_DOCX)

title: $(EXPORT_DIR)/title_page.docx

cover: $(EXPORT_DIR)/cover_letter.docx

figures: $(FIGURE_COPY)

# Title page (first page with authors/affiliations)
$(EXPORT_DIR)/title_page.docx: manuscript/title_page.md
	@mkdir -p $(EXPORT_DIR)
	$(PANDOC) $< $(REF_DOC) -o $@
	@echo "→ $@"

# Cover letter (submission letter to editor)
$(EXPORT_DIR)/cover_letter.docx: manuscript/cover_letter.md
	@mkdir -p $(EXPORT_DIR)
	$(PANDOC) $< $(REF_DOC) -o $@
	@echo "→ $@"

# Manuscript body
$(EXPORT_DIR)/manuscript.docx: $(SRC) $(META) $(BIB)
	@mkdir -p $(EXPORT_DIR)
	$(PANDOC) $(SRC) $(PANDOC_OPTS) $(REF_DOC) -o $@
	@echo "→ $@"

# Manuscript PDF
$(EXPORT_DIR)/manuscript.pdf: $(SRC) $(META) $(BIB)
	@mkdir -p $(EXPORT_DIR)
	$(PANDOC) $(SRC) $(PANDOC_OPTS) \
		-V geometry:margin=2.5cm \
		-V fontsize=12pt \
		-V linestretch=2 \
		-o $@
	@echo "→ $@"

# Individual table .docx
$(EXPORT_DIR)/%.docx: $(TABLE_DIR)/%.md
	@mkdir -p $(EXPORT_DIR)
	$(PANDOC) $< $(REF_DOC) -o $@
	@echo "→ $@"

# Copy figures to exports
$(EXPORT_DIR)/%.tiff: figures/%.tiff
	@mkdir -p $(EXPORT_DIR)
	@cp $< $@
	@echo "→ $@"

clean:
	rm -rf $(EXPORT_DIR)/*.docx $(EXPORT_DIR)/*.pdf $(EXPORT_DIR)/*.tiff
