# == Class: jbossas::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Luca Gioppo <mailto:gioppoluca@libero.it>
#
class jbossas::params {
  # ### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false

  # ### Default values for the parameters of the plugin::foobar class,    # FIXME/TODO: Replace "foobar" with the name of the plugin
  # you you want to manage (all occurrences at the following 8 lines)
  # ### plugin/foobar.pp

  # ensure
  $ensure_plugin_foobar = 'present'

  # autoupgrade
  $autoupgrade_plugin_foobar = false

  # ### Internal module values

  # packages
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific' : {
      # main application
      $package = ['FIXME/TODO']
      # plugins
      $package_plugin_foobar = ['FIXME/TODO']
    }
    'Debian', 'Ubuntu' : {
      # main application
      $package = ['FIXME/TODO']
      # plugins
      $package_plugin_foobar = ['FIXME/TODO']
    }
    default            : {
      fail("\"${module_name}\" provides no package default value for \"${::operatingsystem}\"")
    }
  }

  $jboss_user = 'jbossas'
  $jboss_group = 'jbossas'
  $bind_address = '0.0.0.0'
  $bind_address_management = '127.0.0.1'
  $bind_address_unsecure = '127.0.0.1'
  $http_port = 8080
  $https_port = 8443
  $management_native_port = 9999
  $management_http_port = 9990
  $domain_master_port = 9999
  $domain_master_address = '0.0.0.0'
  $enable_service = true
  $deploy_dir = '/usr/share/jboss-as'
  $modes = 'standalone'
  $role  = 'master'
  $package_url = 'http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/'
  $version = '7.1.1'
  # service status
  $status = 'enabled'
  $service_name = 'jboss-as'
  $service_hasrestart = true
  $service_hasstatus = true
  $service_pattern = $service_name
  $admin_user = 'admin'
  $admin_user_password = 'admin'

}
