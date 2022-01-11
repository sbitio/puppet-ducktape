define ducktape::mysql::conf(
  Boolean $ensure     = present,
  String $priority   = '010',
  String $section    = 'mysqld',
  $directives = {},
  $content    = undef,
) {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")
  validate_hash($directives)

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
