# Ducktape

Ducktape is a helper module to extend other modules functionality, or to
make them play together.

Every single functionality can be disabled by toggling its related
`$enabled` param.


## Supported modules

Those are the modules we work with at present:

* [puppetlabs/apache](https://forge.puppetlabs.com/puppetlabs/apache)
* [puppetlabs/corosync](https://forge.puppetlabs.com/puppetlabs/corosync)
* [puppetlabs/haproxy](https://forge.puppetlabs.com/puppetlabs/haproxy)
* [sbitio/logcheck](https://github.com/sbitio/puppet-logcheck)
* [saz/memcached](https://forge.puppetlabs.com/saz/memcached)
* [sbitio/monit](https://github.com/sbitio/puppet-monit)
* [sbitio/munin](https://github.com/sbitio/puppet-munin)
* [puppetlabs/mysql](https://forge.puppetlabs.com/puppetlabs/mysql)
* [fsalum/newrelic](https://forge.puppetlabs.com/fsalum/newrelic)
* [puppetlabs/ntp](https://forge.puppetlabs.com/puppetlabs/ntp)
* [luxflux/openvpn](https://forge.puppetlabs.com/luxflux/openvpn)
* [nodes/php](https://forge.puppetlabs.com/nodes/php)
* [camptocamp/postfix](https://forge.puppetlabs.com/camptocamp/postfix)
* [puppetlabs/puppetdb](https://forge.puppetlabs.com/puppetlabs/puppetdb)
* [saz/ssh](https://forge.puppetlabs.com/saz/ssh)
* [saz/sudo](https://forge.puppetlabs.com/saz/sudo)
* [NITEMAN/tomcat](https://github.com/NITEMAN/puppet-tomcat)
* [maxchk/varnish](https://forge.puppetlabs.com/maxchk/varnish)


## Requirements

This module heavily relies on Puppet's `defined()` function, so it must be
included after all supported modules lasses to take effect.

Ideally you should include it the last one, as more integration may be
added in a feature.


## TODO

* Move out `install_rpm`
* Move out `yaml_hierarchy_expander`
* Move out `json`
* Add nagios integration


## License

MIT License, see LICENSE file.


## Contact

Use contact form at http://sbit.io


## Support

Please log tickets and issues on [GitHub](https://github.com/sbitio/puppet-ducktape)

