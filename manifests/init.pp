# @summary Manage Mellanox OFED
#
# @example Basic usage using local yum repo for DOCA
#   class { 'doca':
#     repo_baseurl => 'http://example.com/mlnx/$releasever/3.4-2.0.0.0-rhel7.3/'
#     repo_gpgkey  => 'http://example.com/mlnx/$releasever/3.4-2.0.0.0-rhel7.3/RPM-GPG-KEY-Mellanox',
#   }
#
# @param version
#   DOCA version to install
# @param manage_repo
#   Boolean to set if DOCA repo should be managed
# @param manage_repo_dependency
#   Manage dependency repos
# @param repo_baseurl
#   The baseurl of the yumrepo resource
# @param repo_gpgcheck
#   The gpgcheck of the yumrepo resource
# @param repo_gpgkey
#   The gpgkey of the yumrepo resource
# @param repo_exclude
#   The exclude of the yumrepo resource
# @param repo_priority
#   The priority of the yumrepo resource
# @param cleanup_mofed
#   Cleanup mofed module resources
# @param manage_packages
#   Boolean to determine if packages should be managed
# @param package_dependencies
#   Packages needed to install DOCA
# @param package_ensure
#   The package ensure property
# @param package_name
#   The DOCA package name to install
# @param extra_packages
#   An array of additional packages to install
# @param manage_service
#   Boolean that determines if the openibd service should be managed
# @param restart_service
#   Boolean that sets of openibd should be restarted
# @param openibd_service_name
#   Name of the openibd service
# @param openibd_service_ensure
#   openibd service ensure property
# @param openibd_service_enable
#   openibd service enable property
# @param manage_config
#   Boolean that sets if configs should be managed
# @param openib_config_path
#   Path to openib.conf
# @param openib_shellvars
#   Hash of shellvar resources
# @param interfaces
#   Hash of doca::interface resources
#
class doca (
  String[1] $version = '3.5.0',
  Boolean $manage_repo = true,
  Boolean $manage_repo_dependency = true,
  Optional[Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl]] $repo_baseurl = undef,
  Enum['1','0'] $repo_gpgcheck = '1',
  Optional[Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl, Stdlib::Filesource]] $repo_gpgkey = undef,
  Optional[String] $repo_exclude = undef,
  Optional[String] $repo_priority = undef,
  Boolean $cleanup_mofed = true,
  Boolean $manage_packages = true,
  Array $package_dependencies = ['dkms', 'gcc', 'make', 'perl', 'mokutil'],
  String $package_ensure = 'present',
  String $package_name = 'doca-ofed',
  Array $extra_packages = [],
  Boolean $manage_service = true,
  Boolean $restart_service = false,
  String $openibd_service_name = 'openibd',
  String $openibd_service_ensure = 'running',
  Boolean $openibd_service_enable = true,
  Boolean $manage_config = true,
  Stdlib::Absolutepath $openib_config_path = '/etc/infiniband/openib.conf',
  Hash $openib_shellvars = {},
  Hash $interfaces = {}
) {
  if $restart_service and $manage_service {
    $openib_shellvar_notify = Service['openibd']
  } else {
    $openib_shellvar_notify = undef
  }

  if $manage_repo_dependency and $facts['os']['family'] == 'RedHat' {
    include epel
    Class['epel'] -> Class['doca::install']
  }

  contain doca::repo
  contain doca::install
  contain doca::config
  contain doca::service

  Class['doca::repo']
  -> Class['doca::install']
  -> Class['doca::config']
  -> Class['doca::service']

  create_resources('doca::interface', $interfaces)
}
