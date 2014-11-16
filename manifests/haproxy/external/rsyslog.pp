class ducktape::haproxy::external::rsyslog (
  $ensure      = present,
  $enabled     = true,
  $priority    = '49',
  $udp_listen  = true,
  $udp_ip      = '127.0.0.1',
  $udp_port    = '514',
  $programname = 'haproxy',
  $log_dst     = '/var/log/haproxy.log',
) {

  #TODO# Add validations

  if $enabled {
    rsyslog::snippet { "${priority}-${programname}" :
      ensure  => $ensure,
      content => template('ducktape/haproxy/external/rsyslog.conf.erb'),
    }
  }

}
