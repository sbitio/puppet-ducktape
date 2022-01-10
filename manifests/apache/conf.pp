define ducktape::apache::conf(
  Enum['present', 'absent'] $ensure = present,
  String $priority   = '010',
  Array[String] $directives = [],
  Optional[String] $content    = undef,
) {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")
  validate_array($directives)

  $file = "${::apache::confd_dir}/${priority}-${name}.conf"

  if $ensure == present {
    if $content != undef {
      $content_real = $content
    }
    else {
      $content_real = template('ducktape/apache/conf.erb')
    }
  }

  file { $file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content_real,
    notify  => Class['::apache::service'],
  }
}
