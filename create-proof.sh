#!/bin/bash

input=logo.png
white=logo-white.png
black=logo-black.png

FONT_SIZES=(12 36 52 74)
LOGO_SIZES=(16 32 48 64)

#convert ${input} -background black -flatten ${black}
#convert ${input} -background white -flatten ${white}

for i in {0..3}
do
  # Return 1 so that a valid value of 0 does't quit the program with -e.
  let "border_size = (64 - ${LOGO_SIZES[$i]}) / 2" 1
  logo_size="${LOGO_SIZES[$i]}x${LOGO_SIZES[$i]}"
	convert ${input} -resize $logo_size \
      -gravity Center \
      -matte -bordercolor none -border $border_size \
      -set filename:output "%t-$i-$logo_size" \
      bin/%[filename:output].png

  for c in white black; do
    convert \
        -background transparent -gravity South \
        +antialias -font ZektonRg-Regular -pointsize ${FONT_SIZES[$i]} \
        -fill ${c} -stroke ${c} -strokewidth 0 label:ARR \
        -fill SlateGrey -stroke SlateGrey -strokewidth 2 label:AI \
        -fill ${c} -stroke ${c} -strokewidth 0 label:Y \
        -gravity Center +append \
        bin/arraiy-${c}-${i}-${logo_size}.png
    convert \
        -background transparent -gravity South \
        bin/logo-${i}-${logo_size}.png \
        bin/arraiy-${c}-${i}-${logo_size}.png \
        -gravity Center +append \
        bin/arraiy-${c}-logo-${i}-${logo_size}.png

    [[ ${c} == "white" ]] && oc="black" || oc="white"
    montage bin/arraiy-${c}-logo-*.png -tile 1x -geometry +0+0 -background ${oc} bin/montage-arraiy-${oc}.png
    montage ${input} bin/montage-arraiy-${oc}.png -tile x1 -geometry +0+0 -background ${oc} bin/montage-${oc}.png
    convert bin/montage-${oc}.png -bordercolor ${oc} -border 5 bin/final-montage-${oc}.png
  done
done

# T-Shirt
# -geometry +160+13
convert \
    templates/tee-shirt-black-594x294.png \
    bin/logo-2-48x48.png -geometry +355+90 -composite \
    -gravity northwest \
    bin/final-montage-shirt-black-logo.png

convert \
    templates/tee-shirt-black-594x294.png \
    bin/logo-2-48x48.png -geometry +355+90 -composite \
    bin/arraiy-white-1-32x32.png -geometry +320+150 -composite \
    -gravity northwest \
    bin/final-montage-shirt-black-arraiy-logo.png

convert \
    templates/tee-shirt-white-594x294.png \
    bin/logo-2-48x48.png -geometry +355+90 -composite \
    -gravity northwest \
    bin/final-montage-shirt-white-logo.png

convert \
    templates/tee-shirt-white-594x294.png \
    bin/logo-2-48x48.png -geometry +355+90 -composite \
    bin/arraiy-black-1-32x32.png -geometry +320+150 -composite \
    -gravity northwest \
    bin/final-montage-shirt-white-arraiy-logo.png

# Business Card
convert \
    templates/business-card-594x294.png \
    bin/arraiy-white-logo-2-48x48.png -geometry +80+20 -composite \
    +antialias -font ZektonRg-Regular -pointsize 24 \
    -background none -fill white -stroke white -strokewidth 0 \
    -gravity northeast \
    label:"ETHAN RUBLEE" -geometry +80+155 -composite \
    label:"CEO" -geometry +80+185 -composite \
    label:"RUBLEE@ARRAIY.COM" -geometry +80+215 -composite \
    label:"123.456.7890" -geometry +80+245 -composite \
    bin/final-montage-business-card.png

# Circuit Board
convert \
    templates/circuit-board-594x294.png \
    bin/logo-2-48x48.png -geometry +450+40 -composite \
    bin/arraiy-black-1-32x32.png -geometry +415+100 -composite \
    -gravity northwest \
    bin/final-montage-circuit-board.png

# Montage
montage \
    bin/final-montage-black.png \
    bin/final-montage-white.png \
    bin/final-montage-shirt-black-logo.png \
    bin/final-montage-shirt-white-logo.png \
    bin/final-montage-shirt-black-arraiy-logo.png \
    bin/final-montage-shirt-white-arraiy-logo.png \
    bin/final-montage-business-card.png \
    bin/final-montage-circuit-board.png \
    -tile 2x -geometry +0+0 \
    proof.png
