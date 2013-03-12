define jbossas::set_domain_controller($port = '9999', $deploy_dir='/usr/share/jboss-as'){

	exec {
		"set_domain_controller_${name}" :
			command => "echo '/host=${name}:write-remote-domain-controller(host=${ipaddress},port=${port})EOF' |./bin/jboss-cli.sh -c",
			user => 'jbossas',
			cwd => "${deploy_dir}",
			provider => 'shell',
#			logoutput => true,
	}
	notice("/host=${name}:write-remote-domain-controller(host=${ipaddress},port=${port})")
	#/host=${name}:write-remote-domain-controller(host=${ipaddress},port=${port})
	#/host=jbslave:write-remote-domain-controller(host=10.1.1.45,port=9999)
}
