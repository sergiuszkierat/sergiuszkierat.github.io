#!/bin/bash
# set -e # exit with nonzero exit code if anything fails

function clean {
  echo 'Cleaning...'
  bundle exec jekyll clean
}

function serve {
  echo "Runing..."
  bundle exec jekyll s --config _config.yml,_config_dev.yml --watch $1
}

# Script
if [ "$#" -eq 1 ] && [ $1 = "-d" ]; then
  clean
  serve "--drafts"
  # bundle exec jekyll s --config _config.yml,_config_dev.yml --watch --drafts
elif [ "$#" -eq 0 ]; then
  clean
  serve
  # bundle exec jekyll s --config _config.yml,_config_dev.yml --watch
else
  printf "Usage:\n"
  printf "  run [options]\n"
  printf "Options:\n"
  printf "\t-d,     Show drafts"
fi
