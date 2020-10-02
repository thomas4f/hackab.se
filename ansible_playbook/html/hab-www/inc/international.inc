<?php
if(defined('HABXMS')) {

	function international($ip) {
		$flags = json_decode(file_get_contents('/etc/opt/hab-flags.json'), TRUE);
		$flag = $flags['GLOBETROTTER']['flag'];

		if (
			in_array(geoip_continent_code_by_name($ip), CONFIG['int_regions']) ||
			in_array($ip, CONFIG['int_regions'])
		) {
			return str_replace('{% FLAG %}', $flag, file_get_contents('./tpl/international.tpl'));
		} else {
			return file_get_contents('./tpl/international-unacceptable.tpl');
		}
	}
}
?>
