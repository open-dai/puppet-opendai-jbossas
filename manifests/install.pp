# == Class: jbossas::install
#
# This class exists to coordinate all software install related
# actions, functionality and logical units in a central place.
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
#   class { 'jbossas::install': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Luca Gioppo <mailto:gioppoluca@libero.it>
#
class jbossas::install {
  $file_url = "${jbossas::package_url}jboss-as-${jbossas::version}.Final.tar.gz"
  $down_dir = '/home/jbossas/tmp'
  $dist_file = "${down_dir}/jboss-as-${jbossas::version}.tar.gz"
  # ### install management
  $jbossas_bind_address = $jbossas::bind_address
  $jbossas_home = $jbossas::deploy_dir

  # Create group and user
  group { jbossas: ensure => $jbossas::ensure }

  user { jbossas:
    ensure     => $jbossas::ensure,
    managehome => true,
    gid        => 'jbossas',
    require    => Group['jbossas'],
    comment    => 'JBoss Application Server'
  }

  file { '/home/jbossas':
    ensure  => $jbossas::ensure,
    owner   => 'jbossas',
    group   => 'jbossas',
    mode    => 0775,
    require => [Group['jbossas'], User['jbossas']]
  }

  # in operation
  if $jbossas::ensure == 'present' {
    file { $down_dir:
      ensure  => directory,
      owner   => 'jbossas',
      group   => 'jbossas',
      mode    => 0775,
      require => [Group['jbossas'], User['jbossas']]
    }

    exec { download_jboss_as:
      command   => "/usr/bin/curl -v --progress-bar -o '$dist_file' '$file_url'",
      creates   => $dist_file,
      user      => 'jbossas',
      logoutput => true,
      require   => [Package['curl'], File[$down_dir]],
    }

    # we need a deploy dir where Jboss will be placed
    file { "$jbossas::deploy_dir":
      ensure  => directory,
      owner   => 'jbossas',
      group   => 'jbossas',
      require => [Group['jbossas'], User['jbossas'], Exec['download_jboss_as']]
    }

    # Extract the JBoss AS distribution
    exec { extract_jboss_as:
      command   => "/bin/tar -xz -f '$dist_file'",
      creates   => "${down_dir}/jboss-as-${jbossas::version}.Final",
      cwd       => "${down_dir}",
      user      => 'jbossas',
      group     => 'jbossas',
      logoutput => true,
      # 			unless => "/usr/bin/test -d '$jbossas::deploy_dir'",
      require   => [Group['jbossas'], User['jbossas'], Exec['download_jboss_as']]
    }

    exec { move_jboss_home:
      command   => "/bin/mv -v ${down_dir}/jboss-as-${jbossas::version}.Final/* '${jbossas::deploy_dir}'",
      creates   => "$jbossas::deploy_dir/bin",
      logoutput => true,
      require   => Exec['extract_jboss_as']
    }
    notice("/bin/mv -v ${down_dir}/jboss-as-${jbossas::version}.Final/* '${jbossas::deploy_dir}'")

    # install part needed for service
    file { '/etc/jboss-as':
      ensure => directory,
      owner  => 'root',
      group  => 'root'
    }

    file { '/etc/jboss-as/jboss-as.conf':
      content => template('jbossas/jboss-as.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
      require => File['/etc/jboss-as'],
    }

    file { '/var/run/jboss-as':
      ensure => directory,
      owner  => 'jbossas',
      group  => 'jbossas',
      mode   => 0775
    }
    
    file { '/etc/init.d/jboss-as':
      content => template('jbossas/jboss-as.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => 0755,
      require => File['/var/run/jboss-as'],
    }
    
    file { "${jbossas::deploy_dir}/jboss.properties":
      content => template('jbossas/jboss.properties.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => 0755,
      require => File['/etc/init.d/jboss-as'],
    #      notify => Service['jbossas'],
    }
    # removal
  } else {
  }
}