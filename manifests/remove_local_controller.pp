define jbossas::remove_local_controller($deploy_dir='/usr/share/jboss-as'){

	exec {
		"remove_local_controller_${name}" :
			command => "echo '/host=${name}:remove-local-domain-controller()EOF' |./bin/jboss-cli.sh -c",
			user => 'jbossas',
			cwd => "${deploy_dir}",
			provider => 'shell',
#			logoutput => true,
	}
	notice("/host=${name}:remove-local-domain-controller()")
	#/host=jbslave:remove-local-domain-controller
	#/host=${name}:remove-local-domain-controller
}
