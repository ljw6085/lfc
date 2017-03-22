<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<script>
/** 
	 화면이동이 필요할때, jsp를 따로 관리하고자 하면
	 $j.documents 에 초기화 함수를 push 해야한다. 
 */
$j.documents.push(function(){
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('codeSelectForm', function($form,$uiPage){
		
		$m.openMenuFromSwipe($uiPage);
		
		$form.find('.infoButtonBox').on('click',function(e){
			var $target = $(e.target);
			switch (true) {
				case $target.hasClass('codeAdd'):
					addCode();
					break;
				case $target.hasClass('codeSelect'):
					selectCodeList($form );
					break;
				default:
					break;
			}
		});
		
		$("#carCodeList").on('click','li',function(){
			if( $(this).hasClass('noData') ) return;
			var t = $(this);
			var param = Common.getDataFromDoms( t );
			$j.pageMove( '#codeInsert' , param );
		});
		
	});
	
	function addCode(){
		$j.pageMove( '#codeInsert' );
	}
	
	var item = "";
	item += "<li><a href='#' class='item'>";
	item += "<input type='hidden' name='parentCode' value='%{divCode}'>";
	item += "<h2><span class='title'>코드명</span> %{divCodeNm}</h2>";
	item += "<p class='ui-li-aside'>%{divUseAt}</p>";
	item += "<p><span class='title'>코드</span> %{divCode}</p>";
	item += "<p><span class='title'>코드설명</span> %{divCodeDc}</p>";
	item += "</a></li>"
	var noItem = "<li class='noData'>조회된 데이터가 없습니다.</li>";
	function selectCodeList( $form ){
		$.mobile.loading('show');
		var url = "<c:url value='/mgr/mgr0005/codeList.do'/>";
		$("#carCodeList").html("");
		Common.ajaxJson( url ,$form,function(data){
	
    		if( !data.length ) $("#carCodeList").append( noItem );
    		else{
	    		for( var i =0,len=data.length;i<len;i++){
	    			if( data[i].divUseAt == 'Y' ) data[i].divUseAt = '사용'
	    			else data[i].divUseAt = '사용안함'
	    			
					var it = Common.matchedReplace( item, data[i]);
					$("#carCodeList").append( it );
	    		}
    		}
    		$("#carCodeList").listview('refresh');
    		$.mobile.loading('hide');
    	});
	}
	
});
</script>
<style>
	h2 .title { 
		font-size:0.75em;
		font-weight: normal;
	}
	.item .title {
		color:#aaa;
		margin-right:1em;
	}
	.disabledRow .itemCont{
		color:#aaa;
	}
</style>
<!-- form 단위로 이루어진 content -->
<form name='codeSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
	<div id='searchBox'>
		<div class='ui-corner-all custom-corners ui-shadow '>
			<div data-role="collapsible" class="ui-nodisc-icon ui-alt-icon">
				<h3>조회조건</h3>
				<input type='hidden' name='divParentCode'>
				<div class="ui-field-contain">
					<label for="divCodeInput" class='label'>분류코드</label>
					<input type='search' id='divCodeInput' name='divCode' placeholder="분류코드" data-mini='true'>
				</div>
				<div class="ui-field-contain">
					<label for="divCodeNmInput" class='label'>분류코드명</label>
					<input type='search' id='divCodeNmInput' name='divCodeNm' placeholder="분류코드명" data-mini='true'>
				</div>
				<div class="ui-field-contain">
					<label for="divCodeDcInput" class='label'>분류코드설명</label>
					<input type='search' id='divCodeDcInput' name='divCodeDc' placeholder="분류코드설명" data-mini='true'>
				</div>
				<div class="ui-field-contain divUseAtRow">
					<label for="" class='label'>사용여부</label>
					<div class='divUseAt'></div>
				</div>
			</div>
		</div>
	</div>
	<div class='ui-grid-a infoButtonBox'>
		<div class='ui-block-a'>
			<a href='#' class='codeAdd' data-role='button' data-icon='plus' data-mini='true'>코드등록</a>
		</div>
		<div class='ui-block-b'>
			<a href='#' class='codeSelect' data-role='button' data-icon='search' data-mini='true'>조회</a>
		</div>
	</div>
	<div class='listWrap' >
		<ul id='carCodeList' data-role="listview" data-inset="true"  class='dataList'>
			<li class='noData'>조회된 데이터가 없습니다.</li>
		</ul>
	</div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<!-- ############################################################################################################################################ -->
<!-- 코드등록/수정화면 시작 -->
<!-- second page start -->
<c:import url="/mgr/mgr0005/codeInsert.do"></c:import>
<!-- 코드등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>