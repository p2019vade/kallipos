#!/bin/bash

FONT="Noto Sans"
HTML_DIR="html"
TEXT_DIR="text"

echo "Creating the HTML directory if it does not exist..."
mkdir -p $HTML_DIR

echo "Assembling all the source files..."
pandoc $TEXT_DIR/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > $HTML_DIR/pre.html
pandoc $TEXT_DIR/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > $HTML_DIR/intro.html

for filename in $TEXT_DIR/ch*.txt; do
  if [ -e "$filename" ]; then
    basefilename=$(basename "$filename" .txt)
    pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=filter.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=$META_FILE --top-level-division=chapter --citeproc --bibliography=$BIB_DIR/"$basefilename.bib" --reference-location=section --wrap=none --to html > $HTML_DIR/"$basefilename.html"
  fi
done

pandoc $TEXT_DIR/web.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > $HTML_DIR/web.html
pandoc $TEXT_DIR/bio.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > $HTML_DIR/bio.html

for filename in $TEXT_DIR/apx*.txt; do
  if [ -e "$filename" ]; then
    basefilename=$(basename "$filename" .txt)
    pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=$META_FILE --top-level-division=chapter --citeproc --bibliography=$BIB_DIR/"$basefilename.bib" --reference-location=section --to html > $HTML_DIR/"$basefilename.html"
  fi
done

echo "Merging all HTML files... "
pandoc --quiet -s $HTML_DIR/*.html -o $HTML_DIR/index.html --metadata title="Interaction Programming"