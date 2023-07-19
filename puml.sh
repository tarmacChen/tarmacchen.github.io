#!/bin/sh
# converts all puml files to svg

BASEDIR=./puml
OUTDIR=./static/diagrams
mkdir -p $OUTDIR
rm $OUTDIR/*
for FILE in $BASEDIR/*.puml; do
  echo Converting $FILE..
  filename=$(basename "$FILE")
  base="${filename%.*}.png"
  cat $FILE | docker run --rm -i think/plantuml -png > $OUTDIR/$base
done
echo Done