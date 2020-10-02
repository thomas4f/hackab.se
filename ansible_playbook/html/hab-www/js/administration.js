cookie = function(name) {
	var match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
	if (match) return match[2];
}

xhr = function(method, url, callback) {
	var request = new XMLHttpRequest();
	request.onreadystatechange = function() {
		if (request.readyState === 4 && request.status === 200) {
			callback(request.response);
		}
	};
	request.open(method, url);
	request.send();
}

messages = function(response) {
	var tbody = '';
	window.HAB_MSG = {};
	var response = JSON.parse(response);
	for (var message of response) {
		window.HAB_MSG[message.id] = message;
		tbody += '<tr id="' + message.id + '" class="HAB-admin-messages siimple-table-row">	\
		<td class="siimple-table-cell">' + message.from + '</td>							\
		<td class="siimple-table-cell">' + message.subject + '</td>							\
		<td class="siimple-table-cell">' + message.date + '</td></tr>';
	}
	document.getElementById("messages").innerHTML = tbody;
}

serverstatus = function(response) {
	var response = JSON.parse(response);
	document.getElementById('df_use').classList.add('HAB-p' + response.df.use);
	document.getElementById('df_used').innerText = response.df.used;
	document.getElementById('df_avail').innerText = response.df.avail;
	document.getElementById('df_filesystem').innerText = response.df.filesystem;
	document.getElementById('df_type').innerText = response.df.type;

	document.getElementById('free_use').classList.add('HAB-p' + response.free.use);
	document.getElementById('free_used_cached').innerText = response.free.used + response.free.cached;
	document.getElementById('free_total').innerText = response.free.total;
	document.getElementById('free_cached').innerText = response.free.cached;

	document.getElementById('load_five').classList.add('HAB-p' + Math.round(response.load.five * 100 / response.load.num_cpus));
	document.getElementById('load_one_int').innerText = response.load.one;
	document.getElementById('load_five_int').innerText = response.load.five;
	document.getElementById('load_fifteen_int').innerText = response.load.fifteen;

	document.getElementById('net_rx_mib').innerText = response.net.rx_mib;
	document.getElementById('net_rx_packets').innerText = response.net.rx_packets;
	document.getElementById('net_tx_mib').innerText = response.net.tx_mib;
	document.getElementById('net_tx_packets').innerText = response.net.tx_packets;

	document.getElementById('status_flag').innerText = response.flag;

	document.getElementById('server_status').classList.remove('siimple--display-none');

}

tabs = function(active) {
	var elements = [
		['modal-tab-1','modal-message'],
		['modal-tab-2','modal-original']
	];

	for (var element in elements) {
		if (elements[element][0] == active) {
			document.getElementById(elements[element][0]).classList.add('siimple-tabs-item--selected');
			document.getElementById(elements[element][1]).classList.remove('siimple--display-none');
		} else {
			document.getElementById(elements[element][0]).classList.remove('siimple-tabs-item--selected');
			document.getElementById(elements[element][1]).classList.add('siimple--display-none');
		}
	}
}

// message list
document.getElementById("messages").addEventListener("click", function(e){
	var active = document.querySelector('#messages .active');
	if(active) active.classList.remove('siimple-table-row--primary', 'active');
	document.getElementById(e.target.parentElement.id).classList.add('siimple-table-row--primary', 'active');

	document.getElementById("modal-title").innerHTML = HAB_MSG[e.target.parentElement.id]['subject'];
	document.getElementById("modal-message").innerHTML = HAB_MSG[e.target.parentElement.id]['body'];
	document.getElementById("modal-original").innerHTML = HAB_MSG[e.target.parentElement.id]['message'];
	document.getElementById("modal").classList.remove('siimple--display-none');
});

// modal
document.getElementById("modal-tab-1").addEventListener("click", function(e){
	tabs(this.id);
});

document.getElementById("modal-tab-2").addEventListener("click", function(e){
	tabs(this.id);
});

document.getElementById('modal-close').addEventListener("click", function () {
	document.getElementById('modal').classList.add('siimple--display-none');
});

// xhr
document.addEventListener('DOMContentLoaded', function() {
	xhr('GET', '/administration/messages?uid=' + cookie('HAB_UID'), messages);

	if (cookie('HAB_ROLE') === 'admin') {
		xhr('GET', '/administration/status', serverstatus);
	}
});


