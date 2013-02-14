2nd GIG
================================================================================

Alternative GitHub IRC Gateway

[![Dependency Status](https://gemnasium.com/Tomohiro/2nd_gig.png)](https://gemnasium.com/Tomohiro/2nd_gig)
[![Stillmaintained](http://stillmaintained.com/Tomohiro/2nd_gig.png)](http://stillmaintained.com/Tomohiro/2nd_gig)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/Tomohiro/2nd_gig)


Requirements
-------------------------------------------------------------------------------

- Ruby 1.9.3 or later


Installation
--------------------------------------------------------------------------------

### Bundler

```sh
$ git clone git://github.com/Tomohiro/2nd_gig.git
$ cd 2nd_gig
$ bundle install --path vendor/bundle
```


Usage
--------------------------------------------------------------------------------

### Start service

```sh
$ bundle exec 2nd_gig
```


### Channels

Channel   | Description               | Optional
--------- | ------------------------- | ----
`#github` | GitHub Newsfeed timeline  | yes
`#public` | Public timeline           | no


LICENSE
--------------------------------------------------------------------------------

&copy; 2012 - 2013 Tomohiro TAIRA.
This project is licensed under the MIT license.
See LICENSE for details.
