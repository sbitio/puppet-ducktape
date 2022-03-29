class ducktape::jenkins::external::monit(
  Boolean $enabled = true,
  String  $action  = 'restart',
  Integer $port = 8080,
  Hash $conn_tolerance = { cycles => 1 },
) {

  if $enabled {
    $connection_test = {
      type => 'connection',
      protocol => 'http',
      protocol_test => {
        request => '/login',
      },
      port => $port,
      action => $action,
      tolerance => {
        cycles => 2,
      }
    }
    monit::check::service { 'jenkins':
      binary       => '/usr/share/java/jenkins.war',
      systemd_file => '/lib/systemd/system/jenkins.service',
      matching     => 'jenkins.war',
      tests        => [$connection_test, ],
    }
  }

}
