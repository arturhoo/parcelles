# Parcelles

Utilizes packer to quickly provision VM images for local testing through Virtualbox, QEMU, or Amazon EC2 AMIs for deployment and staging environments.

Requires packer >= 0.3.9 for Amazon block device mapping support and Puppet masterless provisioning.
Requires packer >= 0.5.0 for QEMU provisioning.

To generate an image simply run packer specifying the builder and the packer template file. We've included a example template to get the ball rolling.

```bash
packer build --only=virtualbox example.json 
```

or

```bash
packer build --only=qemu example.json 
```

or

```bash
packer build --only=amazon-ebs example.json 
```

To authenticate your credentials on Amazon you need the following environment variables defined

```bash
export AWS_ACCESS_KEY="..."
export AWS_SECRET_KEY="..."
```

# Using Parcelles as a Submodule

If you wish to keep a project's machine configuration within the same repository as the application code, a simple solution is to pull all the scripts and Puppet manifests from `parcelles` as a submodule in your project but keep both a private `app.json` packer template describing specific machine configuration details (disks, region, base AMI, etc) and a `site.pp` in your project root. 

## Custom `app.json`

**You can base your `app.json` on the included `example.json`, but remember packer uses relative file paths. Change the following to properly load the included modules:**

* `['builders'][0]['http_directory']` from `'http'` to `'parcelles/http'`
* `['provisioners'][0]['source']` from `'puppet/hieradata'` to `$YOUR_PROJECTS_HIERADATA_DIR`
* `['provisioners'][1]['override'][*]['scripts']` from `'scripts/*'` to `'parcelles/scripts/*'`
* `['provisioners'][2]['manifest_file']` from `'puppet/site.pp'` to `$YOUR_PROJECTS_SITE_MANIFEST_FILE`
* `['provisioners'][2]['hiera_config_test']` from `'puppet/hiera.yaml'` to `'parcelles/puppet/hiera.yaml'`
* `['provisioners'][2]['module_paths']` from `['puppet/modules']` to `['parcelles/puppet/modules']`


## Custom `site.pp`

This is a standard Puppet manifest and supports any valid Puppet syntax from 3.1 and up. See the each [module](#puppet-modules)'s individual configuration for additional info.

```puppet
node default {
  Exec {
    path => $::path,
  }

  include base
  include nginx
  include mysql
  include php

  package { 'redis-server':
    ensure => latest,
  }
}
```

Validade your configuration with:

```bash
packer validate app.json
```

# Scripts

Most of our infrastructure is based on Ubuntu Server and the provisioning scripts and manifests assume it as the base OS (`apt`, `upstart`, etc...). The goal is to get the machine to bootstrap Puppet, sudo permissions, and disk state. All other things are then handled by Puppet.

## non-aws.sh

*virtualbox only*

Grants the `ubuntu` user password-less `sudo` like the default Amazon AMI for Ubuntu Server.

## partition.sh

*amazon-ebs only*

We follow a block device naming convention with for our EBS-backed images and always create a primary partition on the block device (`/dev/xvdf` -> `/dev/xvdf1`) instead of formatting it directly. This allows us to grow the EBS disk independent of the partitions contained:

* `/dev/xvdf` stores the main database datadir (mongo/mysql). Formated to `xfs` to allow simple backups through ec2-consistent-snapshot.
* `/dev/xvdg` the static data served by the webserver. Formated to `ext4`.

## puppet.sh

Installs the latest stable Puppet from the main Puppet Labs repository.

# Puppet Modules

## base

Our opinionated touches of what should be present with every Ubuntu.

* Tracking of bash history with timestamps
* `vim` as the default editor.
* Preconfigured `unattended-upgrades` for upgrades.
* Sane `tmux` defaults.
* Disable password login through `sshd`, enable agent forwarding and add authorized keys specified by [hiera](http://docs.puppetlabs.com/hiera/1/). **Don't forget to create a folder hieradata with a file common.yaml specifying keys in the following format or you may be locked out of the final generated image.**
* `ntp` clock sync.
* Other useful utilities such as `git`, `curl`, `htop`, `tree`...
* Full `dist-upgrade` of all packages to latest version
* Useful EC2 utilities for Amazon images, see [ec2tools](#ec2tools).

Declare ssh keys to be added in `hieradata/common.yaml`. They use puppet's create resourse syntax. For each key you need to define the owner, type, actual key signature, and status.

> `common.yaml`

```yaml
---
ssh_keys:
    "artur.rodrigues":
        type: "ssh-rsa"
        key: "AAAABB...AQQwggyfood"
        ensure: "present"
    "joao.sa":
        type: "ssh-rsa"
        key: "AAAAB3...5/gSHiggy1k"
        ensure: "present"
```

## ec2tools

*internal usage*

[ec2-consistent-snapshot](https://github.com/alestic/ec2-consistent-snapshot) and [ec2-api-tools](https://aws.amazon.com/developertools/351) along with their respective Perl and Java dependencies. (Required by `base`)

## java

*internal usage*

For optimal compatibility with most java applications and tools, we default to using the Oracle JRE7. This module usually is pulled by default by other modules that require Java. (Required by `ec2tools` and `ruby`)

## mongodb

Latest stable `mongodb` from 10gen's (now MongoDB Inc) repository.

* Mounts the datadir `/var/lib/mongodb` to the preformatted `/dev/xvdf1`

## mysql

Latest `mysql-server` from Ubuntu's repository.

* Mounts the datadir `/var/lib/mysql` to the preformatted `/dev/xvdf1`.
* Allows connections from any address (We control permissions through firewall or EC2 security groups).
* Creates database user `ubuntu` with super user privileges.

## nginx

Latest stable `nginx` from `ppa:nginx/stable`.

* Mounts publicly-served directory `/srv/www` to `/dev/xvdg1`
* Includes new default `nginx.conf` with a few optimizations inspired by HTML5 boilerplate.

## php

Latest stable PHP and common dependencies of PHP applications such as WordPress and Moodle. Sets up socket on `/var/run/php5-fpm.sock' so `php-fpm` can communicate with nginx (Must specify in your applications nginx vhost configuration).

## ruby

Installs and compiles Ruby through rbenv along with common gem depencies such as `imagemagick` and `libsqlite3`.
Defaults to installing Ruby 1.9.3-p448 but you can override. Note the usage of class syntax with parameters instead of include syntax.

> `site.pp`

```puppet
...
  class {'ruby':
    user => 'ubuntu',
    version => '2.0.0-p247'
  }
...
```

# Thanks

Big thanks to [`cpan`](https://github.com/meltwater/puppet-cpan) and [`rbenv`](https://github.com/alup/puppet-rbenv) for providing idimotic Puppet resource modules used by parcelles.
