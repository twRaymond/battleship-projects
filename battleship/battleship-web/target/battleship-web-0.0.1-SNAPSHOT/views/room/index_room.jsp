<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" rel="stylesheet" href="html/css/common-style.css">
<link type="text/css" rel="stylesheet" href="html/css/common-button.css">
<link type="text/css" rel="stylesheet" href="html/css/login.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<script type="text/javascript">
function transition() {
		var options = {
			id      : 'from_room_update',
			url     : 'hall.info.update',
			dataType: 'json',
 			success	: function(obj) {
 				
			}
		};
		$("#from_room_update").ajaxSubmit(options);
}
setInterval(transition, 2000);
$(document).ready(function(){
	$("#btnStart").click( function() {
		$("#from_start_game").action = "room.start";
		$("#btnStart").submit();
	});
	
	$("#btnExit").click(function() {
		$('#from_start_game').action = "room.exit";
		$("#btnExit").submit();
	});
	
	$("#btnReady").click(function() {
		var options = {
			id      : 'from_room_ready',
			url     : 'hall.ready.update',
			dataType: 'json',
 			success	: function(obj) {
 				
			}
		};
		$("#from_room_update").ajaxSubmit(options);
	});
});
</script>
<body>
 	Room (${room.roomName})> <br/>
 		Players : <br />
 	<div id="div_player_list">${room.players[0].account}</div>
	<input type="submit" id="btnReady" name="btnReady" value="READY" />&nbsp;
	<form:form action="room.start" method="GET" commandName="from_start_game">
		<input type="hidden" id="state" name="state" value="${room.state}" />
		<input type="submit" id="btnStart" name="btnStart" value="START" disabled="disabled"/>
		<input type="submit" id="btnExit" name="btnExit" value="EXIT" />
	</form:form>
	<br />
	<form:form id="from_room_ready" name="from_room_ready" action="room.ready.update" method="GET"></form:form>
	<form:form id="from_room_update" name="from_room_update" action="room.info.update" method="GET"></form:form>
</body>
</html>