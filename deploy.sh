#!/bin/bash
set -e # exit with nonzero exit code if anything fails

echo "? :" `env | grep GH_TOKEN`

echo "method: git" > _deploy.yml
echo "git_url: https://${GH_TOKEN}@${GH_REF}" >> _deploy.yml

echo 'Deploying through octopress...'
octopress deploy -t > /dev/null 2>&1
