class ducktape {
  create_resources(ducktape::install_rpm, hiera_hash('extra_packages_rpm', {}))

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
  if defined('::mysql::client') and defined(Class['::mysql::client']) {
    require ::ducktape::mysql::client
  }
  if defined('::mysql::server') and defined(Class['::mysql::server']) {
    require ::ducktape::mysql::server
  }
  if defined('::newrelic') and defined(Class['::newrelic']) {
    require ::ducktape::newrelic
  }
  if defined('::openvpn') and defined(Class['::openvpn']) {
    require ::ducktape::openvpn
  }
  if defined('::php') and defined(Class['::php']) {
    require ::ducktape::php
  }
  if defined('::sudo') and defined(Class['::sudo']) {
    require ::ducktape::sudo
  }
  if defined('::varnish') and defined(Class['::varnish']) {
    require ::ducktape::varnish
  }
}

