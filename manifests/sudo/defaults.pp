class ducktape::sudo::defaults (
  Boolean $enabled         = true,
  String $passwd_policy   = 'PASSWD',
  String $hiera_mode      = 'array',
  Boolean $ansible_enabled = true,
  String $ansible_user    = 'ansible',
  $vagrant_enabled = (defined('$::is_vagrant') and ($::is_vagrant)),
  $amazon_enabled  = (defined('$::ec2_ami_id') and ($::ec2_ami_id != '')),
) {

  if $enabled {
    # sudo_groups
    if $hiera_mode == 'array' {
      $sudo_groups = hiera_array('ducktape::sudo::defaults::groups', [])
    }
    else {
      $sudo_groups = hiera('ducktape::sudo::defaults::groups', '')
    }
    if $sudo_groups != [] and $sudo_groups != '' {
      Group[$sudo_groups] -> Sudo::Conf <| |>
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
    # vagrant
    if $vagrant_enabled {
      sudo::conf { 'vagrant' :
        priority => 00,
        content  => 'vagrant ALL=NOPASSWD:ALL
Defaults:vagrant !requiretty',
      }
    }
    # amazon
    if $amazon_enabled {
      case $::operatingsystem {
        'Debian' : {
          sudo::conf { 'cloud-init-users' :
            priority => 90,
            content  => 'admin ALL=(ALL) NOPASSWD:ALL',
          }
        }
        default : {}
      }
    }
  }

}
