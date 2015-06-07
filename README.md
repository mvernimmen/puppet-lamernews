# lamernews
node lamernewsnode {

  class { 'redis::install':
    redis_version  => '2.8.19-2.el7',
    redis_package  => true,
  } ->
  redis::server {
    'instance1':
      redis_memory    => '1g',
      redis_ip        => '0.0.0.0',
      redis_port      => 10000,
      redis_mempolicy => 'allkeys-lru',
      redis_timeout   => 0,
      redis_nr_dbs    => 16,
      redis_loglevel  => 'notice',
      running         => true,
      enabled         => true
  }

  package {
     'gcc-c++':
      ensure => installed,
    ;
  }
  class {'passenger':
    passenger_version      => '5.0.8',
    passenger_provider     => 'gem',
    passenger_package      => 'passenger',
    gem_path               => '/usr/local/share/gems/gems/',
  }


#  class { 'apache':
#  }

  class {'lamernews':}


}


#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with/lamernews](#setup)
    * [What lamernews affects](#what-lamernews-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with lamernews](#beginning-with-lamernews)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This puppet module installs the https://github.com/antirez/lamernews webapp.

## Module Description

This module automates the installation of the ruby gems and the lamernews
installation.

You should use this module if you find yourself setting up machines by hand.
Currently it only installs and does not allow for any configuration. It is a
proof of concept only.

## Setup

### What lamernews affects

* lamernews installs several gems.

### Setup Requirements **OPTIONAL**

It assumes several things have already been installed and configured:
- redis (must listen on port 10000)
- apache
- passenger

### Beginning with lamernews

* Set up a puppet master
* Add this module as 'lamernews' module
* have a node definition that looks like this:
```
node lamernewsnode {

  class { 'redis::install':
    redis_version  => '2.8.19-2.el7',
    redis_package  => true,
  } ->
  redis::server {
    'instance1':
      redis_memory    => '1g',
      redis_ip        => '0.0.0.0',
      redis_port      => 10000,
      redis_mempolicy => 'allkeys-lru',
      redis_timeout   => 0,
      redis_nr_dbs    => 16,
      redis_loglevel  => 'notice',
      running         => true,
      enabled         => true
  }

  package {
     'gcc-c++':
      ensure => installed,
    ;
  }
  class {'passenger':
    passenger_version      => '5.0.8',
    passenger_provider     => 'gem',
    passenger_package      => 'passenger',
    gem_path               => '/usr/local/share/gems/gems/',
  }


#  class { 'apache':
#  }

  class {'lamernews':}


}
```




## Limitations

This module was tested only with puppet 3.8, but it should work with any 3.x
puppet version. It was also only tested with CentOS 7, because centos 6
does not provide any ruby 1.9+ versions required by lamernews, where CentOS 7
provides 2.0.

## Development

This module is a proof of concept. You can contribute and fork, but since it's
licenced under GPLv3 you are not allowed to use it without attribution. If you
make changes you must publish them.

## TODO

- There is an rpm for hiredis in epel, if it's new enough that could be used
instead of the ruby gem.
- Fix the pull request to puppet passenger for CentOS 7 because currently passenger is broken on 7.

