#!/bin/sh
list=`sed -n "/\[.*\]/p" list.conf | tr -d "[]"`
if test -d FTP; then
	echo "You've to remove FTP directory"
else
	mkdir FTP
	cp list.conf FTP
	for f in $list; do
		echo "make $f"
		rm -f "$f/*.pyc" "$f/*~"
		mkdir "FTP/$f"
		tar cfz "$f.tar.gz" "$f" --exclude="last-modif" --exclude="preview.png"
		mv "$f.tar.gz" "FTP/$f"
	done;
fi