<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<%@ include file="/WEB-INF/jsp/cmm/resources.jsp" %>
	<script>
		/** 페이지 상단에 관련된 스크립트 작성.  */
		$(document).ready(function(){
			// 메뉴버튼을 생성한다. - common.js
			MENU.createMenuButton( 'menuButton' );
		});
	</script>
	<style>
		#menuButton {
			position: absolute;
			padding-left:0.5em;
		}
		
	</style>
</head>
<body>
<!-- header : content부분으로 이동시킬지 말지 고민중 (페이지타이틀때문) -->
<div class='header'>
	<!-- 메뉴버튼 ID -->
	<div id='menuButton'></div>
	<h1 style='text-align: center;'>[LOGO]</h1>
</div>
<%@ include file="/WEB-INF/jsp/cmm/inc/menu.jsp" %>