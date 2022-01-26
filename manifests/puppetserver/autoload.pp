class ducktape::puppetserver::autoload() {

  create_resources('ducktape::puppetserver::autoload::config::puppetserver', $ducktape::puppetserver::puppetserver_config, $ducktape::puppetserver::defaults)

}

define ducktape::puppetserver::autoload::config::puppetserver(
  String                         $file         = 'puppetserver.conf',
  Variant[Array[String], String] $value,
  Optional[String]               $setting_type = undef,
) {

  $setting = "${file}/${title}";
  ensure_resource("puppetserver::config::puppetserver", $setting, {
    ensure       => 'present',
    value        => $value,
    setting_type => $setting_type,
  })
}
