<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
/** Form 단위로 스크립팅 한다. */
$j.documentReady('menuSelectForm', function(form,$uiPage){
	
	var mList = MENU.LIST;
	for(var i = 0,len=mList.length;i<len;i++){
		var mnInfo = mList[i]; 
		var url = (mnInfo.menuUrl)?mnInfo.menuUrl:"";
		var tr = "<tr>"; 
			tr += "<td>" +mnInfo.menuNm+ "</td>"; // menu명
			tr += "<td>" +url+ "</td>"; // url
			tr += "<td><input type='checkbox' class='txtC'></td>"; // useAt
			tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -1
			tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -2
			tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -3
			tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -4
			tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -5
			tr += "<td style='text-align: center;'><a href='#' class='btnIcon' data-icon='gear'></a></td>"; // detail
			tr += "</tr>";
		var $tr = $(tr);
		for(var k in mnInfo){
			var data = mnInfo[k];
			if( typeof data == 'object' || !data) continue;
			var newK = strLib.toUnderScore( k , false, '-');
			$tr.attr('data-'+newK, data );
		}
		$(".menuDataList").append($tr);
	}
	$j.refreshPage();
});
</script>
<style>
	.menuList th { background: #eee;}
	.menuList td { padding: 0 .5em;}
</style>
<!-- form 단위로 이루어진 content -->
<form name='menuSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content' style='min-width:750px;'>
		<div>
			<div class='buttonBox' style='margin:.5em 0;'>
				<a href='#' id='insert' class='btn' data-icon='check' data-color='green'>저장</a>
				<a href='#' id='select' class='btn' data-icon='refresh' data-color='gray'>초기화</a>
			</div>
		</div>
		<div id='menuList'>
			<table class='defaultTable menuList'>
				<colgroup>
					<col style='width:20%'/>
					<col style='width:*'/>
					<col style='width:5%'/>
					
					<col style='width:7%'/>
					<col style='width:7%'/>
					<col style='width:7%'/>
					<col style='width:7%'/>
					<col style='width:7%'/>
					<col style='width:7%'/>
				</colgroup>
				<thead>
					<tr>
						<th rowspan='2'>메뉴명</th>
						<th rowspan='2'>URL</th>
						<th rowspan='2'>사용<br/>여부</th>
						<th colspan='5'>메뉴권한</th>
						<th rowspan='2'>수정</th>
					</tr>
					<tr>
						<th>일반<br/>사용자</th>
						<th>업무<br/>사용자</th>
						<th>업무<br/>관리자</th>
						<th>운영<br/>관리자</th>
						<th>시스템<br/>관리자</th>
					</tr>
				</thead>
				<tbody class='menuDataList'> </tbody>
			</table>
		</div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>