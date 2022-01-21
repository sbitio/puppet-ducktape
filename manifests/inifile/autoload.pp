class ducktape::inifile::autoload(
  Boolean $autoload = true,
) {

  if $autoload {
    create_resources('ini_setting', $ducktape::inifile::settings, $ducktape::inifile::defaults)
  }

}
