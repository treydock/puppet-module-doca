# puppet-module-doca

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/doca.svg)](https://forge.puppetlabs.com/treydock/doca)
[![CI Status](https://github.com/treydock/puppet-module-doca/workflows/CI/badge.svg?branch=main)](https://github.com/treydock/puppet-module-doca/actions?query=workflow%3ACI)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
    * [Facts](#facts)
4. [Limitations - OS compatibility, etc.](#limitations)

## Overview

The DOCA Puppet module manages NVIDIA DOCA for Linux.

## Usage

### doca

Install a specific version of DOCA:

```puppet
class { 'doca':
  version => '3.2.2',
}
```

Install and configure DOCA from site specific yum repo server.

```puppet
class { 'doca':
  repo_baseurl => "http://example.com/doca/3.5.0_rhel${facts['os']['release']['major']}"
  repo_gpgkey  => "http://example.com/doca/3.5.0_rhel${facts['os']['release']['major']}/RPM-GPG-KEY-doca",
}
```

### doca::interface

Add IPoIB interface

```puppet
doca::interface { 'ib0':
  ensure         => 'present',
  ipaddr         => '10.0.0.1',
  netmask        => '255.255.0.0',
  connected_mode => 'no',
}
```

The same interface can be defined in Hiera if the mofed class is included

```yaml
doca::interfaces:
  ib0:
    ensure: 'present'
    ipaddr: '10.0.0.1'
    netmask: '255.255.0.0'
    connected_mode: 'no'
```

### doca::opensm

Add opensm that is set for 2 ports.

```puppet
class { 'doca::opensm':
  ports => ['mlx4_1 1', 'mlx4_1 2'],
}
```


## Reference

[http://treydock.github.io/puppet-module-doca/](http://treydock.github.io/puppet-module-doca/)

### Facts

#### has\_nvidia\_infiniband

This boolean fact will return `true` if the system has a NVIDIA Infiniband card.

#### nvidia\_ofed\_version

Returns the NVIDIA OFED version that is installed

#### infiniband\_hcas

Moved to [treydock/infiniband](https://forge.puppetlabs.com/treydock/infiniband) module

#### infiniband\_hca\_port\_guids

Moved to [treydock/infiniband](https://forge.puppetlabs.com/treydock/infiniband) module

## Limitations

This module has been tested on:

* RedHat 8 x86_64
* RedHat 9 x86_64
