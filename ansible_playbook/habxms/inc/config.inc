<?php
if(defined('HABXMS')) {

	function config() {
		define('CONFIG', array(
			'templates' => array(
				'header' => './tpl/header.tpl',
				'footer' => './tpl/footer.tpl',
				'hem' => './tpl/home.tpl',
				'privat' => './tpl/private.tpl',				
				'forbidden' => './tpl/forbidden.tpl',
				'not-found' => './tpl/not-found.tpl'
			)
		));
	}
	config();
}
?>