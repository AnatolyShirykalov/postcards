html=new_index.html
css=new_index.css
shifts=new_shifts.css
rotations=new_rotations.css
animations=new_animations.css

cat ../shared/tmpl.html > $html

clean_up() {
  rm $html
  rm $css
  rm $shifts
  rm $rotations
}


base_shifts() {
  echo "$container {" >> $shifts
  echo "  top: 0px;" >> $shifts
  echo "  left: 0px;" >> $shifts
  echo "}" >> $shifts
}
root_shifts() {
  echo "$1 {" >> $shifts
  echo "  top: 200px;" >> $shifts
  echo "  left: 200px;" >> $shifts
  echo "}" >> $shifts
}
root_css() {
  echo "$1 {" >> $css
  echo "  position: relative;" >> $css
  echo "  width: $2px;" >> $css
  echo "  height: $3px;" >> $css
  echo "}" >> $css
}

base_css() {
  echo "$1 {" >> $css
  echo "  position: absolute;" >> $css
  echo "  width: $2%;" >> $css
  echo "  height: $3%;" >> $css
  echo "}" >> $css
}

rotations() {
  echo "$1 {" >> $rotations
  echo "  transform-origin: 0% 0%;" >> $rotations
  echo "}" >> $rotations
}

animations_root() {
  echo "$1 div {" >> $animations
  echo "  animation-duration: 2s;" >> $animations
  echo "  animation-fill-mode: both;" >> $animations
  echo "  animation-iteration-count: infinite;" >> $animations
  echo "  animation-direction: alternate;" >> $animations
  echo "}" >> $animations
}

animations_base(){
  a_name=$(echo $1 | sed -E 's/[.]//g' | sed -E 's/ +/_/g')
  echo "@keyframes $a_name {" >> $animations
  echo "  from {transform: rotate(20deg);}" >> $animations
  echo "  to {transform: rotate(-20deg);}" >> $animations
  echo "}" >> $animations
  echo "$1 {animation-name: $a_name;}" >> $animations
}

# Usage subdir(relative_to_img!) container w h
subdir() {
  echo $1 $2 $3 $4 $5
  echo "<div class=\"$(basename $1)\">" >> $html
  echo "<img src=\"$1.png\" alt=\"$(basename $1)\">" >> $html
  if [[ $5 != "" ]]; then
    root_css $2 $3 $4
    root_shifts $2
    animations_root $2
  fi
  if [ -d "$1" ]; then
    for sf in $1/*.png; do
      w=$(magick identify -format "%w" $sf)
      h=$(magick identify -format "%h" $sf)
      name=$(basename $sf | sed -E 's/.png$//')
      container="$2 .$name"
      base_css $container $(( 100 * $w/$3. )) $(( 100 * $h/$4. ))
      base_shifts $container
      animations_base $container
      rotations $container

      subdir $(echo $sf | sed -E 's/.png$//') $container $w $h
    done
  fi
  echo "</div>" >> $html
}



for f in img/*.png; do
  dirname=$(echo $f | sed -E 's/.png$//')
  w=$(magick identify -format "%w" $f)
  h=$(magick identify -format "%h" $f)
  subdir $dirname ".$(basename $dirname)" $w $h true
done

echo "</body>\n</html>" >> $html

tidy -im $html
echo '{"warnings":["no_warnings"]}' > .csslintrc
css_errors=$(csslint new_index.css --quiet)
if [[ $css_errors != "" ]]; then
  echo $css_errors
  clean_up
  exit 1
fi
mv $css index.css
mv $html index.html

mv_if_not_exist() {
  if [ ! -f $2 ]; then
    mv $1 $2
  else
    rm $1
  fi
}


mv_if_not_exist $shifts shifts.css
mv_if_not_exist $rotations rotations.css
mv_if_not_exist $animations animations.css
