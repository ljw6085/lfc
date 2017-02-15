<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Insert title here</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
	<%@ include file="/WEB-INF/jsp/cmm/resources.jsp" %>
	<script>
		$(document).ready(function(){
			$("#login").bind('click',function(e){
				e.preventDefault();
				frm.submit();
			});
		})
	</script>
</head>
<body>
<form name='frm' id='frm' action="<c:url value='/cmm/login/login.do'/>" method="post">
<div data-role="page" id="page_login">
	<div data-role="header" data-position="fixed">
		<h1>LOGIN</h1>
	</div>
	<div data-role="main" class="ui-content">
		<div style='text-align: right;'>
			<select name="slider2" id="slider2" data-role="slider" data-mini="true">
				<option value="off">Off</option>
				<option value="on">On</option>
			</select>
		</div>
		<div style='padding-left:10px;padding-right:10px;text-align: center;'>
			<input type='text' id='id' name='userId' placeholder="Id" class='filter:eng'>
			<input type='password' name='passwd' placeholder="Password">
		</div>
		<div class="ui-grid-a" 	style='padding-left:10px;padding-right:10px;'>
			<div class="ui-block-a">
				<a id='login' href="/app/tableTest7.do" class="ui-btn ui-mini ui-corner-all ui-shadow ui-icon-check ui-btn-icon-left">로그인</a>
			</div>
			<div class="ui-block-b">
				<a id='register' href="#page2" class="ui-btn ui-mini ui-corner-all ui-shadow ui-icon-user ui-btn-icon-left">회원가입</a>
			</div>
		</div>
	</div>
</div>
<div data-role="page" id="page2">
	<div data-role="main" class="ui-content">
		<div data-role="header" data-position="fixed">
			<!--  ui-nodisc-icon ui-alt-icon  -->
			<a href="#" data-rel='back' class="ui-btn ui-mini ui-corner-all ui-shadow ui-icon-arrow-l ui-btn-icon-notext"></a>
		  <h1>
		  	회원가입
		  </h1>
		</div>
	</div>
</div>
</form>
</body>
</html>