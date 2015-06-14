# lamernews

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

* lamernews installs several gems, creates a vhost, sets up passenger and deploys the lamernews ruby application.

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

  class {'passenger':
    passenger_version => '5.0.8',
    package_provider  => 'gem',
    passenger_package => 'passenger',
  }

  class {'lamernews':}

}
```

You may want to install the following puppet modules:
* puppet module install dwerder/redis
* puppet module install puppetlabs-vcsrepo
* puppet module install puppetlabs-passenger (Use this one until the CentOS7 bug has been fixed: https://github.com/ashish1099/puppetlabs-passenger.git)

And take the following steps:
yum install epel-release

You should then be able to run the agent and get a fully working lamernews set up for you.

## Limitations

This module was tested only with puppet 3.8, but it should work with any 3.x
puppet version. It was also only tested with CentOS 7, because centos 6
does not provide any ruby 1.9+ versions required by lamernews (unless using RVM),
while CentOS 7 provides 2.0.

## Development

This module is a proof of concept. You can contribute and fork, but since it's
licenced under GPLv3 you are not allowed to use it without attribution. If you
make changes you must publish them.

## TODO

- There is an rpm for hiredis in epel, if it's new enough that could be used instead of the ruby gem.
- -Fix the pull request to puppet passenger for CentOS 7 because currently passenger is broken on 7.- Use this version of passenger until it's been merged to the puppetlabs repo: https://github.com/ashish1099/puppetlabs-passenger.git

## NICE TO HAVEs

- Fore the lamernews repo and create releases, use release branches for checkout, remove the .git folder after the checkout.
- Make the gem versions parameterised and update the template and the gem installation to use the parameters. Or use hiera.

