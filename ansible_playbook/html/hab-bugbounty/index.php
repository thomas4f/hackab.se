<?php

/**
 * This was made in a hurry.
 * Hopefully most of it works!
 */

$config = array (
	'db' => '/var/www/bugbounty.hackab.se/db/db.sq3',
	'usernames' => '/etc/opt/hab-usernames.json',
	'flags' => '/etc/opt/hab-flags.json',
	'reg_open' => TRUE
);

include('./inc/db.php');
$db = new DB($config);

session_start();
$_SESSION['username'] = isset($_SESSION['username']) ? $_SESSION['username'] : NULL;
$_SESSION['uuid'] = isset($_SESSION['uuid']) ? $_SESSION['uuid'] : NULL;

function destroy() {
	setcookie('PHPSESSID', '', time() - 86400);
	$_SESSION = array();
	session_destroy();
}

// get user (or guest) flags
if (isset($_GET['get_flags'])) {
	if (!$flags = $db->get_flags($_SESSION['uuid'])) {
		$flags = array();
	}

	header('Content-Type: application/json');
	echo json_encode(array('username' => $_SESSION['username'], 'uuid' => $_SESSION['uuid'], 'flags' => $flags), JSON_NUMERIC_CHECK);

// submit flags
} else if (isset($_GET['submit_flag'])) {
	if (preg_match_all('/(HABFLAG{[A-Fa-f0-9]{64}})/', str_replace("\x0d\x0a", '', $_POST['flags']), $matches)) {
		foreach ($matches[1] as $match) {
			if ($result = $db->submit_flag($_SESSION['uuid'], $match)) {
				$flags[] = $result;
			}
		}
	} else {
		$flags = array();
	}

	header('Content-Type: application/json');
	echo json_encode(array('action' => 'submit_flag', 'username' => $_SESSION['username'], 'uuid' => $_SESSION['uuid'], 'flags' => $flags), JSON_NUMERIC_CHECK);

// if no session, create left|right username combo and create session 
} else if (isset($_GET['get_username'])) {
	if (!isset($_SESSION['uuid'])) {
		if ($result = $db->get_username()) {
			$_SESSION['username'] = array($result[0]->string, $result[1]->string);
		}
	}

	header('Content-Type: application/json');
	echo json_encode(array('action' => 'get_username', 'username' => $_SESSION['username']), JSON_NUMERIC_CHECK);

// create account
} else if (isset($_GET['create_account'])) {
	if (isset($_SESSION['username']) && !isset($_SESSION['uuid'])) {
		$_SESSION['uuid'] = $db->get_uuid();
		if ($db->create_account($_SESSION["username"], $_SESSION['uuid'])) {
			echo json_encode(array('action' => 'create_account', 'username' => $_SESSION['username'], 'uuid' => $_SESSION['uuid']), JSON_NUMERIC_CHECK);
			destroy();
			return;
		}
	}

	header('Content-Type: application/json');
	echo json_encode(array('action' => 'create_account', 'username' => $_SESSION['username'], 'uuid' => $_SESSION['uuid']), JSON_NUMERIC_CHECK);

// login
} else if (isset($_GET['login'])) {
	if (isset($_POST['uuid']) && preg_match('/[A-Fa-f0-9]{32}/', $_POST['uuid']) && $user = $db->login($_POST['uuid'])) {
		$_SESSION["username"] = $user->username;
		$_SESSION["uuid"] = $user->uuid;
		$_SESSION["active"] = $user->active;
	}

	header('Content-Type: application/json');
	echo json_encode(array('action' => 'login', 'username' => $_SESSION['username'], 'uuid' => $_SESSION['uuid']), JSON_NUMERIC_CHECK);

// logout
} else if (isset($_GET['logout'])) {
	header('Content-Type: application/json');
	echo json_encode(array('action' => 'logout'), JSON_NUMERIC_CHECK);
	destroy();

// scoreboard xhr
} else if (isset($_GET['get_scoreboard'])) {
	if ($result = $db->get_scoreboard()) {
		unset($result['user_id']);
	} else {
		$result = array();
	}

	header('Content-Type: application/json');
	echo json_encode($result, JSON_NUMERIC_CHECK);

// scoreboard tpl
} else if (isset($_GET['poangtavla'])) {
	echo file_get_contents('./tpl/header.tpl') . file_get_contents('./tpl/scoreboard.tpl') . file_get_contents('./tpl/footer.tpl');

} else {
	echo file_get_contents('./tpl/header.tpl') . file_get_contents('./tpl/index.tpl') . file_get_contents('./tpl/footer.tpl');
}

?>
