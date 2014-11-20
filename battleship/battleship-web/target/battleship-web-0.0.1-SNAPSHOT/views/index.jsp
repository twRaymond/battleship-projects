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
<title></title>
<body>
	Hello Welcome To battleship Web Application !!
	<form:form action="login.on" method="GET" commandName="from_login">
		<input type="submit" id="submit" name="submit" value="Get Guest and Login" />
	</form:form>
</body>
</html>