#!/bin/bash
set -e # exit with nonzero exit code if anything fails

echo "method: git" > _deploy.yml
echo "git_url: https://${GH_TOKEN}@${GH_REF}" >> _deploy.yml

echo 'Deploying through octopress...'
octopress deploy --config _prod.yml > /dev/null 2>&1
echo 'Done'
