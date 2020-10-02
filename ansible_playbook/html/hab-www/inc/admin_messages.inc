<?php
function admin_messages() {
	$htpasswd = file('/var/www/www.hackab.se/html/.htpasswd', FILE_IGNORE_NEW_LINES);
	foreach ($htpasswd as $key => $value) {
		$users[md5(strtok($value, ':'))] = strtok($value, '@');
	}

	// TODO: I forgot what it was ...
	if (
		isset($_GET['uid']) &&
		is_string($_GET['uid']) &&
		array_key_exists($_GET['uid'], $users) &&
		is_file('/var/mail/' . $users[$_GET['uid']])
	) {
		$lines = file('/var/mail/' . $users[$_GET['uid']]);

		// Best code ever!
		$i = 0;
		foreach ($lines as $line) {
			if (preg_match('/^From\ /', $line)) {
				$i++;
			}
			$tmp[$i][] = trim($line);
		}

		$search = array('=C3=A5', '=C3=A4', '=C3=B6', '=C3=85', '=C3=84', '=C3=96', '=20');
		$replace = array('å', 'ä', 'ö', 'Å', 'Ä', 'Ö', ' ');

		$i = 0;
		foreach ($tmp as $message) {
			if (!empty($message[0])) {
				$message = implode("\n", $message);
				preg_match('/^id (.*?);.*\n^Date: (.*?)\n^To: (.*?)\n^Subject: (.*?)\n^User-Agent: (.*?)\n^Message-Id: (.*?)\n^From: (.*?)\n(.*)/sm', $message, $matches);

				$messages[$i]['id'] =  $matches[1];
				$messages[$i]['date'] =  date ("Y-m-d H:i", strtotime($matches[2]));
				$messages[$i]['to'] =  $matches[3];
				$messages[$i]['subject'] =  $matches[4];
				$messages[$i]['from'] =  $matches[7];
				$messages[$i]['body'] =  htmlentities(str_replace($search, $replace, $matches[8]));
				$messages[$i]['message'] =  htmlentities(str_replace($search, $replace, $message));
				$i++;
			}
		}
		return json_encode(array_reverse($messages));
	} else {
		return "[]";
	}
}
header('Content-Type: application/json');
echo admin_messages();
?>
