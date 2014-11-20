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
<body>
	<form:form action="room.insert" method="GET" commandName="from_add_room">
		<div>
			<label style="width: 100px">Room Name : </label>
			<label><input type="text" id="roomName" name="roomName" value="Plaese add this room" /></label>
		</div>
		<div>
			<label style="width: 100px">Bout Sec  : </label>
			<label><input type="number" id="boutSec" name="boutSec" min="5" max="30" value="5" /></label>
		</div>
		<div>
			<label style="width: 100px">&nbsp;</label>
			<label><input type="submit" id="btnSubmit" name="btnSubmit" value="Create Room" /></label>
		</div>
		
	</form:form>
</body>
</html>