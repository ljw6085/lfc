<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
$j.documents.push(function(){
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('codeSelectForm', function($form,$uiPage){
		
		$m.openMenuFromSwipe($uiPage);
		
		var grid = makeGrid( $form );
		
		$(window).bind('resize',function(){
			compactSizingGrid( grid , $uiPage );
		}).trigger('resize');
		
		$j.$page().on('pagechange',function(e){
			$(window).trigger('resize');
		});
		
		$form.find('.buttonBox').on('click',function(e){
			var $target = $(e.target);
			switch (true) {
				case $target.hasClass('codeAdd'):
					addCode();
					break;
				case $target.hasClass('codeSelect'):
					selectCodeList( $form ,  grid );
					break;
				default:
					break;
			}
		});
		
	    grid.boxForDom.$body.on('click','tr',function(e){
	    	//클릭된 row 정보를 세
	    	var dt = grid.data[this.id] ;
	    	$m.pageMove( '#codeInsert' , dt );
	    });
	});
	
	function addCode(){
		$m.pageMove( '#codeInsert' );
	}
	
	function selectCodeList( $form, grid ){
		var url = "<c:url value='/mgr/mgr0002/codeList.do'/>";
    	Common.ajaxJson( url ,$form,function(data){
			grid.reload( data );
    	});
	}
	
	function compactSizingGrid( grid , $uiPage ){
		var originHeight = grid.boxForDom.$bodyWrap.height();
		var diff = $('body').height()
					- $uiPage.find(".ui-content").innerHeight()
					- $uiPage.find(".header").outerHeight()
					- $uiPage.find(".footer").outerHeight();
		
		grid.boxForDom.$bodyWrap.height( originHeight + diff );
	}
	
	function makeGrid( $form ){
		// 그리드 옵션
		var option = {
				col:[
				    { colId:'divCode', name:'분류코드',  width:100},
					{ colId:'divCodeNm', name:'코드명',  width:150},
					{ colId:'divUseAt', name:'사용여부',  width:80}
				]
				,data : []
				,type:'b'
		 		,columnToggle:false
				,autoFit : true
				,height:400
		}
		if( $j.isMobile() ){
			var addOption = {
					height:'auto'
					,customColumnLayout: function( colInfo ){
						var $colgrp = $("<colgroup></colgroup>");
						var $col = $("<col/>");
						$colgrp.append($col);
						return $colgrp;
					}
					,customHeaderLayout:function( colInfo ){
						return "<th style='text-align:center;'></th>";
					}
					,customRowLayout:function( i, item ){
			 			return "<div><div>#divCode#</div><div>#divCodeNm#</div><div>#useAt#</div></div>";
					}
			}
			$.extend( option , addOption );
		}
		
		return $form.find(".gridWrap").grid(option);
	}
});
</script>
<style>
</style>
<!-- form 단위로 이루어진 content -->
<form name='codeSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content' style='min-width:750px;'>
	<div id='searchBox'>
		<table class='defaultTable'>
				<colgroup>
					<col style='width:20%;'/>
					<col style='width:30%;'/>
					<col style='width:20%;'/>
					<col style='width:30%;'/>
				</colgroup>
				<tbody>
					<tr>
						<th class='insertTh'>분류코드</th>
						<td class='insertTd'><input type='text' name='divCode' data-mini="true" placeholder="분류코드"></td>
						<th class='insertTh'>분류코드명</th>
						<td class='insertTd'><input type='text' name='divCodeNm' data-mini="true" placeholder="분류코드명"></td>
					</tr>
					<tr>
						<th class='insertTh'>사용여부</th>
						<td class='insertTd' colspan='3' data-role="controlgroup" data-type="horizontal" data-mini="true">
							<input type="radio" name="divUseAt" id="div_use_at_y" value="Y" checked="checked">
					        <label for="div_use_at_y">사용</label>
					        <input type="radio" name="divUseAt" id="div_use_at_n" value="N">
					        <label for="div_use_at_n">사용안함</label>
						</td>
					</tr>
				</tbody>
			</table>
	</div>
	<div class='buttonBox' style='text-align: right;margin-top:.5em;'>
		<a href='#' class='btn codeAdd' data-icon='plus'>코드등록</a>
		<a href='#' class='btn codeSelect' data-icon='search'>조회</a>
	</div>
	<div class='gridWrap' ></div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<!-- ############################################################################################################################################ -->
<!-- 코드등록/수정화면 시작 -->
<!-- second page start -->
<c:import url="/mgr/mgr0002/codeInsert.do"></c:import>
<!-- 코드등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>