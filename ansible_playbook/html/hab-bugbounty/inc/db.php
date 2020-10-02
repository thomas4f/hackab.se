<?php

/**
 * This was made in a hurry.
 * The SQL statements could probably be improved (especially the subqueries?).
 *
 * Clean up not active users and active users without submissions
 * DELETE FROM users WHERE id NOT IN (SELECT user_id FROM submissions) OR NOT active;
 * 
 * Clean up users older than one week and orphaned submissions
 * DELETE FROM users WHERE created < DATETIME('now','-1 week');
 * DELETE FROM submissions WHERE user_id NOT IN (SELECT id FROM users);
 */

class db {
	public function __construct($config) {
		$this->reg_open = $config['reg_open'];
		$this->db = $config['db'];
		$this->usernames = $config['usernames'];
		$this->flags = $config['flags'];

		if (!file_exists($this->db)) {
			file_put_contents($this->db, '');
			$this->init_db();
		} else {
			$this->dbh = new PDO('sqlite:' . $this->db);
			//$this->dbh->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING );
		}
	}

	public function get_flags($uuid = FALSE) {
		if (isset($uuid)) {
			$this->sth = $this->dbh->prepare("SELECT id, title, (SELECT created FROM submissions WHERE user_id = (SELECT id FROM users WHERE uuid = :uuid) AND flag_id = flags.id) as solved, categories, points, (SELECT COUNT(flag_id) FROM submissions WHERE flag_id = flags.id) AS solvers FROM flags ORDER BY id");
			if (!$this->sth->execute(array(':uuid' => $uuid))) {
				return FALSE;
			}
		} else {
			$this->sth = $this->dbh->prepare("SELECT id, title, categories, points, (SELECT COUNT(flag_id) FROM submissions WHERE flag_id = flags.id) AS solvers FROM flags ORDER BY id");
			if (!$this->sth->execute()) {
				return FALSE;
			}
		}

		return $this->sth->fetchAll(PDO::FETCH_OBJ);
	}

	public function submit_flag($uuid = FALSE, $flag) {
		if (isset($uuid)) {
			$this->sth = $this->dbh->prepare("INSERT OR IGNORE INTO submissions (user_id, flag_id, created) VALUES ((SELECT id from users WHERE uuid = :uuid), (SELECT id from flags WHERE flag = :flag), DATETIME())");
			if (!$this->sth->execute(array(':uuid' => $uuid, ':flag' => $flag))) {
				return FALSE;
			}
		}

		$this->sth = $this->dbh->prepare("SELECT id, title, points FROM flags WHERE flag = :flag");
		if ($this->sth->execute(array(':flag' => $flag))) {
			return $this->sth->fetch(PDO::FETCH_OBJ);
		}
	}

	public function login($uuid) {
		$this->sth = $this->dbh->prepare("SELECT username, uuid, IFNULL(active, DATETIME()) AS active FROM users WHERE uuid = :uuid");
		$this->sth->execute(array(':uuid' => $uuid));
		if ($result = $this->sth->fetch(PDO::FETCH_OBJ)) {
			$this->sth = $this->dbh->prepare("UPDATE users SET active = DATETIME() WHERE uuid = :uuid");
			if ($this->sth->execute(array(':uuid' => $uuid))) {
				return $result;
			}
		}
	}

	public function get_username() {
		$this->sth = $this->dbh->prepare("SELECT * FROM (SELECT column, string, count FROM usernames WHERE column = 0 ORDER BY count ASC, RANDOM() LIMIT 1) UNION SELECT * FROM (SELECT column, string, count FROM usernames WHERE column = 1 ORDER BY count ASC, RANDOM() LIMIT 1) ORDER BY column");
		if ($this->sth->execute()) {
			return $this->sth->fetchAll(PDO::FETCH_OBJ);
		}
	}

	public function get_uuid() {
		// Could check for collission here ...
		return strtoupper(hash('sha1', uniqid(time(), TRUE)));
	}

	public function create_account(array $username, $uuid) {
		if(!$this->reg_open) {
			return FALSE;
		}

		$this->sth = $this->dbh->prepare("INSERT INTO users (username, uuid, created) VALUES (:username, :uuid, DATETIME())");
		if ($this->sth->execute(array(':username' => implode(" ", $username), ':uuid' => $uuid))) {

			foreach ($username as $column => $string) {
				$this->sth = $this->dbh->prepare("UPDATE usernames SET count = count + 1 WHERE column = :column AND string = :string");
				if (!$this->sth->execute(array(':column' => $column, ':string' => $string))) {
					return FALSE;
				}
			}

			return TRUE;
		}
	}

	public function get_scoreboard() {
		$this->sth = $this->dbh->prepare("SELECT users.username, SUM(flags.points) AS points, COUNT(submissions.flag_id) as solved FROM submissions JOIN users ON submissions.user_id=users.id JOIN flags ON submissions.flag_id=flags.id GROUP BY users.id ORDER BY points DESC");
		$this->sth->execute();

		return $this->sth->fetchAll(PDO::FETCH_OBJ);
	}

	private function init_db() {
		$this->dbh = new PDO('sqlite:' . $this->db);

		// users
		$this->sth = $this->dbh->prepare("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, uuid TEXT UNIQUE NOT NULL, event TEXT, created INTEGER, active INTEGER)");
		$this->sth->execute();

		// usernames
		$usernames = array_values(json_decode(file_get_contents($this->usernames), true));
		$this->sth = $this->dbh->prepare("CREATE TABLE IF NOT EXISTS usernames (id INTEGER PRIMARY KEY, column TEXT, string TEXT UNIQUE, count INTEGER)");
		$this->sth->execute();

		foreach ($usernames as $username) {
			$this->sth = $this->dbh->prepare("INSERT OR IGNORE INTO usernames (column, string, count) VALUES (:column, :string, 0)");
			$this->sth->execute(array(':column' => $username['column'], ':string' => $username['string']));
		}

		// flags
		$flags = array_values(json_decode(file_get_contents($this->flags), true));
		$this->sth = $this->dbh->prepare("CREATE TABLE IF NOT EXISTS flags (id INTEGER PRIMARY KEY, title TEXT UNIQUE, points INTEGER, flag STRING UNIQUE, categories TEXT)");
		$this->sth->execute();

		foreach ($flags as $flag) {
			$this->sth = $this->dbh->prepare("INSERT OR IGNORE INTO flags (title, points, flag, categories) VALUES (:title, :points, :flag, :categories)");
			$this->sth->execute(array(':title' => $flag['title'], ':points' => $flag['points'], ':flag' => $flag['flag'], 'categories' => implode(' ', $flag['categories'])));
		}

		// submissions
		$this->sth = $this->dbh->prepare("CREATE TABLE IF NOT EXISTS submissions (id INTEGER PRIMARY KEY, user_id INTEGER NOT NULL, flag_id INTEGER NOT NULL, created INTEGER, UNIQUE (user_id, flag_id) ON CONFLICT IGNORE)");
		$this->sth->execute();
	}
}
