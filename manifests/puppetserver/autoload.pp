class ducktape::puppetserver::autoload () {
  $defaults = { 'notify' => Service['puppetserver'] }
  create_resources('ducktape::puppetserver::autoload::config::puppetserver', hiera_hash('ducktape::puppetserver::config::puppetserver', {}), $defaults)
}
