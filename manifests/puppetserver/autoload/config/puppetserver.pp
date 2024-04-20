define ducktape::puppetserver::autoload::config::puppetserver (
  String $value,
  String $file = 'puppetserver.conf',
  Optional[String] $setting_type = undef,
) {
  $setting = "${file}/${title}";
  ensure_resource('puppetserver::config::puppetserver', $setting, {
      ensure       => 'present',
      value        => $value,
      setting_type => $setting_type,
  })
}
