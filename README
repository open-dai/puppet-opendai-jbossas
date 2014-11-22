This is the jbossas module to install a generoc JBoss AS software on a CentOS host

The usage to install the JBoss AS is done by including the class and specifying the URL where to download the ZIP file.
Supported version are:
* 7.1
* EAP6.1.alpha

It can be installed both in standalone and domain mode.

```
class { 'jbossas':
package_url => "http://$package_url/",
bind_address => $bind_address,
deploy_dir => $deploy_dir,
mode => $mode,
version => 'EAP6.1.a',
bind_address_management => $bind_address_management,
bind_address_unsecure => $bind_address_unsecure,
domain_master_address => $::ipaddress,
role => 'master',
admin_user => $admin_user,
admin_user_password => $admin_user_password,
require => [Class['opendai_java'], Package['unzip']],
}
```

This module also allows to install TEIID module inside the JBoss Installation
```
jbossas::install_teiid_domain { "teiid-server-group":
version => '8.5',
}
```
