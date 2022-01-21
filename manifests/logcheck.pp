class ducktape::logcheck (
  Boolean $enabled = true,
) {

  if $enabled {
    # Workaround packaging bug https://bugzilla.redhat.com/show_bug.cgi?id=678436
    case $::osfamily {
      'RedHat': {
        require ::logcheck::params

        ensure_resource (
          'file',
          $::logcheck::params::logfiles_real,
          { mode  => 'g+r',
            group => 'adm', }
        )

        logrotate::rule { 'syslog':
          path          => [
            '/var/log/cron',
            '/var/log/maillog',
            '/var/log/messages',
            '/var/log/secure',
            '/var/log/spooler',
          ],
          sharedscripts => true,
          postrotate    => '/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true',
          create        => true,
          create_mode   => 640,
          create_owner  => 'root',
          create_group  => 'adm',
        }
      }

      default: { }
    }
  }

}
