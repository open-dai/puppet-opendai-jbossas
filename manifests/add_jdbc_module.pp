define jbossas::add_jdbc_module ($driver, $driver_url, $profile = 'ha') {
  # $module_path = ''
  case $name {
    mysql      : {
      $module_path = 'com/mysql/main/'
      $cli_command = "/profile=${profile}/subsystem=datasources/jdbc-driver=mysql:add(driver-name=\"mysql\",driver-module-name=\"com.mysql\",driver-class-name=\"com.mysql.jdbc.Driver\")"

      file { ["${jbossas::deploy_module_dir}com/mysql", "${jbossas::deploy_module_dir}com/mysql/main"]:
        ensure => "directory",
        owner  => $jbossas::jboss_user,
        group  => $jbossas::jboss_group,
      }
    }
    postgresql : {
      $module_path = 'org/postgresql/main/'
      $cli_command = "/profile=${profile}/subsystem=datasources/jdbc-driver=postgresql:add(driver-name=\"postgresql\",driver-module-name=\"org.postgresql\",driver-class-name=\"org.postgresql.Driver\")"

      file { ["${jbossas::deploy_module_dir}org/postgresql", "${jbossas::deploy_module_dir}org/postgresql/main"]:
        ensure => "directory",
        owner  => $jbossas::jboss_user,
        group  => $jbossas::jboss_group,
      }
    }
    oracle     : {
      $module_path = 'com/oracle/main/'
      $cli_command = "/profile=${profile}/subsystem=datasources/jdbc-driver=oracle:add(driver-name=\"oracle\",driver-module-name=\"com.oracle\",driver-class-name=\"oracle.jdbc.driver.OracleDriver\")"

      file { ["${jbossas::deploy_module_dir}com/oracle", "${jbossas::deploy_module_dir}com/oracle/main"]:
        ensure => "directory",
        owner  => $jbossas::jboss_user,
        group  => $jbossas::jboss_group,
      }
    }
    default    : {
      $module_path = ''
    }

  }

  file { "${jbossas::deploy_module_dir}${module_path}module.xml":
    owner   => $jbossas::jboss_user,
    group   => $jbossas::jboss_group,
    content => template("jbossas/datasources/modules/${module_path}module.xml.erb"),
    require => File["${jbossas::deploy_module_dir}${module_path}"],
  }

  # Install MySQL driver
  #  $mysql_file = 'mysql-connector-java-5.1.22-bin.jar'

  exec { "download_${name}_driver":
    command   => "/usr/bin/curl -v --progress-bar -o '${jbossas::deploy_module_dir}${module_path}${driver}' '${driver_url}${driver}'",
    creates   => "${jbossas::deploy_module_dir}${module_path}${driver}",
    user      => 'jbossas',
    #    cwd       => "${jbossas::deploy_dir}/modules/${module_path}",
    logoutput => true,
    require   => [Package['curl'], File["${jbossas::deploy_module_dir}${module_path}module.xml"]],
  }

  jbossas::run_cli_command { "deploy_${name}_${profile}_driver":
    command        => $cli_command,
    unless_command => "\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"profile\":\"${profile}\"},{\"subsystem\":\"datasources\"},{\"jdbc-driver\":\"${name}\"}]",
    require        => [Exec["download_${name}_driver"]],
  }
}
