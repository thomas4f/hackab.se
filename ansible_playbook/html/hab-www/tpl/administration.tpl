<!-- CONTENT -->
<div class="siimple-content siimple-content--extra-large HAB-content-flex">
	<div class="siimple-h1">Administration</div>
	<p class="siimple-p">Internt administrationsverktyg för hackab.se.</p>

	<p class="siimple-p siimple-tip siimple-tip--warning siimple--display-inline">{% STATUS %}</p>

	<form action="" method="POST">
		<label class="siimple-label siimple--display-block siimple--mt-4">Användarnamn:</label>
		<input name="username" type="text" class="siimple-input siimple--display-block siimple--width-25" placeholder="fornamn@hackab.se" required>

		<label class="siimple-label siimple--display-block siimple--mt-3">Lösenord: </label>
		<input name="password" type="password" class="siimple-input siimple--display-block siimple--width-25" required>

		<button class="siimple-btn siimple-btn--primary siimple--my-4">Logga in</button>
	</form>
</div>

