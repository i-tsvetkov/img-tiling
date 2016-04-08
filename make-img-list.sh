#!/bin/bash

echo -n "\$imgs = ["
identify -ping -format "{ src: \"%i\", w: %w, h: %h }" "$@" | sed 's/}{/},\n\t{/g'
echo "]"

