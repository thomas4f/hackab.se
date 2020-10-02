<?php
if(defined('HABXMS')) {

	function administration() {
		$flags = json_decode(file_get_contents('/etc/opt/hab-flags.json'), TRUE);
		$htpasswd = file('/var/www/www.hackab.se/html/.htpasswd', FILE_IGNORE_NEW_LINES);
		foreach ($htpasswd as $key => $value) {
			$pieces = explode(':', $value);
			$users[$key]['username'] = $pieces[0];
			$users[$key]['hash'] = $pieces[1];
		}

		session_name('HAB_SESS');

		if (
			isset($_REQUEST['username']) &&
			is_string($_REQUEST['username']) &&
			isset($_REQUEST['password']) &&
			is_string($_REQUEST['password'])
		) {
			$key = array_search($_REQUEST['username'], array_column($users, 'username'));
			if ($users[$key]['username'] === $_REQUEST['username']) {
				if (password_verify($_REQUEST['password'], $users[$key]['hash'])) {

					// This is safe enough, right?
					$session_id = (isset($_REQUEST['session'])) ? trim($_REQUEST['session'], "\n") : rand(100,999);
					session_id(base64_encode('HAB_SESS-' . $session_id));
					session_start();

					$_SESSION['username'] = ucfirst(strtok($_REQUEST['username'], '@'));
					$_SESSION['uid'] = md5($_REQUEST['username']);
					setcookie('HAB_UID', $_SESSION['uid'], 0, '/');
					setcookie('HAB_ROLE', 'user', 0, '/');

					// Default account should be removed
					if ($_REQUEST['username'] === "admin") {
						session_destroy();
						return str_replace('{% FLAG %}', $flags['CLOSEBUTNOCIGAR']['flag'], file_get_contents('./tpl/administration-unacceptable.tpl'));
					} else {
						return str_replace("{% USERNAME %}", $_SESSION['username'], file_get_contents('./tpl/administration-acceptable.tpl'));
					}
				}
			} else {
				// Umm, to prevent brute force attacks ... I guess? :P
				usleep(750000);
			}

			return str_replace('{% STATUS %}', 'Inloggningen misslyckades.', file_get_contents('./tpl/administration.tpl'));

		} else if (isset($_COOKIE['HAB_SESS'])) {
			session_id($_COOKIE['HAB_SESS']);
			session_start();
			if ($_SESSION && $_SESSION['username']) {
				setcookie('HAB_UID', $_SESSION['uid'], 0, '/');
				return str_replace(array("{% USERNAME %}", "{% FLAG %}"), array($_SESSION['username'], $flags['WELCOMESUPERMANILOVEYOU']['flag']), file_get_contents('./tpl/administration-acceptable.tpl'));
			}

		}

		return str_replace('{% STATUS %}', 'Inloggning krävs.', file_get_contents('./tpl/administration.tpl'));
	}
}
?>
