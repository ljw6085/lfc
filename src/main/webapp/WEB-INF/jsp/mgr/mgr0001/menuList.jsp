<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
	var grid;
	$(document).ready(function(){
		var data = [
					{ parent:null, id:"M0000", url:"/index.do", menuNm:"MAIN" ,icon:'home',sort:1 },
					{ parent:null, id:"M0001", url:"", menuNm:"정보조회", sort:2 },
					{ parent:null, id:"M0002", url:"", menuNm:"정보관리" ,sort:3 },
					{ parent:null, id:"M0003", url:"", menuNm:"게시판" ,sort:4 },
					{ parent:null, id:"M0004", url:"", menuNm:"운영관리", sort:5 },
					{ parent:"M0001", id:"M0011", url:"", menuNm:"차량조회"},
					{ parent:"M0001", id:"M0012", url:"", menuNm:"주차조회"},
					{ parent:"M0002", id:"M0021", url:"", menuNm:"차량정보관리"},
					{ parent:"M0002", id:"M0022", url:"", menuNm:"주차정보관리"},
					{ parent:"M0003", id:"M0031", url:"", menuNm:"공지사항"},
					{ parent:"M0003", id:"M0032", url:"", menuNm:"문의사항"},
					{ parent:"M0004", id:"M0041", url:"", menuNm:"사용자관리"},
					{ parent:"M0004", id:"M0042", url:"/mgr/mgr0001/menuList.do", menuNm:"메뉴관리"},
					{ parent:"M0004", id:"M0043", url:"", menuNm:"코드관리"},
					{ parent:"M0043", id:"M0431", url:"/mgr/mgr0002/codeList.do", menuNm:"공통코드관리"},
					{ parent:"M0001", id:"M0011", url:"", menuNm:"차량조회"},
					{ parent:"M0001", id:"M0012", url:"", menuNm:"주차조회"},
					{ parent:"M0002", id:"M0021", url:"", menuNm:"차량정보관리"},
					{ parent:"M0002", id:"M0022", url:"", menuNm:"주차정보관리"},
					{ parent:"M0003", id:"M0031", url:"", menuNm:"공지사항"},
					{ parent:"M0003", id:"M0032", url:"", menuNm:"문의사항"},
					{ parent:"M0004", id:"M0041", url:"", menuNm:"사용자관리"},
					{ parent:"M0004", id:"M0042", url:"/mgr/mgr0001/menuList.do", menuNm:"메뉴관리"},
					{ parent:"M0004", id:"M0043", url:"", menuNm:"코드관리"},
					{ parent:"M0043", id:"M0431", url:"/mgr/mgr0002/codeList.do", menuNm:"공통코드관리"},
					{ parent:"M0001", id:"M0011", url:"", menuNm:"차량조회"},
					{ parent:"M0001", id:"M0012", url:"", menuNm:"주차조회"},
					{ parent:"M0002", id:"M0021", url:"", menuNm:"차량정보관리"},
					{ parent:"M0002", id:"M0022", url:"", menuNm:"주차정보관리"},
					{ parent:"M0003", id:"M0031", url:"", menuNm:"공지사항"},
					{ parent:"M0003", id:"M0032", url:"", menuNm:"문의사항"},
					{ parent:"M0004", id:"M0041", url:"", menuNm:"사용자관리"},
					{ parent:"M0004", id:"M0042", url:"/mgr/mgr0001/menuList.do", menuNm:"메뉴관리"},
					{ parent:"M0004", id:"M0043", url:"", menuNm:"코드관리"},
					{ parent:"M0043", id:"M0431", url:"/mgr/mgr0002/codeList.do", menuNm:"공통코드관리"},
					{ parent:"M0001", id:"M0011", url:"", menuNm:"차량조회"},
					{ parent:"M0001", id:"M0012", url:"", menuNm:"주차조회"},
					{ parent:"M0002", id:"M0021", url:"", menuNm:"차량정보관리"},
					{ parent:"M0002", id:"M0022", url:"", menuNm:"주차정보관리"},
					{ parent:"M0003", id:"M0031", url:"", menuNm:"공지사항"},
					{ parent:"M0003", id:"M0032", url:"", menuNm:"문의사항"},
					{ parent:"M0004", id:"M0041", url:"", menuNm:"사용자관리"},
					{ parent:"M0004", id:"M0042", url:"/mgr/mgr0001/menuList.do", menuNm:"메뉴관리"},
					{ parent:"M0004", id:"M0043", url:"", menuNm:"코드관리"},
					{ parent:"M0043", id:"M0431", url:"/mgr/mgr0002/codeList.do", menuNm:"공통코드관리"},
					{ parent:"M0001", id:"M0011", url:"", menuNm:"차량조회"},
					{ parent:"M0001", id:"M0012", url:"", menuNm:"주차조회"},
					{ parent:"M0002", id:"M0021", url:"", menuNm:"차량정보관리"},
					{ parent:"M0002", id:"M0022", url:"", menuNm:"주차정보관리"},
					{ parent:"M0003", id:"M0031", url:"", menuNm:"공지사항"},
					{ parent:"M0003", id:"M0032", url:"", menuNm:"문의사항"},
					{ parent:"M0004", id:"M0041", url:"", menuNm:"사용자관리"},
					{ parent:"M0004", id:"M0042", url:"/mgr/mgr0001/menuList.do", menuNm:"메뉴관리"},
					{ parent:"M0004", id:"M0043", url:"", menuNm:"코드관리"},
					{ parent:"M0043", id:"M0431", url:"/mgr/mgr0002/codeList.do", menuNm:"공통코드관리"},
					{ parent:"M0043", id:"M0432", url:"", menuNm:"차량코드관리"}
				];
		var menucol = [
			{colId:'parent',name:'부모메뉴ID', width:100,priority:1}
			,{colId:'id',name:'메뉴ID' , width:100}
			,{colId:'url',name:'URL' , width:300 ,priority:2}
			,{colId:'menuNm',name:'메뉴명', width:150}
			,{colId:'sort',name:'순서', width:50 ,priority:4}
			,{colId:'icon',name:'아이콘' , width:80 ,priority:3}
		];
		grid = $("#menuListGrid").grid({
			col:menucol
			,data : data
			,type:'b'
	 		,columnToggle:false
			,autoFit : true
			,height:400
		});
		
		$("#insert").bind('click',function(e){
			location.href = CONTEXT_PATH + "/mgr/mgr0001/menuInsert.do";
		});
	});
</script>
<style>
</style>
<!-- form 단위로 이루어진 content -->
<form name='frm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
		<div class='searchBox'>
			<table style='width:100%;'>
				<colgroup>
					<col style='width:20%'/>
					<col style='width:30%'/>
					<col style='width:20%'/>
					<col style='width:30%'/>
				</colgroup>
				<tbody>
					<tr>
						<th >메뉴ID</th>
						<td  style='display: block'><input type='text' data-mini='true'></td>
						<th >메뉴명</th>
						<td ><input type='text' data-mini='true'></td>
					</tr>
					<tr>	
						<td colspan='4' style='border:0'>
							<div class='buttonBox' style='margin-top:.5em;'>
								<a href='#' id='insert' class='btn' data-icon='plus'>등록</a>
								<a href='#' id='select' class='btn' data-icon='search'>조회</a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id='menuListGrid' style='border-top:3px solid #ddd;margin:5px;'></div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>