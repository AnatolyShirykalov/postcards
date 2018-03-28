sizes=sizes.csv
html=new_index.html
css=new_index.css

cat ../shared/tmpl.html > $html

# Usage subdir(relative_to_img!) container w h
subdir() {
  echo $1 $2 $3 $4
  echo "<div class=\"$(basename $1)\">" >> $html
  if [ -d "$1" ]; then
    for sf in $1/*.png; do
      w=$(magick identify -format "%w" $sf)
      h=$(magick identify -format "%h" $sf)
      name=$(basename $sf | sed -E 's/.png$//')
      container="$2 .$name"
      echo "$container {" >> $css
      echo "  background: url(\"$sf\");" >> $css
      echo "  width: $(( $w/$3. ))%;" >> $css
      echo "  height: $(( $h/$4. ))%;" >> $css
      echo "}" >> $css
      subdir $(echo $sf | sed -E 's/.png$//') $container $w $h
    done
  fi
  echo "</div>" >> $html
}

for f in img/*.png; do
  dirname=$(echo $f | sed -E 's/.png$//')
  w=$(magick identify -format "%w" $f)
  h=$(magick identify -format "%h" $f)
  subdir $dirname ".$(basename $dirname)" $w $h
done

echo "</body>\n</html>" >> $html

mv $html index.html
tidy -im index.html
mv $css index.css
