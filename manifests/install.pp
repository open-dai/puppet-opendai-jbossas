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
  $file_url = "${jbossas::package_url}${jbossas::filename}"
  $down_dir = "${jbossas::jboss_user_home}/tmp"

  #  $dist_file = "${down_dir}/${jbossas::filename}"

  # ### install management
  #  $jbossas_bind_address = $jbossas::bind_address
  #  $jbossas_home = $jbossas::deploy_dir

  # Create group and user
  group { "$jbossas::jboss_group":
    ensure => $jbossas::ensure,
    gid    => 1001
  }

  user { "$jbossas::jboss_user":
    ensure     => $jbossas::ensure,
    managehome => true,
    gid        => "$jbossas::jboss_group",
    uid        => 1001,
    require    => Group["$jbossas::jboss_group"],
    comment    => 'JBoss Application Server'
  }

  file { $jbossas::jboss_user_home:
    ensure  => $jbossas::ensure,
    owner   => "$jbossas::jboss_user",
    group   => "$jbossas::jboss_group",
    mode    => 0775,
    require => [Group["$jbossas::jboss_group"], User["$jbossas::jboss_user"]]
  }

  # in operation
  if $jbossas::ensure == 'present' {
    file { $down_dir:
      ensure  => directory,
      owner   => "$jbossas::jboss_user",
      group   => "$jbossas::jboss_group",
      mode    => 0775,
      require => [Group["$jbossas::jboss_group"], User["$jbossas::jboss_user"]]
    }

    # we need a deploy dir where Jboss will be placed
    file { "$jbossas::deploy_dir":
      ensure  => directory,
      owner   => "$jbossas::jboss_user",
      group   => "$jbossas::jboss_group",
      require => [Group["$jbossas::jboss_group"], User["$jbossas::jboss_user"]]
    }

    exec { 'download_jboss_as':
      command   => "/usr/bin/curl -v --progress-bar -o '${down_dir}/${jbossas::filename}' '$file_url'",
      creates   => "${down_dir}/${jbossas::filename}",
      user      => "$jbossas::jboss_user",
      logoutput => true,
      require   => [Package['curl'], File["$jbossas::deploy_dir"]],
    }

    # Extract the JBoss AS distribution
    exec { 'extract_jboss_as':
      command   => "/usr/bin/unzip ${jbossas::filename}",
      creates   => "${down_dir}/${jbossas::folder}",
      cwd       => "${down_dir}",
      user      => "$jbossas::jboss_user",
      group     => "$jbossas::jboss_group",
      logoutput => true,
      # 			unless => "/usr/bin/test -d '$jbossas::deploy_dir'",
      require   => [Group["$jbossas::jboss_group"], User["$jbossas::jboss_user"], Exec['download_jboss_as'], Package['unzip']]
    }

    exec { 'move_jboss_home':
      command   => "/bin/mv -v ${down_dir}/${jbossas::folder}/* '${jbossas::deploy_dir}'",
      creates   => "$jbossas::deploy_dir/bin",
      logoutput => true,
      require   => Exec['extract_jboss_as']
    }
    notice("/bin/mv -v ${down_dir}/jboss-as-${jbossas::version}.Final/* '${jbossas::deploy_dir}'")

    # this has to be created here for not having duplicates in define
    file { ["${jbossas::deploy_module_dir}com", "${jbossas::deploy_module_dir}org",]:
      ensure  => "directory",
      owner   => $jbossas::jboss_user,
      group   => $jbossas::jboss_group,
      require => Exec['move_jboss_home'],
    }

    # install part needed for service
    file { '/etc/jboss-as':
      ensure => directory,
      owner  => 'root',
      group  => 'root'
    }

    file { '/etc/jboss-as/jboss-as.conf':
      content => template("jbossas/${jbossas::version}/jboss-as.conf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
      require => File['/etc/jboss-as'],
    }

    if $jbossas::role == "slave" {
      file { "${jbossas::deploy_dir}/domain/configuration/host-slave.xml":
        content => template("jbossas/${jbossas::version}/host-slave.xml.erb"),
        owner   => 'root',
        group   => 'root',
        mode    => 0755,
        require => Exec['move_jboss_home'],
      }
    }

    file { '/var/run/jboss-as':
      ensure => directory,
      owner  => "$jbossas::jboss_user",
      group  => "$jbossas::jboss_group",
      mode   => 0775
    }

    file { "/etc/init.d/${jbossas::service_name}":
      content => template("jbossas/${jbossas::version}/jboss-as.sh.erb"),
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
      require => File["/etc/init.d/${jbossas::service_name}"],
    #      notify => Service['jbossas'],
    }

    # removal
  } else {
  }
}