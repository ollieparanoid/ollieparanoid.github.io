#!/bin/sh
set -e
cd $(dirname $0)/..

HTML="index.html"
HTML=""$HTML" $(find post -name '*.html')"
HTML=""$HTML" $(find page -name '*.html')"

for f in $HTML; do
	echo "$f"

	# Verify HTML5
	tidy -q "$f" > /dev/null

	# Check for HTML comments and empty links
	for pattern in "<!--" 'href="#"'; do
		if grep -q "$pattern" "$f"; then
			grep -n "$pattern" "$f"
			exit 1
		fi
	done
done

echo "=> HTML validation passed!"

