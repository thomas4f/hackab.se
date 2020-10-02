<?php
function files() {
	$files = array_values(array_diff(scandir('../files'), array('.', '..')));
	if (
		isset($_GET['id']) &&
		is_string($_GET['id']) &&
		array_key_exists($_GET['id'], $files)
	) {
		$file = '../files/' . $files[$_GET['id']];
		header('Content-Description: File Transfer');
		header('Content-Type: ' . mime_content_type($file));
		header('Content-Disposition: attachment; filename="' . basename($file) . '"');
		header('Content-Length: ' . filesize($file));
		readfile($file);
		exit;
	} else {
		header('Location: /not-found'); 
	}
}
files()
?>