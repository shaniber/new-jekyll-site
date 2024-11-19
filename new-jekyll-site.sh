#!/usr/bin/env bash

###
# Set up script for a new Jekyll site.
#
# This script will create a blank Jekyll site with my preferred layout.

## Set to 1 to enable debugging
DEBUG=${DEBUG-0}
if [ "${DEBUG}" = 1 ] ; then
  set -ea
fi

## Set to 1 to skip the warning dialog
YESIAMSHANE=${YESIAMSHANE-0}

# Current datestamp
ds=$(date +%Y%m%d%H%M%S)

## Bring in my silly little bash functions lib if it's there. 
if [ -d "${HOME}/code/bash-functions-library" ] ; then
    source "${HOME}/code/bash-functions-library/bash-functions-lib.sh"
else
    echo "You haven't installed the bash functions lib. You should do that."
fi

## Usage.
function util::usage() {
  util::print "\nUsage: new-jekyll-site.sh [site-name]\n"
  util::print "\nWhere site-name is an optional site name. If it's not specified, we'll ask for one.\n"
}

## Check for script tool requirements.
function util::confirm_requirements() {
  util::debug "Checking script requirements."
  ## Ensure that we're being executed by the original creator of this script.
  util::debug "Am I being run by someone who claims to be Shane? (${YESIAMSHANE})"
  if ! [ "${YESIAMSHANE}" = 1 ] ; then
    util::print "\nHey! Thanks for checking out this Jekyll site set up script.\n"
    util::print "Honestly, it's pretty opinionated, and sets things up in a way that's\n"
    util::print "probably not standard.\n\n"

    util::print "So before we go on, I want to confirm that you're either:\n\n"
    util::print "  a) The owner of the original repository (aka shane doucette) or\n"
    util::print "  b) Someone who read the README.md that says you use these at your own risk.\n\n"
    if util::confirm ; then
      util::print "Then let us begin.\n\n"
    else
      util::print "A wise choice. Bailing out!\n\n"
      exit 74
    fi
  fi

  ## Check for Jekyll installation.
  util::debug "Checking if Jekyll is installed"
  if ! command -v jekyll 2>&1 > /dev/null ; then
    util::error "Jekyll is not installed on your system. Bailing out!"
    exit 220
  else 
    util::debug "Jekyll is installed."
  fi

  ## Check for Bundler installation
  util::debug "Checking if Bundler is installed"
  if ! command -v bundle 2>&1 > /dev/null ; then
    util::error "Bundler is not installed on your system. Bailing out!"
    exit 221
  else 
    util::debug "Bundler is installed."
  fi
}

## -=-=-= MAIN SCRIPT =-=-=- ##

util::confirm_requirements

site_name=testing
site_type=jekyll

# Check for site name, as for one if not supplied on the command line.
# Check if this is a github pages site if not supplied on the command line.
# If the user isn't Shane, ask for name and email, otherwise set to the usual.

# Initialize a new site.
jekyll new ${site_name} --blank

# Change into the site's directory
cd ${site_name}

# Initialize bundler
bundle init

# Add either Jekyll or GitHub-Pages gems.
bundle add ${site_type}

# Create the src directory
mkdir src

# Move the site data into the src directory.
mv _data _drafts _includes _layouts _posts _sass assets index.md src/

# Add .gitkeep to all of the subdirectories in src.
for dir in _data _drafts _includes _layouts _posts _sass assets ; do
  touch "src/${dir}/.gitkeep"
done

# Update _config.yml with the new src directory.
cat <<EOF >> _config.yml
source: "src/"
EOF

# Update _config.yml with the site name.
sed -i.bak "s/title: \"\"/title: \"${site_name} site\"/g" _config.yml

# Create a .gitignore.
cat <<EOF > .gitignore
_site
_.sass-cache
Gemfile.lock
*.sw*
======
_site/
.sass-cache/
.jekyll-cache/
.jekyll-metadata
EOF

# Copy in the handy-dandy Makefile.
cp ../Makefile .

# Update the Makefile with the site name.
sed -i.bak "s/REPLACEME/${site_name}/g" Makefile

# Remove any backup files we created.
find . -name "*.bak" -exec rm {} \;

# Initialize a git repo, add the user and email to the config, and commit everything.
git init
git config set user.name "Shane Doucette"
git config set user.email "shaniber@gmail.com"
git add .
git commit -m "Initial commit" 

util::print "Done!"
