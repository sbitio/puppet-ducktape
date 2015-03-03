class ducktape::logstashforwarder::external::rsyslog (
  $ensure       = present,
  $enabled      = true,
  $priority     = '49',
  $programname  = 'logstash-forwarder',
  $log_dst      = '/var/log/logstashforwarder.log',
  $templatename = 'LogstashForwarderMsgOnly',
) {

  #TODO# Add validations

  if $enabled {
    rsyslog::snippet { "${priority}-${programname}" :
      ensure  => $ensure,
      content => template('ducktape/logstashforwarder/external/rsyslog.conf.erb'),
    }
  }

}
