<!-- include parent need import src
	<script src="html/js/jQuery/jquery-1.11.1.min.js" ></script>
	<script src="html/js/jQuery/jquery.form.js" ></script>
 -->
<script type="text/javascript">
function transitionRoom() {
		var options = {
			id      : 'from_room_view',
			url     : 'hall.json.room?timestmpe=room_' + new Date(),
			dataType: 'json',
 			success	: function(obj) {
 				alert(obj);
 				$("#div_room_list").html(obj);
			}
		};
		$("#from_room_view").ajaxSubmit(options);
}
setInterval(transitionRoom, 2000);
</script>
<form:form id="from_room_view" name="from_room_view" action="hall.json.room" method="GET"></form:form>
<form:form id="from_room_in" name="from_room_in" action="room.inRoom" method="GET"></form:form>
<div id="div_room_title">Room List</div>
<div id="div_room_list"> </div>
