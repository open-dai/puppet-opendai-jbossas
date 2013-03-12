define jbossas::add_user($password='mypass', $deploy_dir='/usr/share/jboss-as', $mode='standalone' ) {

	exec {
		"add_jboss_user_${name}" :
			command =>
			"${deploy_dir}/bin/add-user.sh --silent=true ${name} ${password}",
			user => 'jbossas',
			cwd => "${deploy_dir}",
			provider => 'shell',
			unless => "grep ${name} ${deploy_dir}/${mode}/configuration/mgmt-users.properties |grep -v '^#'"
	}
}