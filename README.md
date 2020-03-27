# Ducktape

Ducktape is a helper module to extend other modules functionality, or to
make them play together.

Every single functionality can be disabled by toggling its related
`$enabled` param.


## Supported modules

Those are the modules we work with at present:

* [puppetlabs/apache](https://forge.puppetlabs.com/puppetlabs/apache)
* [puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/apt)
* [puppet/alternatives](https://forge.puppet.com/puppet/alternatives)
* [puppet/archive](https://github.com/voxpupuli/puppet-archive)
* [puppetlabs/corosync](https://forge.puppetlabs.com/puppetlabs/corosync)
* [pcfens/filebeat](https://forge.puppetlabs.com/pcfens/filebeat)
* [puppetlabs/firewall](https://forge.puppet.com/puppetlabs/firewall)
* [alexharvey/firewall_multi](https://forge.puppet.com/alexharvey/firewall_multi)
* [puppet/gluster](https://forge.puppetlabs.com/puppet/gluster)
* [puppetlabs/haproxy](https://forge.puppetlabs.com/puppetlabs/haproxy)
* [puppet/jenkins](https://forge.puppet.com/puppet/jenkins)
* [elastic/kibana](https://forge.puppetlabs.com/elastic/kibana)
* [datacentred/ldap](https://forge.puppet.com/datacentred/ldap)
* [danzilio/letsencrypt](https://forge.puppet.com/danzilio/letsencrypt)
* [sbitio/logcheck](https://github.com/sbitio/puppet-logcheck)
* [yo61/logrotate](https://forge.puppet.com/yo61/logrotate)
* [elasticsearch/logstash](https://forge.puppetlabs.com/elasticsearch/logstash)
* [saz/memcached](https://forge.puppetlabs.com/saz/memcached)
* [sbitio/monit](https://github.com/sbitio/puppet-monit)
* [sbitio/munin](https://github.com/sbitio/puppet-munin)
* [puppetlabs/mysql](https://forge.puppetlabs.com/puppetlabs/mysql)
* [claranet/newrelic](https://forge.puppetlabs.com/claranet/newrelic)
* [echocat/nfs](https://forge.puppetlabs.com/echocat/nfs)
* [puppetlabs/ntp](https://forge.puppetlabs.com/puppetlabs/ntp)
* [bi4o4ek/opendkim](https://forge.puppetlabs.com/bi4o4ek/opendkim)
* [camptocamp/openldap](https://forge.puppetlabs.com/camptocamp/openldap)
* [luxflux/openvpn](https://forge.puppetlabs.com/luxflux/openvpn)
* [voxpupuli/php](https://forge.puppetlabs.com/puppet/php)
* [camptocamp/postfix](https://forge.puppetlabs.com/camptocamp/postfix)
* [puppetlabs/puppetdb](https://forge.puppetlabs.com/puppetlabs/puppetdb)
* [camptocamp/puppetserver](https://forge.puppetlabs.com/camptocamp/puppetserver)
* [puppetlabs/rabbitmq](https://forge.puppetlabs.com/puppetlabs/rabbitmq)
* [arioch/redis](https://forge.puppet.com/arioch/redis)
* [saz/rsyslog](https://forge.puppetlabs.com/saz/rsyslog)
* [saz/ssh](https://forge.puppetlabs.com/saz/ssh)
* [saz/sudo](https://forge.puppetlabs.com/saz/sudo)
* [camptocamp/systemd](https://forge.puppet.com/camptocamp/systemd)
* [sbitio/tomcat](https://github.com/sbitio/puppet-tomcat)
* [pcfens/topbeat](https://forge.puppetlabs.com/pcfens/topbeat)
* [sbog/twemproxy](https://forge.puppet.com/sbog/twemproxy)
* [claranet/varnish](https://forge.puppetlabs.com/claranet/varnish)
* [puppetlabs/vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo)


## Requirements

This module heavily relies on Puppet's `defined()` function, so it must be
included after all supported modules lasses to take effect.

Ideally you should include it the last one, as more integration may be
added in a feature.


## TODO

* Move out `json`
* Add nagios integration


## License

MIT License, see LICENSE file.


## Contact

Use contact form at http://sbit.io


## Support

Please log tickets and issues on [GitHub](https://github.com/sbitio/puppet-ducktape)

