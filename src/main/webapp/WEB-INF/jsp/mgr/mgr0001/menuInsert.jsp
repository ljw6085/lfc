<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
	$(document).ready(function(){
	});
</script>
<style>
	.areaWrap {
		width:100%;
	}
	.treeArea {
		width:45%;
	}
	.infoArea {
		width:54%;
	}
</style>
<!-- form 단위로 이루어진 content -->
<form name='frm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
		<div id='areaWrap'>
			<div id='treeArea'>
				tree	
			</div>
			<div id='infoArea'>
				info
			</div>
		</div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>