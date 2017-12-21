class newrelic(
	$install = 'undef',
	$key = 'undef',
	$location = 'undef',	
	$uninstall = 'undef',
	$app_name = 'undef',	
){
	if $install == 'yes'{
		class{"newrelic::install::add":
			nr_key => $key,
			nr_location => $location,
		}
	}
	if $uninstall == 'yes'{
		include newrelic::uninstall::remove
	}
}
