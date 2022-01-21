class ducktape::newrelic (
  Boolean $enabled = true,
) {

  if $enabled {
    # Ensure newrelic extension is installed to all php apis.
    if (versioncmp($::operatingsystemrelease, '9') >= 0) {
      $cmd = @(EOT)
          for PHP_API in $(find /usr/lib/php -maxdepth 1 -name "20*" -type d -printf "%f\n"); do
            if [ ! -e /usr/lib/php/$PHP_API/newrelic.so ]; then
              ln -s /usr/lib/newrelic-php5/agent/x64/newrelic-$PHP_API.so /usr/lib/php/$PHP_API/newrelic.so
            fi
          done;
      |-EOT
      exec { 'newrelic-install-extension':
        command => $cmd,
        provider => 'shell',
        refreshonly => true,
        subscribe => Class['::newrelic::agent::php'],
      }
    }

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::newrelic::external::monit
    }
  }

}
