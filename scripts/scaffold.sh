html=new_index.html
css=new_index.css
shifts=new_shifts.css

cat ../shared/tmpl.html > $html

clean_up() {
  rm $html
  rm $css
}

has_one_root=""

# Usage subdir(relative_to_img!) container w h
subdir() {
  echo $1 $2 $3 $4 $5
  echo "<div class=\"$(basename $1)\">" >> $html
  echo "<img src=\"$1.png\" alt=\"$(basename $1)\">" >> $html
  if [[ $5 != "" ]]; then
    echo "$2 {" >> $css
    if [[ $has_one_root != "" ]]; then
      echo "  display: none;" >> $css
    fi
    has_one_root=true
    echo "  position: relative;" >> $css
    echo "  width: $3px;" >> $css
    echo "  height: $4px;" >> $css
    echo "}" >> $css
    echo "$2 {" >> $shifts
    echo "  top: 200px;" >> $shifts
    echo "  left: 200px;" >> $shifts
    echo "}" >> $shifts
  fi
  if [ -d "$1" ]; then
    for sf in $1/*.png; do
      w=$(magick identify -format "%w" $sf)
      h=$(magick identify -format "%h" $sf)
      name=$(basename $sf | sed -E 's/.png$//')
      container="$2 .$name"
      #echo "<img src=\"$sf\" alt=\"$name\">" >> $html
      echo "$container {" >> $css
      echo "  position: absolute;" >> $css
      #echo "  background: url(\"$sf\");" >> $css
      echo "  width: $(( 100 * $w/$3. ))%;" >> $css
      echo "  height: $(( 100 * $h/$4. ))%;" >> $css
      echo "}" >> $css

      echo "$container {" >> $shifts
      echo "  top: 0px;" >> $shifts
      echo "  left: 0px;" >> $shifts
      echo "}" >> $shifts
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
if [ ! -f shifts.css ]; then
  mv $shifts shifts.css
else
  rm $shifts
fi
