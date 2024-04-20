define ducktape::apache::conf (
  Enum['present', 'absent'] $ensure = 'present',
  String $priority   = '010',
  Array[String] $directives = [],
  Optional[String] $content    = undef,
) {
  $file = "${apache::confd_dir}/${priority}-${name}.conf"

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
    notify  => Class['apache::service'],
  }
}
