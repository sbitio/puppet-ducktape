class ducktape::sudo::defaults (
  Boolean $enabled         = true,
  String $passwd_policy   = 'PASSWD',
  Array[String] $groups = [],
  String $group_passwd_policy = 'NOPASSWD',
  Boolean $ansible_enabled = true,
  String $ansible_user    = 'ansible',
) {
  if $enabled {
    if $groups {
      Group[$groups] -> Sudo::Conf <| |>
      sudo::conf { 'defaults_sudo_groups' :
        priority => 10,
        content  => template('ducktape/sudo/groups.erb'),
      }
    }
    # ansible
    if $ansible_enabled {
      sudo::conf { 'ansible' :
        priority => 10,
        content  => "${ansible_user} ALL=NOPASSWD: ALL",
      }
    }
  }
}
