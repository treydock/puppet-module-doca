# @api private
class doca::repo {
  assert_private()

  if $doca::manage_repo {
    if $facts['os']['family'] == 'RedHat' {
      $dist = 'rhel'
    } else {
      $dist = $facts['os']['name'].downcase()
    }
    case $facts['os']['family'] {
      'RedHat': {
        if $doca::repo_baseurl {
          $repo_baseurl = $doca::repo_baseurl
        } else {
          $repo_baseurl = "https://linux.mellanox.com/public/repo/doca/${doca::version}/${dist}${facts['os']['release']['major']}/\$basearch/"
        }
        if $doca::repo_gpgkey {
          $repo_gpgkey = $doca::repo_gpgkey
        } else {
          $repo_gpgkey = "https://linux.mellanox.com/public/repo/doca/${doca::version}/${dist}${facts['os']['release']['major']}/\$basearch/RPM-GPG-KEY-doca"
        }
        yumrepo { 'doca':
          descr    => 'DOCA Online Repo',
          baseurl  => $repo_baseurl,
          enabled  => '1',
          gpgkey   => $repo_gpgkey,
          gpgcheck => $doca::repo_gpgcheck,
          exclude  => $doca::repo_exclude,
          priority => $doca::repo_priority,
        }
        if $doca::cleanup_mofed {
          yumrepo { 'mlnx_ofed':
            ensure => 'absent',
          }
          -> file { '/etc/yum.repos.d/mlnx_ofed.repo':
            ensure => 'absent',
          }
        }
      }
      default: {
        # Do nothing
      }
    }
  }
}
