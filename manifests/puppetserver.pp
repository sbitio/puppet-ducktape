class ducktape::puppetdb(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # Add client-side cache dir to the ruby load path, to allow discovering
    # of libraries provided by modules (f.e. hiera backends).
    # See https://tickets.puppetlabs.com/browse/SERVER-571
    puppetserver::config::puppetserver { 'puppetserver.conf/jruby-puppet/ruby-load-path':
      value => ['/opt/puppetlabs/puppet/lib/ruby/vendor_ruby', '/opt/puppetlabs/puppet/cache/lib'],
    }

    # Tell etcleeper ignore puppet environments.
    if defined('::etckeeper') and defined(Class['::etckeeper']) {
      file_line { '/etc/.gitignore':
        path    => '/etc/.gitignore',
        line    => 'puppetlabs/code/*',
        require => Class['::etckeeper'],
      }
      if defined('::r10k') and defined(Class['::r10k']) {
        anchor { 'etckeeper-before-r10k::begin': }
        -> File_line['/etc/.gitignore']
        -> Class['::r10k']
        -> anchor { 'etckeeper-before-r10k::end': }
      }
    }
  }

}

