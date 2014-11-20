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
<script src="html/js/jQuery/jquery-1.11.1.min.js" ></script>
<script src="html/js/jQuery/jquery.form.js" ></script>
<script type="text/javascript">
function to_logout() {
	window.location.href = '${pageContext.request.contextPath}/login.off';
}
</script>
<title></title>
<body>
	battleship HOME !! <br />
	Hello ${user_info.account} <br/>
	<input type="button" id="btnLogout" name="btnLogout" value="logout" onclick="to_logout()"/>
	<jsp:include page="view_players.jsp"></jsp:include>
	<jsp:include page="view_room.jsp"></jsp:include>
	<form:form action="room.add" method="GET" commandName="from_room_add">
		<input type="submit" id="submit" name="submit" value="Create Room" />
	</form:form>
</body>
</html>