# == Class: jbossas
#
# This class is able to install or remove jbossas on a node.
#
# [Add description - What does this module do on a node?] FIXME/TODO
#
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Q.v.:
#   * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
#   * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   Defaults to <tt>false</tt>.
#
# The default values for the parameters are set in jbossas::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
# * Installation:
#     class { 'jbossas': }
#
# * Removal/decommissioning:
#     class { 'jbossas':
#       ensure => 'absent',
#     }
#
#
# === Authors
#
# * Luca Gioppo <mailto:gioppoluca@libero.it>
#
class jbossas (
  $ensure                  = $jbossas::params::ensure,
  $autoupgrade             = $jbossas::params::autoupgrade,
  $mode                    = $jbossas::params::modes,
  $role                    = $jbossas::params::role,
  $bind_address            = $jbossas::params::bind_address,
  $bind_address_management = $jbossas::params::bind_address_management,
  $bind_address_unsecure   = $jbossas::params::bind_address_unsecure,
  $domain_master_address   = $jbossas::params::domain_master_address,
  $domain_master_port      = $jbossas::params::domain_master_port,
  $management_native_port  = $jbossas::params::management_native_port,
  $management_http_port    = $jbossas::params::management_http_port,
  $http_port               = $jbossas::params::http_port,
  $https_port              = $jbossas::params::https_port,
  $admin_user              = $jbossas::params::admin_user,
  $admin_user_password     = $jbossas::params::admin_user_password,
  $enable_service          = $jbossas::params::enable_service,
  $deploy_dir              = $jbossas::params::deploy_dir,
  $package_url             = $jbossas::params::package_url,
  $version                 = $jbossas::params::version,
  $status                  = $jbossas::params::status,
  $jboss_user              = $jbossas::params::jboss_user,
  $jboss_group             = $jbossas::params::jboss_group,
  $service_name            = $jbossas::params::service_name) inherits jbossas::params {
  # ### Validate parameters

  # ensure
  if !($ensure in ['present', 'absent']) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  # validate_bool($autoupgrade)

  # service status
  if !($status in ['enabled', 'disabled', 'running', 'unmanaged']) {
    fail("\"${status}\" is not a valid status parameter value")
  }

  # mode
  if !($mode in ['domain', 'standalone']) {
    fail("\"${mode}\" is not a valid mode parameter value")
  }
  
  # role
  if !($role in ['master', 'slave']) {
    fail("\"${role}\" is not a valid mode parameter value")
  }

  # ### create internal variables
  $jboss_user_home = "/home/$jboss_user"

  case $role {
    'master'               : {
      $host_config = 'host'
    }
    'slave'               : {
      $host_config = 'host-slave'
    }
  }
  
  case $version{
    '7.1.1':{
      $filename='jboss-as-7.1.1.Final.zip'
      $folder='jboss-as-7.1.1.Final'
      $deploy_module_dir="${deploy_dir}/modules/"
      $load_balancer_group='domain'
    }
    'EAP6.1.a':{
      $filename='jboss-eap-6.1.0.Alpha.zip'
      $folder='jboss-eap-6.1'
      $deploy_module_dir="${deploy_dir}/modules/system/layers/base/"
      $load_balancer_group='load-balancing-group'
    }
  }
  
  # ### Manage actions

  # repository
  #  class { 'jbossas::repo': }     # FIXME/TODO: Remove this declaration or this comment. See "repo.pp" for more information.

  # package(s)
  #  class { 'jbossas::package': }

  # install
  class { 'jbossas::install':
  }

  # configuration
  #  class { 'jbossas::config':
  #    require => Class['jbossas::install'],
  #  }

  # FIXME/TODO: Remove this declaration or this comment. See "config.pp" for more information.

  # service
  class { 'jbossas::service':
  #    require => Class['jbossas::install'],
  }

  # ### Manage relationships          # FIXME/TODO: Remove the whole relationships block if not needed

  if $ensure == 'present' {
    # we need working repositories before installing packages
    #   Class['jbossas::repo'] -> Class['jbossas::package']     # FIXME/TODO: Remove this relationship or this comment. See
    #   "repo.pp" for more information.

    # we need the software before configuring it
    #    Class['jbossas::install'] -> Class['jbossas::config']
    # FIXME/TODO: Remove this relationship or this comment. See "config.pp"
    #    Class['jbossas::config'] -> Class['jbossas::service']
    Class['jbossas::install'] -> Class['jbossas::service']
    # for more information.
    # TODO check if $enable_service=true
    # we need the software and a working configuration before running a service
    #    Class['jbossas::install'] -> Class['jbossas::service']
    #    Class['jbossas::config']  -> Class['jbossas::service']
  } else {
    # make sure all services are getting stopped before software removal
    #    Class['jbossas::service'] -> Class['jbossas::install']
  }

}