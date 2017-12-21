class newrelic::uninstall::remove{
	if $operatingststem == 'Ubuntu'{
	 	 package{"newrelic-sysmond":
                	ensure => purged,
        	}
	}
}

