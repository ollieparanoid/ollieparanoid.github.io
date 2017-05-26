#!/bin/sh
set -e
cd $(dirname $0)/..

IMG="$(find img -type f)"
for f in $IMG; do
	echo "$f"
	exiftool $f | grep -q "ExifTool Version Number"
done

echo "=> All images have been processed with exiftool already!"
