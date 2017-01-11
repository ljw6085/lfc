<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<%@ include file="../resources.jsp" %>
	<script>
		$(document).ready(function(){
			page_login();
		})
		function page_login(){
			var backTogo = $m.createButton({
				icon : "ui-icon-arrow-l",
				'data-rel':'back'
			});
			
			$("#backToGo")
				.append(backTogo);
		}
	</script>
</head>
<body>
<form name='frm'>
<div data-role="page" id="page_login">
	<div data-role="header" data-position="fixed">
		<div id='backToGo'></div>
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
			<input type='text' id='id' name='id' placeholder="Id" class='filter:eng'>
			<input type='password' name='pwd' placeholder="Password">
		</div>
		<div class="ui-grid-a" 	style='padding-left:10px;padding-right:10px;'>
			<div class="ui-block-a">
				<a href="/lfc/tableTest7.do" class="ui-btn ui-mini ui-corner-all ui-shadow ui-icon-check ui-btn-icon-left">로그인</a>
			</div>
			<div class="ui-block-b">
				<a href="#page2" class="ui-btn ui-mini ui-corner-all ui-shadow ui-icon-user ui-btn-icon-left">회원가입</a>
			</div>
		</div>
	</div>

	<!-- <div data-role="footer">
	   <h4>Page Footer</h4>
	</div> -->
	
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
<%@ include file="../inc/menu.jsp" %>
</body>
</html>