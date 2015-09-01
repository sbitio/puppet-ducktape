class ducktape {
  if defined('::apache') and defined(Class['::apache']) {
    require ::ducktape::apache
  }
  if defined('::corosync') and defined(Class['::corosync']) {
    require ::ducktape::corosync
  }
  if defined('::haproxy') and defined(Class['::haproxy']) {
    require ::ducktape::haproxy
  }
  if defined('::logcheck') and defined(Class['::logcheck']) {
    require ::ducktape::logcheck
  }
  if defined('::logrotate::base') and defined(Class['::logrotate::base']) {
    require ::ducktape::logrotate
  }
  if defined('::logstash') and defined(Class['::logstash']) {
    require ::ducktape::logstash
  }
  if defined('::logstashforwarder') and defined(Class['::logstashforwarder']) {
    require ::ducktape::logstashforwarder
  }
  if defined('::memcached') and defined(Class['::memcached']) {
    require ::ducktape::memcached
  }
  if defined('::munin::node') and defined(Class['::munin::node']) {
    require ::ducktape::munin::node
  }
  if defined('::mysql::client') and defined(Class['::mysql::client']) {
    require ::ducktape::mysql::client
  }
  if defined('::mysql::server') and defined(Class['::mysql::server']) {
    require ::ducktape::mysql::server
  }
  if defined('::newrelic') and defined(Class['::newrelic']) {
    require ::ducktape::newrelic
  }
  if defined('::ntp') and defined(Class['::ntp']) {
    require ::ducktape::ntp
  }
  if defined('::opendkim') and defined(Class['::opendkim']) {
    require ::ducktape::opendkim
  }
  if defined('::openvpn') and defined(Class['::openvpn']) {
    require ::ducktape::openvpn
  }
  if defined('::php') and defined(Class['::php']) {
    require ::ducktape::php
  }
  if defined('::postfix') and defined(Class['::postfix']) {
    require ::ducktape::postfix
  }
  if defined('::postgresql') and defined(Class['::postgresql']) {
    require ::ducktape::postgresql
  }
  if defined('::puppetdb') and defined(Class['::puppetdb']) {
    require ::ducktape::puppetdb
  }
  if defined('::rabbitmq') and defined(Class['::rabbitmq']) {
    require ::ducktape::rabbitmq
  }
  if defined('::ssh') and defined(Class['::ssh']) {
    require ::ducktape::ssh
  }
  if defined('::sudo') and defined(Class['::sudo']) {
    require ::ducktape::sudo
  }
  if defined('::tomcat') and defined(Class['::tomcat']) {
    require ::ducktape::tomcat
  }
  if defined('::varnish') and defined(Class['::varnish']) {
    require ::ducktape::varnish
  }

  require ::ducktape::vcsrepo

}

