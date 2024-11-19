## ========================================
##  Commands for the REPLACEME jekyll site.
## 

# Settings
BUNDLE=bundle
JEKYLL=${BUNDLE} exec jekyll
DST=_site

# Default target
.DEFAULT_GOAL := help


.PHONY: install build build-prod serve clean help

## install                : install dependencies and gems and such
install:
	${BUNDLE} install

## build                  : build the site.
build:
	${JEKYLL} build

## prod             : build the site for production
prod:
	JEKYLL_ENV=production ${JEKYLL} build

## serve                  : render the site and run a local server              
serve:
	${JEKYLL} serve

## clean                  : remove all cache and build files
clean:
	@rm -rf ${DST}
	@rm -rf .sass-cache
	@rm -rf Gemfile.lock
	@find . -name .DS_Store -exec rm {} \;

## help                   : show available make commands
help:
	@sed -n -e '/^##/s|^##[[:space:]]*||p' $(MAKEFILE_LIST)

##

