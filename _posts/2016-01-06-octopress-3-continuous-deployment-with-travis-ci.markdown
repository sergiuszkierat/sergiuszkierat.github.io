---
layout: post
title: "Octopress 3: Continuous Deployment With Travis Ci"
date: 2016-01-06T23:13:27+01:00
---

*Inspired by [Write in Octopress 3.0 and publish posts via travis-ci](http://blog.goofansu.com/2015/06/25/test-travis.html)*

***

You could use `GITHUB_TOKEN` in a safe way. Travis gives you this possibility through [encryption keys](https://docs.travis-ci.com/user/encryption-keys/) feature.

Prerequisites
=============
* [Octopress 3](https://github.com/octopress/octopress)
* [Travis CI](https://travis-ci.org/)

Encrypted credentials
=====================
We will generate a GitHub's [personal access token](https://github.com/settings/tokens) and we will encrypt it.

* Generate a token by:
  * Go to [Tokens](https://github.com/settings/tokens)
  * Click `Generate new token` button
  * Write a descriptive `Token description`
  * Select only `public_repo` scope
  * Click `Generate token`
  * Copy the token to your clipboard
* [Install the Travis client](https://github.com/travis-ci/travis.rb#installation)
* Encrypt generated token
{% highlight bash %}
$ travis encrypt GH_TOKEN=<secret token here>
{% endhighlight %}
* Put encrypted token into your `.travis.yml` and verify it
{% highlight bash %}
$ travis lint .travis.yml
#=> prints 'Hooray, .travis.yml looks valid :)' to STDOUT.
{% endhighlight %}

```yaml title:".travis.yml"
language: ruby

rvm:
  - 2.1

before_script:
  - git config --global user.email "noreply@travis-ci.org"
  - git config --global user.name "Travis CI"

script:
  - bundle exec jekyll build
  - bundle exec htmlproof ./_site --only-4xx --check-html --disable-external --allow-hash-href

after_success:
  - ./deploy.sh

env:
  global:
  - NOKOGIRI_USE_SYSTEM_LIBRARIES=true
  - GH_REF=github.com/sergiuszkierat/sergiuszkierat.github.io
  - secure=qgIjKsyNwqe5bilvVOnrTQGV5GEAKIt34eaYtHiEyWD6iuu1hw4AZPzakmLKvk0rFEFIXdo5Cq/TO2d/0m+hX6odSDTbmWoCdRLnLYXitPXXAI+pQsgsxcuCEwLyIY/6bMPjJthRySuoQeVF+RbFE92u0P6qNCVqugFH5voPOnoo0EZtAyKRNyZimuXITSmy19irtje+TXiKC4jZg82hMjZDAzPZ8Sh/zWJv/iuqxOI3B5ThSidGGJA54iiJVn1yPagWPdwQ4IBGonVHY2f5ZV8/7SEhfWxvOrQeCIt/r1oJKWIOhAQP7y5ilHz7FLkwQYysCuksOPzMzgDlf5fcWUqsdPxyxrqUQJ9Dmfl2Tr1aTDM2BR+KE6w4Y1qrM5ZhhruuzLfztqLEBfHMCcDHRWtp3a9l9i+h3uS27hu5KZyWKyrxGchatpDIN/C3e98xlVkV5YP3e4EIe1Ij2/02RGFMLunkjIYaVRZnrDAiFtnnBqLXcCb+UGSlFWN5WtPoBbwin1Ih1ZiO/ZqSDTYxurzsToaLH5v3Z73pSbKm7Qzo9XiulPhti5qzx0aTkvZi69o3KyVcK6a8p0mpPKBNqpDCK9UjpjMpHQ7K/WL1ze6M9w74nUEiMFp4rygJDPAeoKuf0CJ0dX6DIKGLKN5HBfa3gnL1ILx3pqKEXk88pGI=

branches:
  only:
    - source
```

Deploying site
===========
To deploy my Octopress blog, I use a [deploy](https://github.com/octopress/octopress#deploying-your-site) subcommand and generate `_deploy.yml` on the fly.

```bash title:"deploy.sh"
#!/bin/bash
set -e # exit with nonzero exit code if anything fails

echo 'Creating _deploy.xml...'
echo "method: git" > _deploy.yml
echo "git_url: https://${GH_TOKEN}@${GH_REF}" >> _deploy.yml

echo 'Deploying through octopress...'
octopress deploy > /dev/null 2>&1
echo 'Done'
```

Summary
=============
This post is published securely via [Travis CI](https://travis-ci.org/sergiuszkierat/sergiuszkierat.github.io).
