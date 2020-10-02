<?php
function admin_status() {
	$flags = json_decode(file_get_contents('/etc/opt/hab-flags.json'), TRUE);
	$flag = $flags['ROBAC']['flag'];

	session_name('HAB_SESS');
	session_id($_COOKIE['HAB_SESS']);
	session_start();

	if (
		isset($_COOKIE['HAB_SESS']) &&
		isset($_COOKIE['HAB_ROLE']) &&
		$_COOKIE['HAB_ROLE'] === 'admin' &&
		$_SESSION && $_SESSION['username']
	) {
		$df = preg_split('/\s+/', exec('df -lT | grep "^/dev/"'));
		$status['df'] = array(
			'filesystem' => $df[0],
			'type' => $df[1],
			'size' => round($df[2] / pow(1024, 2),2),
			'used' => round($df[3] / pow(1024, 2),2),
			'avail' => round($df[4] / pow(1024, 2),2),
			'use' => strtok($df[5], '%')
		);

		$free = preg_split('/\s+/', exec('free | grep "^Mem:"'));
		$status['free'] = array(
			'total' => round($free[1] / pow(1024, 1),0),
			'used' => round($free[2] / pow(1024, 1),0),
			'free' => round($free[3] / pow(1024, 1),0),
			'shared' => round($free[4] / pow(1024, 1),0),
			'cached' => round($free[5] / pow(1024, 1),0),
			'avail' => round($free[6] / pow(1024, 1),0),
			'use' => round(($free[2] + $free[5]) / $free[1] * 100)
		);

		$num_cpus = exec('grep -c ^processor /proc/cpuinfo');
		$load = preg_split('/\s+/', file_get_contents('/proc/loadavg'));
		$status['load'] = array(
			'one' => $load[0],
			'five' => $load[1],
			'fifteen' => $load[2],
			'num_cpus' => $num_cpus
		);

		$interface = exec('route | grep "^default" | awk \'{print $8}\'');
		$net = preg_split('/\s+/', exec("grep $interface /proc/net/dev"));
		$status['net'] = array(
			'interface' => strtok($net[0], ':'),
			'rx_mib' => round($net[2] / pow(1024, 2),0),
			'rx_packets' => $net[3],
			'tx_mib' => round($net[10] / pow(1024, 2),0),
			'tx_packets' => $net[11],
		);

		$status['flag'] = $flag;

		return json_encode($status, JSON_NUMERIC_CHECK);
	} else {
		header('Location: /forbidden');
		return "[]";
	}
}
header('Content-Type: application/json');
echo admin_status();
?>
