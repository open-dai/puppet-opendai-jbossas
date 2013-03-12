define jbossas::mod_host_interface($jbhost_name = 'master', $interface = 'public', $deploy_dir='/usr/share/jboss-as'){
	case $interface {
      public: { $bind = "" }
      management: { $bind = "management" }
	  unsecure: { $bind = "unsecure" }
      default: { fail("Unrecognized host interface for JBoss") }
    }

	exec {
		"mod_host_interface_${name}" :
			command => "echo '/host=${jbhost_name}/interface=${interface}:write-attribute(name=inet-address,value=\${jboss.bind.address.${bind}:${ipaddress}})EOF' |./bin/jboss-cli.sh -c",
			user => 'jbossas',
			cwd => "${deploy_dir}",
			provider => 'shell',
#			logoutput => true,
	}
	notice("/host=${jbhost_name}/interface=${interface}:write-attribute(name=inet-address,value=\${jboss.bind.address.${bind}:${ipaddress}})")
	#/host=jbmaster/interface=management:write-attribute(name=inet-address,value=${jboss.bind.address.management:10.1.1.45})
	#/host=${jbhost_name}/interface=${interface}:write-attribute(name=inet-address,value=${jboss.bind.address.${bind}:${ipaddress}})
}
