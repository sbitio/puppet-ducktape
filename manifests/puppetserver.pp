class ducktape::puppetserver(
  Boolean $enabled = true,
  Hash $puppetserver_config = {},
  Hash $defaults = {'notify' => Service['puppetserver']},
) {

  if $enabled {
    include ducktape::puppetserver::autoload

    # Tell etckeeper to ignore puppet environments.
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
