#!/bin/bash

input=logo.png
white=logo-white.png
black=logo-black.png

convert ${input} -background black -flatten ${black}
convert ${input} -background white -flatten ${white}

for f in ${input} ${white} ${black}; do
	convert ${f} \
			\( -clone 0 -resize 16x16 \) \
			\( -clone 0 -resize 32x32 \) \
			\( -clone 0 -resize 48x48 \) \
			\( -clone 0 -resize 64x64 \) \
      -set filename:output '%t-%p-%hx%w' \
      bin/%[filename:output].png
done

convert -background transparent -gravity South -fill white +antialias -font ZektonRg-Regular -pointsize 72 label:A -pointsize 48 label:RR -fill SlateGrey -stroke SlateGrey -strokewidth 2 label:AI -fill white -stroke white -strokewidth 0 label:Y -trim +append bin/arraiy-white.png

convert -background transparent -gravity South -fill black +antialias -font ZektonRg-Regular -pointsize 72 label:A -pointsize 48 label:RR -fill SlateGrey -stroke SlateGrey -strokewidth 2 label:AI -fill black -stroke black -strokewidth 0 label:Y -trim +append bin/arraiy-black.png

montage bin/logo-black*.png bin/arraiy-white.png -tile x1 -geometry +0+0 -background black bin/montage-black.png
convert bin/montage-black.png -bordercolor black -border 5 bin/montage-black.png

montage bin/logo-white*.png bin/arraiy-black.png -tile x1 -geometry +0+0 -background white bin/montage-white.png
convert bin/montage-white.png -bordercolor white -border 5 bin/montage-white.png

montage bin/montage-*.png -geometry +0+0 proof.png
