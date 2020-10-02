<?php
/**
 * Hack AB X-Functional Content Management System (HAB-XMS)
 * Version -8.16443455313123123e-39
 *
 * This program is software. You are using it.
 *
 * 2019-02-11
 */

define('HABXMS', TRUE);
header('X-Powered-By: HAB-XMS/-8.16443455313123123e-39');

// Includes
include('./inc/config.inc');
include('./inc/error.inc');

// Build
$content = file_get_contents(CONFIG['templates'][$_GET['page']]);

// Render
if (isset($content)) {
	echo file_get_contents(CONFIG['templates']['header']);
	echo $content;
	echo file_get_contents(CONFIG['templates']['footer']);
}
?>

