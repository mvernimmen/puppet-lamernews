# == Class: lamernews
#
# This puppet module installs 
# https://github.com/antirez/lamernews
#
# === Parameters
#
# None so far
#
# === Examples
#
#  class { 'lamernews':
#  }
#
# === Authors
#
# Max Vernimmen <m.vernimmen@gmail.com>
#
# === Copyright
#
# Copyright 2015 M. Vernimmen
#

class lamernews {

  package {
    # Not really required according to antirzet, but should make it go quicker
    ['openssl',
     'openssl-devel']: # Devel is needed for the rubysl-openssl gem.
      ensure => 'installed';
    # Needed to compile hiredis
    'gcc':
      ensure => 'installed';
  }


  package {
    ['sinatra',
     'hiredis',
     'json',
     'ruby-hmac',
     'rubysl-net-smtp']:
      ensure   => 'installed',
      provider => 'gem',
    ;


    'rubysl-openssl':
      ensure   => '2.1.0', # Newer versions need rubinius
      provider => 'gem',
      require  => Package['openssl-devel'],
    ;
  }


}
