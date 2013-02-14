2nd GIG
================================================================================

Alternative GitHub IRC Gateway

[![Dependency Status](https://gemnasium.com/Tomohiro/2nd_gig.png)](https://gemnasium.com/Tomohiro/2nd_gig)
[![Stillmaintained](http://stillmaintained.com/Tomohiro/2nd_gig.png)](http://stillmaintained.com/Tomohiro/2nd_gig)
[![Code Climate](https://codeclimate.com/github/Tomohiro/2nd_gig.png)](https://codeclimate.com/github/Tomohiro/2nd_gig)

![2nd GIG screenshot](screenshot.png)

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

### Connect the 2nd GIG

1. Launch a IRC client.(Limechat, irssi, weechat...)
2. Connect the server(option is below)
3. Join optional channel if you wanted.

#### Server options

option    | value
--------- | -----
port      | 16705
Real name | GitHub username
Password  | GitHub news feed token


### Channels

Channel    | Description                    | Auto join
---------- | ------------------------------ | ---------
`#github`  | News feed timeline             | yes
`#public`  | Public timeline                | no
`#private` | Private activity feed timeline | no


LICENSE
--------------------------------------------------------------------------------

&copy; 2012 - 2013 Tomohiro TAIRA.
This project is licensed under the MIT license.
See LICENSE for details.
