<?php
/**
 * Hack AB X-Functional Content Management System (HAB-XMS)
 * Version 0.76797644327475
 *
 * This program is software. You are using it.
 * {% FLAG %}
 *
 * 2019-02-11
 */

define('HABXMS', TRUE);
header('X-Powered-By: HAB-XMS/0.76797644327475');

// Includes
include('./inc/config.inc');
include('./inc/error.inc');
include('./inc/international.inc');
include('./inc/administration.inc');

// HAB-WAF (mod_security / OWASP CRS is hard)
if (CONFIG['waf_enabled'] && (
	preg_match('/[^\w\/\-\?\&\=\.\@]/', $_SERVER['REQUEST_URI']) ||
	!isset($_GET['page']) ||
	!is_string($_GET['page']) ||
	!array_key_exists($_GET['page'], CONFIG['templates']) ||
	!file_exists(CONFIG['templates'][$_GET['page']])
)) {
	define('ERROR', 'POTENTIALLY_DANGEROUS_REQUEST');
}

// Build
if (defined('ERROR')) {
	$content = error();
} else if ($_GET['page'] === 'international') {
	$content = international($_SERVER['REMOTE_ADDR']);
} else if ($_GET['page'] === 'administration') {
	$content = administration();
} else {
	$content = file_get_contents(CONFIG['templates'][$_GET['page']]);
}

// Render
if (isset($content)) {
	echo file_get_contents(CONFIG['templates']['header']);
	echo $content;
	echo file_get_contents(CONFIG['templates']['footer']);
}
?>
