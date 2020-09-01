class ducktape::jenkins::bootstrap (
  String  $admin_user = 'admin',
  String  $admin_pass = '',
  String  $admin_mail = 'root@localhost',
  String  $admin_name = $admin_user,
  String  $admin_keys = '',
  Boolean $create_password_file = false,
) {

  ### Create or update admin user
  $initial_admin_pass_file = "/var/lib/jenkins/secrets/initialAdminPassword"
  $jenkins_cli_auth_init ="/usr/local/bin/jenkins-cli -auth admin:$(cat ${initial_admin_pass_file})"
  $puppet_helper = "/bin/cat ${::jenkins::libdir}/puppet_helper.groovy | ${jenkins_cli_auth_init} groovy ="

  if $admin_user == 'admin' {
    $remove_admin = "/bin/true"
  }
  else {
    $remove_admin = "${puppet_helper} delete_user admin"
  }

  exec { 'ducktape-jenkins-bootstrap-cmd':
    command => "${puppet_helper} set_security full_control \
      && ${puppet_helper} create_or_update_user '${admin_user}' '${admin_mail}' '${admin_pass}' '${admin_name}' '${admin_keys}' \
      && ${remove_admin} \
      && rm ${initial_admin_pass_file}",
    require => Class['jenkins::cli_helper'],
    notify => Class['jenkins::cli::reload'],
    unless => "test ! -e ${initial_admin_pass_file}",
  }
}
