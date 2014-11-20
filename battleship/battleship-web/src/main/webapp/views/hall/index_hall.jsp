<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="com.battleship.domain.Player"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" rel="stylesheet" href="html/css/common-style.css">
<link type="text/css" rel="stylesheet" href="html/css/common-button.css">
<link type="text/css" rel="stylesheet" href="html/css/login.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="html/js/jQuery/jquery-1.11.1.min.js" ></script>
<script src="html/js/jQuery/jquery.form.js" ></script>
<script type="text/javascript">
function to_logout() {
	window.location.href = '${pageContext.request.contextPath}/login.off';
}
</script>
<title></title>
<%
	Player me = (Player) request.getSession().getAttribute("user_" + request.getSession().getId());
 %>
<body>
	<table>
		<tr>
			<td valign="top"><h3 style="padding:0;margin:0;">Battleship Game Hall !!</h3></td>
			<td valign="top"><input type="button" id="btnLogout" name="btnLogout" value="logout" onclick="to_logout()"/></td>
			<td valign="top">
				<form:form action="room.add" method="GET" commandName="from_room_add">
					<input type="submit" id="submit" name="submit" value="Create Room" />
				</form:form>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<div id="hall_me_info">Hello !! <%=me.getAccount() %> </div>
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<td valign="top">
				<div style="width:300px">
				<fieldset>
				<legend>Online Player List : </legend>
					<jsp:include page="view_players.jsp"></jsp:include>
				</fieldset>
				</div>
			</td>
			<td valign="top">
				<div style="width:600px">
				<fieldset>
				<legend>Game Room List : </legend>
					<jsp:include page="view_room.jsp"></jsp:include>
				</fieldset>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>