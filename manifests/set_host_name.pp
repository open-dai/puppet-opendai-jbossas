define jbossas::set_host_name($oldname = 'master', $newname = 'public', $deploy_dir='/usr/share/jboss-as'){

	exec {
		"set_host_name_${name}" :
			command => "echo '/host=${oldname}:write-attribute(name=name,value=${newname})EOF' |./bin/jboss-cli.sh -c",
			user => 'jbossas',
			cwd => "${deploy_dir}",
			provider => 'shell',
#			logoutput => true,
	}
	notice("/host=${oldname}:write-attribute(name=name,value=${newname})")
	#/host=pippo:write-attribute(name=name,value=jbmaster)
	#/host=${oldname}:write-attribute(name=name,value=${newname})
}
