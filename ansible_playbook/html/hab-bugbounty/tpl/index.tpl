<!-- CONTENT -->
<div class="siimple-content siimple-content--extra-large HAB-content-flex">
	<h1 class="siimple-h1">Bug Bounty</h1>
	<p class="siimple-p">
		Välkommen till Hack ABs bug bounty-program!
	</p>

	<p class="siimple-p">
		Programmet går ut på att identifiera mer eller mindre allvarliga sårbarheter genom utforska Hack ABs hemsida, API och andra kringliggande tjänster.<br />
		Du kommer ha nytta av dina kunskaper inom (och kanske lära dig mer om) bland annat informationsinsamling, 
		verifiering av komponentkonfiguration, affärslogik och felhantering. 
	</p>

	<p class="siimple-p siimple--text-italic">
		Observera att subdomänen bugbounty.hackab.se inte är en del av programmet!
	</p>

	<p class="siimple-p">
		Gå till vår <a href="/?poangtavla" class="siimple-link">poängtavla</a> för att se hur du ligger till.
	</p>

	<div class="siimple-grid">
		<div class="siimple-grid-row">
			<div class="siimple-grid-col siimple-grid-col--8 siimple-grid-col--sm-12">
				<h2 id="om-flaggor" class="siimple-h2">Om flaggor</h2>
				<p class="siimple-p">
					På den här sidan kan du skicka in de "flaggor" du hittar på vår hemsida och våra andra tjänster.
					Nedanför ser du ett exempel på hur en flagga ser ut. Kopiera hela raden, klistra in den i rutan nedanför och klicka på "Skicka". <br />
					De andra flaggorna får du anstränga dig lite mer för att hitta! :)
				</p>
				<pre class="siimple-pre siimple--text-bold siimple--py-2">HABFLAG{9D1F7EC74FDC0B231967DE2BF731B48A9A9F92BBACDAB76358784C920DD20D4B}</pre>
				
				<form data-form="flags" class="siimple--clearfix">
					<label class="siimple-label siimple--display-block">Skicka en eller flera flaggor</label>
					<div class="siimple--pr-4 siimple--width-75 siimple--float-left" style="box-sizing: border-box;">
						<input name="flags" class="siimple-input siimple--width-100" placeholder="HABFLAG{...}" required />
					</div>
					<div class="siimple--width-25 siimple--float-right">
						<button id="flagsubmit" class="siimple-btn siimple-btn--primary siimple-btn--fluid">Skicka</button>
					</div>
				</form>
				<div class="siimple--mt-1">
					<span id="flag-msg" class="siimple-small"></span>
				</div>
			</div>

			<div class="siimple-grid-col siimple-grid-col--4 siimple-grid-col--sm-12">
				<h2 class="siimple-h2">Ditt konto</h2>

				<!-- account-logged-out -->
				<div id="account-logged-out-card" class="siimple-card toggleable siimple--display-none">
					<div class="siimple-card-header">Inte inloggad</div>
					<div class="siimple-card-body">
						<p class="siimple-p">
							Du är inte inloggad. Du kan skicka in dina flaggor ändå, men för att de ska sparas och synas på poängtavlan behöver du skapa ett konto och/eller logga in.
						</p>

						<form data-form="login-form" class="siimple--clearfix">
							<label class="siimple-label siimple--display-block">
								Ange ditt ID för att logga in
							</label>
							<div class="siimple--width-75 siimple--float-left siimple--pr-4" style="box-sizing: border-box">
								<input name="uuid" class="siimple-input siimple--width-100" required />
							</div>
							<div class="siimple--width-25 siimple--float-right">
								<button id="account-logged-out-submit" class="siimple-btn siimple-btn--primary siimple-btn--fluid">OK</button>
							</div>
						</form>

						<div class="siimple--mt-1">
							<span id="account-logged-out-message" class="siimple-small">
								Inte registrerad? <a id="account-logged-out-create" class="siimple-link">Skapa ett konto</a>.
							</span>
							<span id="account-logged-out-failure" class="siimple-small siimple--color-error siimple--display-none">
								Inloggningen misslyckades.
							</span>
						</div>
					</div>
				</div>

				<!-- account-create -->
				<div id="account-create-card" class="siimple-card toggleable siimple--display-none">
					<div class="siimple-card-header">Skapa konto</div>
					<div class="siimple-card-body">
						<p class="siimple-p">
							Vår AI-motor genererade följande användarnamn åt dig. Du kan inte ange ett själv, men om du (mot förmodan) inte är nöjd kan du generera ett nytt.
						</p>

						<form data-form="login-form" class="siimple--clearfix">
							<label class="siimple-label siimple--display-block">
								Ditt användarnamn
								<span><a id="account-create-regenerate" class="siimple-link">(generera nytt)</a></span>
							</label>
							<div class="siimple--width-75 siimple--float-left siimple--pr-4" style="box-sizing: border-box">
								<input id="account-create-input" class="siimple-input siimple--width-100" readonly />
							</div>
							<div class="siimple--width-25 siimple--float-right">
								<button id="account-create-button" class="siimple-btn siimple-btn--primary siimple-btn--fluid">OK</button>
							</div>
						</form>

						<div class="siimple--mt-1">
							<span class="siimple-small">
								Har du ångrat dig? <a id="account-create-cancel" class="siimple-link">Avbryt</a>.
							</span>
						</div>
					</div>
				</div>

				<!-- account-confirm -->
				<div id="account-confirm-card" class="siimple-card toggleable siimple--display-none">
					<div class="siimple-card-header">Kontouppgifter</div>
					<div class="siimple-card-body">
						<p class="siimple-p">
							Konto skapat:  
							<span id="account-confirm-username" class="siimple--text-bold"></span>. <br /><br />
							Använd nedanstående ID för att logga in.
						</p>

						<form data-form="login-form" class="siimple--clearfix">
							<label class="siimple-label siimple--display-block">
								Ditt ID
								<span class="siimple--color-success">(spara det här!)</span>
							</label>
							<div class="siimple--width-100">
								<input id="account-confirm-input" class="siimple-input siimple--width-100" readonly />
							</div>
						</form>

						<div class="siimple--mt-1">
							<span class="siimple-small">
								Nu kan du gå till <a id="account-confirm-login" class="siimple-link">inloggningen</a>.
							</span>
						</div>
					</div>
				</div>

				<!-- account-logged-in -->
				<div id="account-logged-in-card" class="siimple-card toggleable siimple--display-none">
					<div class="siimple-card-header">Inloggad</div>
					<div class="siimple-card-body">
						<p class="siimple-p">
							Inloggad som 
							<span id="account-logged-in-username" class="siimple--text-bold">Någonting</span>. <br/><br />
							Du har <span id="account-logged-in-points">0</span> poäng.
						</p>

						<form data-form="login-form" class="siimple--clearfix">
							<label class="siimple-label siimple--display-block">
								Ditt ID
								<span><a id="account-logged-in-toggle" class="siimple-link">(visa/dölj)</a></span>
							</label>
							<div class="siimple--width-100">
								<input id="account-logged-in-input" class="siimple-input siimple--width-100" readonly type="password" />
							</div>
						</form>

						<div class="siimple--mt-1">
							<span class="siimple-small">
								<a id="account-logged-in-logout" class="siimple-link">Logga ut</a>.
							</span>
						</div>
					</div>
				</div>

			</div>
		</div>

		<div class="siimple-grid-row">
			<div class="siimple-grid-col siimple-grid-col--12 siimple-grid-col--sm-12">
				<h2 class="siimple-h2">Flaggor</h2>
				<table class="siimple-table siimple--pr-3">
					<tbody>
						<tr class="siimple-table-row">
							<td class="siimple-table-cell siimple--text-bold">#</td>
							<td class="siimple-table-cell siimple--text-bold">Flagga</td>
							<td class="siimple-table-cell siimple--text-bold">Kategori</td>
							<td class="siimple-table-cell siimple--text-bold">Poäng</td>
							<td class="siimple-table-cell siimple--text-bold">Löst av</td>
						</tr>
					</tbody>
					<tbody id="flags">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript" src="./js/bugbounty.js"></script>
