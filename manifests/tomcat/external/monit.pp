class ducktape::tomcat::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'RedHat' => '/var/run/tomcat6.pid',
      'Debian' => '/var/run/tomcat6.pid',
    }
    monit::check::service { 'tomcat':
      pidfile => $pidfile,
    }
  }

}

