<?php
if(defined('HABXMS')) {

	function config() {
		$flags = json_decode(file_get_contents('/etc/opt/hab-flags.json'), TRUE);
		$flag = $flags['CWE209']['flag'];

		define('CONFIG', array(
			'flag' => $flag,
			'waf_enabled' => TRUE,
			'templates' => array(
				'header' => './tpl/header.tpl',
				'footer' => './tpl/footer.tpl',
				'hem' => './tpl/home.tpl',
				'om-oss' => './tpl/about-us.tpl',
				'aktuellt' => './tpl/news.tpl',
				'om-cookies' => './tpl/cookies.tpl',
				'international' => './tpl/international.tpl',
				'administration' => './tpl/administration.tpl',
				'tjanster' => './tpl/services.tpl',
				'medarbetare-thomas' => './tpl/employee-thomas.tpl',
				'medarbetare-erik' => './tpl/employee-erik.tpl',
				'backup-flag' => './tpl/flag-backup.tpl',
				'forbidden' => './tpl/forbidden.tpl',
				'not-found' => './tpl/not-found.tpl'
			),
			'int_regions' => array(
				'NA',
				'SA',
				'AS',
				'OC',
				'127.0.0.1'
			)
		));
	}
	config();
}
?>
