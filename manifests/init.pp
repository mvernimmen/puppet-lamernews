# == Class: lamernews
#
# This puppet module installs 
# https://github.com/antirez/lamernews
#
# It requires having a redis installation (should be handled by some other
# module.
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
    ['openssl']:
#     'openssl-devel']: # Devel is needed for the rubysl-openssl gem, but since this is also
                       # provided by the passenger module, we leave it out here.
      ensure => 'installed';
    # Needed to compile hiredis
    'gcc':
      ensure => 'installed';
  }

  # Wished for by lamernews:
  #gem 'sinatra','~> 1.4.2'
  #gem 'redis','~> 3.0.4'
  #gem 'hiredis', '~> 0.4.5'
  #gem 'json', '~> 1.8.2'
  #gem 'ruby-hmac', '~> 0.4.0'


  package {
    ['sinatra',
     'bundler',
     'hiredis',
     'ruby-hmac',
     'rubysl-net-smtp']:
      ensure   => 'installed',
      provider => 'gem',
    ;

    'rubysl-openssl':
      ensure   => '2.1.0', # Newer versions need rubinius
      provider => 'gem',
#      require  => Package['openssl-devel'],
    ;
  }
  package {
    'json':
      ensure => '1.8.2',
      provider => 'gem',
  }

  # Now thet everything is in place, install the lamernews app
  package { 'git':
      ensure => installed,
  }
    
  vcsrepo { "/var/www/html/":
      ensure   => latest,
      provider => git,
      require  => [ Package["git"] ],
      source   => "https://github.com/antirez/lamernews.git",
      revision => 'master',
  }->
  # overwrite the gemfile if needed
  file {
    'gemfile':
      ensure => present,
      path   => '/var/www/html/Gemfile',
      content => template('lamernews/gemfile.erb'),
  }


  #set up the vhost
  apache::vhost { "lamernews.blendle.com":
    docroot  => '/var/www/html',
    priority => '10',
  }
  concat::fragment { "rails_config_for_lamernews":
    target  => '10-lamernews.blendle.com.conf',
    order   => 11,
    content => '  RailsEnv development',
  }
}
