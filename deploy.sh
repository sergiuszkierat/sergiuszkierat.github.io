#!/bin/bash
set -e # exit with nonzero exit code if anything fails

echo "GH_TOKEN : ${GH_TOKEN}"
echo "? :" `env | grep GH_TOKEN`

echo 'Octopress...'
octopress --help
#octopress deploy
