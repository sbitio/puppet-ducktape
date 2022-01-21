define ducktape::mysql::conf(
  Enum['present', 'absent'] $ensure = 'present',
  String $priority   = '010',
  String $section    = 'mysqld',
  $directives = {},
  $content    = undef,
) {

  $file = "${::mysql::server::includedir}/${priority}-${name}.cnf"

  if $ensure == present {
    if $content != undef {
      $content_real = $content
    }
    else {
      $options = {"${section}" => $directives}
      $content_real = template('mysql/my.cnf.erb')
    }
  }

  file { $file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content_real,
    notify  => Class['::mysql::server::service'],
  }
}
