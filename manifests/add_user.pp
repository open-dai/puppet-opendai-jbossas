define jbossas::add_user ($password = 'mypass!1') {
  if ($jbossas::version == '7.1.1') {
    $command = "${jbossas::deploy_dir}/bin/add-user.sh --silent=true ${name} ${password}"
  } else {
    $command = "${jbossas::deploy_dir}/bin/add-user.sh --silent=true -u ${name} -p ${password}"
  }

  exec { "add_jboss_user_${name}":
    command  => $command,
    user     => "${jbossas::jboss_user}",
    cwd      => "${jbossas::deploy_dir}",
    provider => 'shell',
    unless   => "grep ${name} ${jbossas::deploy_dir}/${jbossas::mode}/configuration/mgmt-users.properties |grep -v '^#'"
  }
}