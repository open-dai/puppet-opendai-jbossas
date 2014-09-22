# == Class: jbossas::config
#
# FIXME/TODO Please check if you want to remove this class because it may be
#            unnecessary for your module. Don't forget to update the class
#            declarations and relationships at init.pp afterwards (the relevant
#            parts are marked with "FIXME/TODO" comments).
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'jbossas::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Luca Gioppo <mailto:gioppoluca@libero.it>
#
class jbossas::config {

  #### Configuration

  # nothing right now

  # Helpful snippet(s):
  #
  # Config file. See 'file' doc at http://j.mp/wKju0C for information.
  # file { 'jbossas_config':
  #   ensure  => 'present',
  #   path    => '/etc/jbossas/jbossas.conf',
  #   mode    => '0644',
  #   owner   => 'root',
  #   group   => 'root',
  #   # If you specify multiple file sources for a file, then the first source
  #   # that exists will be used.
  #   source  => [
  #     "puppet:///modules/jbossas/config.cfg-$::fqdn",
  #     "puppet:///modules/jbossas/config.cfg-$::hostname",
  #     'puppet:///modules/jbossas/config.cfg'
  #   ],
  #   content => template('jbossas/config.erb'),
  # }
  exec {
		jbossas_http_port :
			command => "/bin/sed -i -e 's/socket-binding name=\"http\" port=\"[0-9]\\+\"/socket-binding name=\"http\" port=\"${jbossas::http_port}\"/' ${jbossas::mode}/configuration/${jbossas::mode}.xml",
			user      => "$jbossas::jboss_user",
			cwd => "${jbossas::deploy_dir}",
			logoutput => true,
			unless =>"/bin/grep 'socket-binding name=\"http\" port=\"${jbossas::http_port}\"/' ${jbossas::mode}/configuration/${jbossas::mode}.xml",
#			notify => Service['jbossas'],
	}
	exec {
		jbossas_https_port :
			command =>
			"/bin/sed -i -e 's/socket-binding name=\"https\" port=\"[0-9]\\+\"/socket-binding name=\"https\" port=\"${jbossas::https_port}\"/' ${jbossas::mode}/configuration/${jbossas::mode}.xml",
			user      => "$jbossas::jboss_user",
			cwd => "${jbossas::deploy_dir}",
			logoutput => true,
			require => Class['jbossas::install'],
			unless => "/bin/grep 'socket-binding name=\"https\" port=\"${jbossas::https_port}\"/' ${jbossas::mode}/configuration/${jbossas::mode}.xml",
#			notify => Service['jbossas']
	}

}
