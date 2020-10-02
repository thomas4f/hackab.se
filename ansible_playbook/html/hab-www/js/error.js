document.addEventListener('DOMContentLoaded', function() {
	var error = JSON.parse(document.getElementById('error').innerHTML);

	if('debug' in sessionStorage){
		document.getElementById('error').innerText = JSON.stringify(error, null, 2)
	} else {
		document.getElementById('error').innerText = error.timestamp + '\n' + error.error_message;
	}
});