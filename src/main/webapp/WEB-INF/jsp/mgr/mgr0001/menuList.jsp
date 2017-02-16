<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
		var menucol = [
			{colId:'parent',name:'부모메뉴ID', width:100,priority:1}
			,{colId:'id',name:'메뉴ID' , width:100}
			,{colId:'url',name:'URL' , width:300 ,priority:2}
			,{colId:'menuNm',name:'메뉴명', width:150}
			,{colId:'sort',name:'순서', width:50 ,priority:4}
			,{colId:'icon',name:'아이콘' , width:80 ,priority:3}
		];
	var grid;
	
	
/** Form 단위로 스크립팅 한다. */
$j.documentReady('menuSelectForm', function(form){
	
	$( ":mobile-pagecontainer" ).pagecontainer({
		change:function(){
			$(window).trigger('resize');
		}
	});
	
	grid = $("#menuListGrid").grid({
		col:menucol
		,data : MENU.LIST
		,type:'b'
 		,columnToggle:false
		,autoFit : true
		,height:400
	});
});
	
/** Form 단위로 스크립팅 한다. */
$j.documentReady('menuInsertForm', function($form){
	MENU.createHeaderBackButton( $form.find('.header') );
	//트리 생성
	var root = MENU.DATA;
	var menu = $("<ul></ul>");
	MENU._createChild( MENU.DATA , menu );
	$("#treeArea").append( menu );
	
	//이벤트
	$("#treeArea").bind('click',function(e){
		if( e.target.tagName == 'A'){
			$(".selected-item").removeClass('selected-item');
			var id = $(e.target).data('id');
			var clicked = MENU.TREE.getById( id );
			setMappingData( clicked );
			$(e.target).addClass('selected-item');
		}
	});
	
	
	$(document).on('swiperight','.ui-page',function(e){
		$form.find('.header').find('a').trigger('click');
	});
	
	function setMappingData( obj ){
		for(var k in obj ){
			switch (k) {
			case 'id':
				$form[0]['menuId'].value = obj[k];
				break;
			case 'icon':
				$form[0]['icon'].value = obj[k];
				break;
			case 'menuNm':
				$form[0]['menuNm'].value = obj[k];
				break;
			case 'url':
				$form[0]['url'].value = obj[k];
				break;
			}
		}
	}
	
	
});
	
</script>
<style>
	#menuInsert #areaWrap {
		width:100%;
	}
	#menuInsert #treeArea {
		width:30%;
		padding:1em;
		overflow: auto;
		min-height: 33em;
		float:left;
	}
	#menuInsert #treeArea ul{
		margin:0;
		padding-left:.8em;
		list-style: none;
	}
	
	#menuInsert #treeArea li a{
		cursor:pointer;
	}
	#menuInsert #treeArea li{
		min-width: 150px;
		margin:.2em 0;
	}
	/* #menuInsert #treeArea li::before{
		content: "↕ "
	} */
	#menuInsert #infoArea {
		width:64%;
		float:left;
		margin-left:.2em;
	}
	.selected-item{
		background: #3388cc;
		color:#fff !important;
	}
</style>
<!-- form 단위로 이루어진 content -->
<form name='menuSelectForm'>
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
								<a href='#menuInsert' id='insert' class='btn' data-icon='gear' data-transition='slide'>관리</a>
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
<!-- ############################################################################################################################################ -->
<!-- 메뉴등록화면 시작 -->
<div data-role="page" id='menuInsert' style='overflow: scroll;'><!-- second page start -->
<form name='menuInsertForm'>
	<div class='header' data-role='header'><h1>메뉴등록</h1></div>
	<div role='main' class='ui-content' style='min-width:750px;'>
		<div id='areaWrap'>
			<div id='treeArea'></div>
			<div id='infoArea'>
				<table class='defaultTable'>
					<colgroup>
						<col style='width:20%;'/>
						<col style='width:30%;'/>
						<col style='width:20%;'/>
						<col style='width:30%;'/>
					</colgroup>
					<tbody>
						<tr>
							<td class='insertTd' colspan='4' style='border:0;padding:0;'>
								<div class='buttonBox' style='margin-bottom:.5em;'>
									<a href='#' class='btn menuAdd' data-icon='plus' >추가</a>
									<a href='#' class='btn menuEdit' data-icon='edit' >수정</a>
									<a href='#' class='btn menuDelete' data-icon='delete'>삭제</a>
								</div>
							</td>
						</tr>
						<tr>
							<th class='insertTh'>메뉴명</th>
							<td class='insertTd' colspan='3'><input type='text' name='menuNm' placeholder="메뉴명"></td>
						</tr>
						<tr>
							<th class='insertTh'>메뉴ID</th>
							<td class='insertTd'><input type='text' name='menuId' placeholder="메뉴ID" disabled="disabled"></td>
							<th class='insertTh'>ICON</th>
							<td class='insertTd'><input type='text' name='icon' placeholder="icon"></td>
						</tr>
						<tr>
							<th class='insertTh'>URL</th>
							<td class='insertTd' colspan='3'><input type='text' name='url' placeholder="메뉴 URL"></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form>
</div>
<!-- 메뉴등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>