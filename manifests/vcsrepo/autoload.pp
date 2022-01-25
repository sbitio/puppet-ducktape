class ducktape::vcsrepo::autoload (
  Boolean $autoload,
) {

  if $autoload {
    create_resources('vcsrepo', $ducktape::vcsrepo::repos, $ducktape::vcsrepo::repo_defaults)
  }
}
