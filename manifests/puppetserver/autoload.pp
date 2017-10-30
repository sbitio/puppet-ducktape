class ducktape::puppetserver::autoload() {

  create_resources('ducktape::puppetserver::autoload::config::puppetserver', hiera_hash('ducktape::puppetserver::config::puppetserver', {'notify' => Service['puppetserver']}))

}

define ducktape::puppetserver::autoload::config::puppetserver(
  $file = 'puppetserver.conf',
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
