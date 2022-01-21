class ducktape::puppetserver::autoload() {

  $defaults = {'notify' => Service['puppetserver']}
  create_resources('ducktape::puppetserver::autoload::config::puppetserver', hiera_hash('ducktape::puppetserver::config::puppetserver', {}), $defaults)

}

define ducktape::puppetserver::autoload::config::puppetserver(
  String $file = 'puppetserver.conf',
  $value,
  $setting_type = undef,
) {

  $setting = "${file}/${title}";
  ensure_resource("puppetserver::config::puppetserver", $setting, {
    ensure       => 'present',
    value        => $value,
    setting_type => $setting_type,
  })
}
