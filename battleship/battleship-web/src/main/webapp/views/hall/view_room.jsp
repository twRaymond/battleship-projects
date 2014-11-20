<script>
function transitionRoom() {
		var options = {
			id      : 'from_room_view',
			url     : 'hall.roomHtml',
 			success	: function(obj) {
 				$("#div_room_list").html(obj);
			}
		};
		$("#from_room_view").ajaxSubmit(options);
}
setInterval(transitionRoom, 700);
</script>
<form:form id="from_room_view" name="from_room_view" action="hall.roomHtml" method="GET"></form:form>
<div id="div_room_list"> </div>
