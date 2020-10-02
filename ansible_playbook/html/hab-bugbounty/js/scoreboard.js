xhr = function(method, url, payload, callback) {
	var request = new XMLHttpRequest();
	request.onreadystatechange = function() {
		if (request.readyState === 4 && request.status === 200) {
			callback(request.response);
		}
	};

	request.open(method, url);
	request.send(payload);
}

get_scoreboard = function(response) {
	var response = JSON.parse(response);
	var tbody = '';

	if (response.length > 0) {
		for(var i = 0; i < response.length; i++) {
			var pos = i + 1;

			tbody += '<tr class="siimple-table-row">											\
			<td class="siimple-table-cell">' + pos + '</td>										\
			<td class="siimple-table-cell siimple--text-bold">' + response[i].username + '</td>	\
			<td class="siimple-table-cell">' + response[i].points + '</td>						\
			<td class="siimple-table-cell points">' + response[i].solved + '</td></tr>';

		}
	} else {
		tbody = '<tr><td class="siimple--text-center siimple--text-italic" colspan="5">Inga flaggor har skickats in!</td></tr>';
	}

	document.getElementById("scoreboard").innerHTML = tbody;
}

document.addEventListener('DOMContentLoaded', function() {
	xhr('GET', './?get_scoreboard', null, get_scoreboard);
	setInterval(function(){ 
    	xhr('GET', './?get_scoreboard', null, get_scoreboard);
	}, 30000);
});
