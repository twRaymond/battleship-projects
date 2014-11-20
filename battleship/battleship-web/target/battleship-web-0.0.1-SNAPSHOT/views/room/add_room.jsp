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
		Room Name : <input type="text" id="roomName" name="roomName" value="" />
		Bout Sec  : <input type="number" id="boutSec" name="boutSec" min="5" max="30" />
		<input type="submit" id="btnSubmit" name="btnSubmit" value="Create" />
	</form:form>
</body>
</html>