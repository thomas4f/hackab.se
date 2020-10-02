<?php
if(defined('HABXMS')) {

	function error() {
		$error = array(
			'timestamp' => date('c'),
			'error_message' => ERROR,
			'cwd' => getcwd(),
			'config' => CONFIG
		);

		http_response_code(500);
		return file_get_contents('./tpl/error.tpl');
	}
}
?>