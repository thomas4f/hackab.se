<!-- CONTENT -->
<div class="siimple-content siimple-content--extra-large HAB-content-flex">
	<h1 class="siimple-h1">Väkommen, {% USERNAME %}</h1>

	<div class="siimple-tip siimple-tip siimple-tip--primary">
		Detta moment är fortfarande under konstruktion, till exempel finns det ingen funktion för att logga ut (men det löser du nog).<br />
		Däremot finns (vägar till) ett par flaggor här! :)
	</div>

	<div id="server_status" class="siimple--display-none">
		<h2 class="siimple-h2">Serverstatus</h2>
		<div class="siimple-tip siimple-tip--warning siimple-tip--exclamation">
	    	Denna statistik är grovt förenklad och uppdateras inte i realtid. För mer granulär information, använd CGI-scriptet.<br />
	    	Alla administratörer får en flagga: <span id="status_flag"></span>
		</div>

		<div class="siimple-grid-row">
			<div class="siimple-grid-col siimple-grid-col--3 siimple-grid-col--sm-12">
				<div class="siimple-card">
					<div class="siimple-card-header">Filsystem</div>
					<div class="siimple-card-body siimple-small">
						<div class="siimple-progress siimple-progress--primary siimple--mb-1">
							<span id="df_use"></span>
						</div>
						<div class="">
							<span id="df_used"></span> GB
							av <span id="df_avail"></span> GB
							(<span id="df_filesystem"></span>,
							<span id="df_type"></span>)
						</div>
					</div>
				</div>
			</div>

			<div class="siimple-grid-col siimple-grid-col--3 siimple-grid-col--sm-12">
				<div class="siimple-card">
					<div class="siimple-card-header">Minne</div>
					<div class="siimple-card-body siimple-small">
						<div class="siimple-progress siimple-progress--success siimple--mb-1">
							<span id ="free_use"></span>
						</div>
						<div class="">
							<span id="free_used_cached"></span> MB
							av <span id="free_total"></span> MB
							(varav cache <span id="free_cached"></span> MB)
						</div>
					</div>
				</div>
			</div>

			<div class="siimple-grid-col siimple-grid-col--3 siimple-grid-col--sm-12">
				<div class="siimple-card">
					<div class="siimple-card-header">Processor</div>
					<div class="siimple-card-body siimple-small">
						<div class="siimple-progress siimple-progress--success siimple--mb-1">
							<span id="load_five"></span>
						</div>
						<div class="">
							<span id="load_one_int"></span>,
							<span id="load_five_int"></span>,
							<span id="load_fifteen_int"></span>
							<span>(snitt för 1, 5 och 15 minuter)</span>
						</div>
					</div>
				</div>
			</div>

			<div class="siimple-grid-col siimple-grid-col--3 siimple-grid-col--sm-12">
				<div class="siimple-card">
					<div class="siimple-card-header">Nätverk</div>
					<div class="siimple-card-body siimple-small">
						<div>
							<div class="siimple--width-50 siimple--display-inline-block ">
								<span class="siimple--width-50 siimple--display-inline-block siimple--text-bold">Mottaget</span>
								<span id="net_rx_mib"></span> MB
							</div>
							<div class="siimple--width-50  siimple--display-inline">
								(<span id="net_rx_packets"></span> paket)
							</div>
						</div>
						<div>
							<div class="siimple--width-50 siimple--display-inline-block ">
								<span class="siimple--width-50 siimple--display-inline-block siimple--text-bold">Skickat</span>
								<span id="net_tx_mib"></span> MB
							</div>
							<div class="siimple--width-50  siimple--display-inline">
								(<span id="net_tx_packets"></span> paket)
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div>
		<h2 class="siimple-h2">Dina meddelanden</h2>
			<table class="siimple-table siimple--pr-3">
				<tbody>
					<tr class="siimple-table-row">
						<td class="siimple-table-cell siimple--text-bold">Från</td>
						<td class="siimple-table-cell siimple--text-bold">Ämne</td>
						<td class="siimple-table-cell siimple--text-bold">Datum</td>
					</tr>
				</tbody>
				<tbody id="messages">
				</tbody>
			</table>
		</div>
	</div>

	<div class="siimple-modal siimple-modal--small siimple--display-none" id="modal">
		<div class="siimple-modal-content">
			<div class="siimple-modal-header HAB-modal-header">
				<div class="siimple-modal-header-title" id="modal-title">Modal title</div>
				<div class="siimple-modal-header-close" id="modal-close"></div>
			</div>
			<div class="siimple-tabs siimple-tabs--boxed">
				<div class="siimple-tabs-item siimple-tabs-item--selected" id="modal-tab-1">Meddelande</div>
				<div class="siimple-tabs-item" id="modal-tab-2">Original</div>
			</div>
			<div class="siimple-modal-body">
				<pre id="modal-message" class="siimple-pre"></pre>
				<pre id="modal-original" class="siimple-pre siimple--display-none"></pre>
			</div>
			<div class="siimple-modal-footer HAB-modal-footer"></div>
		</div>
	</div>

</div>

<script src="/js/administration.js"></script>
