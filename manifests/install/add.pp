class newrelic::install::add(
	$nr_key = 'undef',
	$nr_location = 'undef',
){
	if $operatingsystem == 'Ubuntu'{
		exec{"add_new_relic_repo":
			command => "/bin/echo deb http://apt.newrelic.com/debian/ newrelic non-free | sudo tee /etc/apt/sources.list.d/newrelic.list",
		}->
		exec{"trst_newrelic_key":
			command => "/usr/bin/wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -",
		}->
		exec{"yum_update":
			command => "/usr/bin/apt-get update",
		}->
		package{"newrelic-sysmond":
			ensure => installed,
			require  => Exec['yum_update'],
		}->
		exec{"$nr_key":
                        command => "/usr/sbin/nrsysmond-config --set license_key=$nr_key",
                }->
                service{"newrelic-sysmond":
                        ensure => running,
                }

	}
	if $operatingsystem == 'windows'{
		file{"${nr_location}":
			ensure => directory,
		}->
		file{"${nr_location}/newrelicdotnetagent.msi":
			ensure => present,
			source => 'puppet:///modules/newrelic/newrelicdotnetagent.msi',
			source_permissions => ignore,
		}->
		package{"newrelic":
            		ensure => installed,
            		source => "${nr_location}/newrelicdotnetagent.msi",
			provider => "windows",
		}->
		file{"C:/ProgramData/New Relic/.NET Agent/newrelic.config":
			ensure => present,
			replace => yes,
			content => template('newrelic/newrelic.config.windows.erb'),
		}
	}
}
