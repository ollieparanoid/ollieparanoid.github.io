WEBROOT := https://ollieparanoid.github.io
PAGES := $(shell find -L page -name '*.html')
PAGES := $(patsubst %.html,../%/index.html,$(PAGES))
POSTS := $(shell find -L post -name '*.html')
POSTS := $(patsubst %.html,../%/index.html,$(POSTS))
TITLE_SUFFIX := &\#9851;
SED_REMOVE_HTML_TAGS := sed -e 's/<[^>]*>//g'
SED_REMOVE_AND :=  sed -e 's/\&nbsp;/ /g'


# Count all words in file $1 (without HTML tags) and divide through
WORDS_READ_PER_MINUTE := 200
define reading_time
	$(shell echo $(shell $(SED_REMOVE_HTML_TAGS) $(1) \
		| wc -w) / $(WORDS_READ_PER_MINUTE) | bc) min
endef

all: ../index.html ../feed.xml $(PAGES) $(POSTS)

# Index page (variable: @WEBROOT@)
../index.html: $(POSTS) template/* Makefile
	$(info HTML $@)
	@ cat template/head.html > $@.tmp
	@ echo '<title>Home $(TITLE_SUFFIX)</title>' >> $@.tmp
	@ cat template/header.html >> $@.tmp
	@ echo "<div class=\"post\">" >> $@.tmp
	@ cat template/home.html >> $@.tmp
	@ for f in $(POSTS); do \
		url=$(WEBROOT)/$${f/.html//}; \
		grep '<span class="date">' $$f >> $@.tmp; \
		grep '<span class="ert">' $$f >> $@.tmp; \
		grep '<a class="h1" href=' $$f |\
			sed 's/"h1"/"index_post"/g' >> $@.tmp; \
	done
	@ echo "</div>" >> $@.tmp
	@ cat template/footer.html >> $@.tmp
	@ sed -i 's~@WEBROOT@~$(WEBROOT)~g' $@.tmp
	@ mv $@.tmp $@

# Posts and pages (variables: @WEBROOT@, @SELF@, @ERT@)
../%/index.html: %.html template/* Makefile
	$(info HTML $@)
	@ mkdir -p $(dir $@)
	@ cat template/head.html > $@.tmp
	@ echo '<title>' >> $@.tmp
	@ grep '<a class="h1" href="@SELF@"' $< | $(SED_REMOVE_HTML_TAGS) \
		>> $@.tmp
	@ echo ' $(TITLE_SUFFIX)</title>' >> $@.tmp
	@ cat template/header.html >> $@.tmp
	@ cat $< template/footer.html >> $@.tmp
	@ sed -i 's~@WEBROOT@~$(WEBROOT)~g' $@.tmp
	@ sed -i 's~@SELF@~$(WEBROOT)/$(patsubst ../%index.html,%,$@)~g' \
		$@.tmp
	@ sed -i 's~@ERT@~$(call reading_time,$<)~g' $@.tmp
	@ mv $@.tmp $@

# RSS feed
../feed.xml: template/* Makefile $(POSTS)
	$(info RSS $@)
	@ echo '<?xml version="1.0" encoding="utf-8" standalone="yes" ?>' > $@.tmp
	@ echo '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">' >> $@.tmp
	@ echo '<channel>' >> $@.tmp
	@ echo '<atom:link href="https://ollieparanoid.github.io/feed.xml" rel="self" type="application/rss+xml" />' >> $@.tmp
	@ echo '<title>ollieparanoid</title>' >> $@.tmp
	@ echo '<description>ollieparanoid</description>' >> $@.tmp
	@ echo '<link>https://ollieparanoid.github.io/</link>' >> $@.tmp
	@ for f in $(POSTS); do \
		echo '<item>' >> $@.tmp; \
		\
		echo '<title>' >> $@.tmp; \
		grep '<a class="h1" href="' $$f | $(SED_REMOVE_HTML_TAGS) \
			| $(SED_REMOVE_AND) >> $@.tmp; \
		echo '</title>' >> $@.tmp; \
		\
		url="$${f/\/index.html//}"; \
		url="$(WEBROOT)$${url/..\///}"; \
		echo "<link>$$url</link>" >> $@.tmp; \
		echo "<guid>$$url</guid>" >> $@.tmp; \
		\
		echo '</item>' >> $@.tmp; \
	done
	@ echo '</channel>' >> $@.tmp
	@ echo '</rss>' >> $@.tmp
	@ mv $@.tmp $@

clean:
	$(info CLEAN)
	@ rm -r ../index.html ../*.tmp ../feed.xml ../page ../post \
		2> /dev/null || true

.PHONY: clean all

