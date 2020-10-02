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

get_flags = function(response) {
	var response = JSON.parse(response);
	var tbody = '';

	for (var flag of response.flags) {
		var css = flag.solved ? 'siimple-table-row--success' : '';
		var categories = '';

		for (category of flag.categories.split(' ')) {
			categories += '<span class="HAB-tag siimple-tag siimple-tag--light">' + category + '</span>'
		}

		tbody += '<tr id="flag' + flag.id + '" class="siimple-table-row ' + css + '">	\
		<td class="siimple-table-cell">' + flag.id + '</td>								\
		<td class="siimple-table-cell">' + flag.title + '</td>							\
		<td class="siimple-table-cell">' + categories + '</td> 							\
		<td class="siimple-table-cell points">' + flag.points + '</td>					\
		<td class="siimple-table-cell solvers">' + flag.solvers + '</td></tr>';
	}

	document.getElementById("flags").innerHTML = tbody;
	
	if (response.username && response.uuid) {
		document.getElementById('account-logged-in-username').innerText = response.username;
		document.getElementById('account-logged-in-input').value = response.uuid;
		toggle_cards('account-logged-in-card');
	} else {
		toggle_cards('account-logged-out-card');
	}

	update_points();
}

submit_flags = function(response) {
	var response = JSON.parse(response);
	
	for (var flag of response.flags) {
		document.getElementById('flag' + flag.id).classList.add('siimple-table-row--success');
	}

	document.getElementById('flag-msg').classList.remove('siimple--display-none');
	document.getElementById('flag-msg').innerHTML = response.flags.length + ' accepterade flagga/flaggor.';
	setTimeout(function(){
		document.getElementById('flag-msg').classList.add('siimple--display-none');
    }, 5000);

	update_points();
}

submit_account = function(response) {
	var response = JSON.parse(response);
	if (response.action == 'get_username') {
		document.getElementById('account-create-input').value = response.username[0] + ' ' + response.username[1];
		toggle_cards('account-create-card');
	} else if (response.action == 'create_account') {
		document.getElementById('account-confirm-username').innerText = response.username[0] + ' ' + response.username[1];
		document.getElementById('account-confirm-input').value = response.uuid;
		toggle_cards('account-confirm-card');
	} else if (response.action == 'login') {
		if (response.username && response.uuid) {
			window.location.replace("/");
		} else {
			document.getElementById('account-logged-out-failure').classList.remove('siimple--display-none');
			document.getElementById('account-logged-out-message').classList.add('siimple--display-none');
			setTimeout(function(){
				document.getElementById('account-logged-out-message').classList.remove('siimple--display-none');
				document.getElementById('account-logged-out-failure').classList.add('siimple--display-none');
    		}, 2500);
		}
	} else if (response.action == 'logout') {
		window.location.replace("/");
	}
}

toggle_cards = function(id) {
	var e = document.getElementsByClassName("toggleable");
	for(var i = 0; i < e.length; i++) {
		if (id == e.item(i).id) {
			document.getElementById(e.item(i).id).classList.remove('siimple--display-none');
		} else {
			document.getElementById(e.item(i).id).classList.add('siimple--display-none');
		}
	}
}

// Don't look at this! TOTALLY not an afterthought :P
update_points = function() {
	var points = 0;
	var e = document.getElementsByClassName("points");
	for(var i = 0; i < e.length; i++) {
		var p = e.item(i).innerText;
		if (e.item(i).parentElement.classList.contains('siimple-table-row--success')) {
			points = points + parseInt(p);
		}
	}

	document.getElementById('account-logged-in-points').innerText = points;
}

document.addEventListener('DOMContentLoaded', function() {
	xhr('GET', './?get_flags', null, get_flags);

	document.getElementById("flagsubmit").addEventListener("click", function(e){
		e.preventDefault();
		var payload = new FormData(document.querySelector('form[data-form="flags"]'));
		xhr('POST', './?submit_flag', payload, submit_flags);
	});

	document.getElementById("account-logged-out-submit").addEventListener("click", function(e){
		e.preventDefault();
		var payload = new FormData(document.querySelector('form[data-form="login-form"]'));
		xhr('POST', './?login', payload, submit_account);
	});

	document.getElementById("account-logged-out-create").addEventListener("click", function(e){
		e.preventDefault();
		xhr('GET', './?get_username', null, submit_account);
	});

	document.getElementById("account-create-regenerate").addEventListener("click", function(e){
		e.preventDefault();
		xhr('GET', './?get_username', null, submit_account);
	});

	document.getElementById("account-create-cancel").addEventListener("click", function(e){
		e.preventDefault();
		toggle_cards('account-logged-out-card');
	});

	document.getElementById("account-create-button").addEventListener("click", function(e){
		e.preventDefault();
		xhr('GET', './?create_account', null, submit_account);
	});

	document.getElementById("account-confirm-login").addEventListener("click", function(e){
		e.preventDefault();
		toggle_cards('account-logged-out-card')
	});

	document.getElementById("account-logged-in-logout").addEventListener("click", function(e){
		e.preventDefault();
		xhr('GET', './?logout', null, submit_account);
	});

	document.getElementById("account-logged-in-toggle").addEventListener("click", function(e){
		e.preventDefault();
		if (document.getElementById('account-logged-in-input').type == 'password') {
			document.getElementById('account-logged-in-input').type = 'text';
		} else if (document.getElementById('account-logged-in-input').type == 'text') {
			document.getElementById('account-logged-in-input').type = 'password';
		}
	});
});
