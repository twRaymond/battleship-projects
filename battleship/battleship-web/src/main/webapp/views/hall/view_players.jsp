<script>
function transitionPlayer() {
		var options = {
			id      : 'from_players_view',
			url     : 'hall.playersHtml?timestmpe=player_' + new Date(),
 			success	: function(obj) {
 				$("#div_players_list").html(obj);
			}
		};
		$("#from_players_view").ajaxSubmit(options);
}
setInterval(transitionPlayer, 700);
</script>
<form:form id="from_players_view" name="from_players_view" action="hall.playersHtml" method="GET"></form:form>
<div id="div_players_list"> </div>
