# Ducktape

Ducktape is a helper module to extend other modules functionality, or to
make them play together.

Every single functionality can be disabled by toggling its related
`$enabled` param.


## Supported modules

Those are the modules we work with at present:

* [puppetlabs/apache](https://forge.puppetlabs.com/puppetlabs/apache)
* [puppetlabs/corosync](https://forge.puppetlabs.com/puppetlabs/corosync)
* [pcfens/filebeat](https://forge.puppetlabs.com/pcfens/filebeat)
* [puppetlabs/haproxy](https://forge.puppetlabs.com/puppetlabs/haproxy)
* [sbitio/logcheck](https://github.com/sbitio/puppet-logcheck)
* [rodjek/logrotate](https://forge.puppetlabs.com/rodjek/logrotate)
* [elasticsearch/logstash](https://forge.puppetlabs.com/elasticsearch/logstash)
* [saz/memcached](https://forge.puppetlabs.com/saz/memcached)
* [sbitio/monit](https://github.com/sbitio/puppet-monit)
* [sbitio/munin](https://github.com/sbitio/puppet-munin)
* [puppetlabs/mysql](https://forge.puppetlabs.com/puppetlabs/mysql)
* [fsalum/newrelic](https://forge.puppetlabs.com/fsalum/newrelic)
* [echocat/nfs](https://forge.puppetlabs.com/echocat/nfs)
* [puppetlabs/ntp](https://forge.puppetlabs.com/puppetlabs/ntp)
* [bi4o4ek/opendkim](https://forge.puppetlabs.com/bi4o4ek/opendkim)
* [luxflux/openvpn](https://forge.puppetlabs.com/luxflux/openvpn)
* [mayflower/php](https://forge.puppetlabs.com/mayflower/php)
* [camptocamp/postfix](https://forge.puppetlabs.com/camptocamp/postfix)
* [puppetlabs/puppetdb](https://forge.puppetlabs.com/puppetlabs/puppetdb)
* [puppetlabs/rabbitmq](https://forge.puppetlabs.com/puppetlabs/rabbitmq)
* [saz/rsyslog](https://forge.puppetlabs.com/saz/rsyslog)
* [saz/ssh](https://forge.puppetlabs.com/saz/ssh)
* [saz/sudo](https://forge.puppetlabs.com/saz/sudo)
* [sbitio/tomcat](https://github.com/sbitio/puppet-tomcat)
* [bashtoni/varnish](https://forge.puppetlabs.com/bashtoni/varnish)
* [puppetlabs/vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo)


## Requirements

This module heavily relies on Puppet's `defined()` function, so it must be
included after all supported modules lasses to take effect.

Ideally you should include it the last one, as more integration may be
added in a feature.


## TODO

* Move out `yaml_hierarchy_expander`
* Move out `json`
* Add nagios integration


## License

MIT License, see LICENSE file.


## Contact

Use contact form at http://sbit.io


## Support

Please log tickets and issues on [GitHub](https://github.com/sbitio/puppet-ducktape)

