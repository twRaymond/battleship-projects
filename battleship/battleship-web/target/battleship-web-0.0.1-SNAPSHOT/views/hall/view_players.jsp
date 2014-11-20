<!-- include parent need import src
	 <script src="html/js/jQuery/jquery-1.11.1.min.js" ></script>
	 <script src="html/js/jQuery/jquery.form.js" ></script>
 -->
<script type="text/javascript">
function transitionPlayer() {
		var options = {
			id      : 'from_players_view',
			url     : 'hall.json.players?timestmpe=player_' + new Date(),
			dataType: 'json',
 			success	: function(obj) {
 				$("#div_players_list").html(obj);
			}
		};
		$("#from_players_view").ajaxSubmit(options);
}
setInterval(transitionPlayer, 1900);
</script>
<form:form id="from_players_view" name="from_players_view" action="hall.json.players" method="GET"></form:form>
<div id="div_players_title">Player List</div>
<div id="div_players_list"> </div>
