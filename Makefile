# Makefile
pdf:
	asciidoctor-pdf \
		-a scripts=cjk \
		-r asciidoctor-diagram \
		-a pdf-theme=theme/custom-theme.yml \
		-D dist \
		-o output.pdf \
		docs/index.adoc --trace

.PHONY: pdf