<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
/** 
	 화면이동이 필요할때, jsp를 따로 관리하고자 하면
	 $j.documents 에 초기화 함수를 push 해야한다. 
 */
$j.documents.push(function(){
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('carSelectForm', function($form,$uiPage){
		$m.openMenuFromSwipe($uiPage);
		MENU.createHeaderButton({
			wrapper:$("#header")
			,position:'right'
			,icon:'search'
			,click:function(e){
				$("#detailSearch").panel('open');
			}
		});
	});
});
</script>
<style>
.dataList p {margin:0 !important;padding:0;}
.listWrap { margin-top:0.5em;}
#searchBox .ui-grid-a .ui-btn { margin:0.3em;}
#searchBox .search-condition-box .ui-block-a { width:30%} 
#searchBox .search-condition-box .ui-block-b { width:70%} 
</style>
<!-- form 단위로 이루어진 content -->
<form name='carSelectForm'>
	
	
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content' >
	<div id='searchBox'>
		<div data-role="collapsible" class="ui-nodisc-icon ui-alt-icon search-condition-box">
			<h3>조회조건</h3>
			<div class='ui-grid-a'>
				<div class='ui-block-a'>제조사</div>
				<div class='ui-block-b'>전체</div>
			</div>
			<div class='ui-grid-a'>
				<div class='ui-block-a'>모델</div>
				<div class='ui-block-b'>전체</div>
			</div>
			<div class='ui-grid-a'>
				<div class='ui-block-a'>차종</div>
				<div class='ui-block-b'>전체</div>
			</div>
			<div class='ui-grid-a'>
				<div class='ui-block-a'>연료</div>
				<div class='ui-block-b'>전체전체전체전체전체전체전체전체전체전체전체전체전체전체</div>
			</div>
			<div class='ui-grid-a'>
				<div class='ui-block-a'>외형</div>
				<div class='ui-block-b'>전체</div>
			</div>
		</div>
		<div class='ui-grid-a'>
			<div class='ui-block-a'>
				<a href='#' data-role='button' id='add' data-icon='plus' data-mini='true'>신규등록</a>
			</div>
			<div class='ui-block-b'>
				<a href='#' data-role='button' id='select' data-icon='search' data-mini='true'>조회</a>
			</div>
		</div>
	</div>
	<div class='listWrap' >
		<ul id='carInfoList' data-role="listview" data-inset="false"  class='dataList'>
			<li><a href="#">
				<img class="ui-li-thumb" />
				<h2>
				<img src="http://static.naver.net/m/auto/img/emblem/mnfco_16.png" width='35' height='35' style='vertical-align: middle;display: inline-block;'>
				<div style='vertical-align: middle;display: inline-block;'>K3</div>
				</h2>
				<p class="ui-li-aside lastedModify">33루1234</p>
				<p>가솔린 · 5,000km </p>
				<p>1,000 만원</p>
			</a></li>
			<li><a href="#">
				<img class="ui-li-thumb" />
				<h2>
				<div class='car-comp car-comp-1' style='vertical-align: middle;display: inline-block;width:35px;height:35px;'></div>
				<div style='vertical-align: middle;display: inline-block;'>K3</div>
				</h2>
				<p class="ui-li-aside lastedModify">33루1234</p>
				<p>가솔린 · 5,000km </p>
				<p>1,000 만원</p>
			</a></li>
			<li><a href="#">
				<img class="ui-li-thumb" />
				<h2>
				<div class='car-comp car-comp-1' style='vertical-align: middle;display: inline-block;width:35px;height:35px;'></div>
				<div style='vertical-align: middle;display: inline-block;'>K3</div>
				</h2>
				<p class="ui-li-aside lastedModify">33루1234</p>
				<p>가솔린 · 5,000km </p>
				<p>1,000 만원</p>
			</a></li>
			<li><a href="#">
				<img class="ui-li-thumb" />
				<h2>
				<img src="http://static.naver.net/m/auto/img/emblem/mnfco_16.png" width='35' height='35' style='vertical-align: middle;display: inline-block;'>
				<div style='vertical-align: middle;display: inline-block;'>K3</div>
				</h2>
				<p class="ui-li-aside lastedModify">33루1234</p>
				<p>가솔린 · 5,000km </p>
				<p>1,000 만원</p>
			</a></li>
			<li><a href="#">
				<img class="ui-li-thumb" />
				<h2>
				<img src="http://static.naver.net/m/auto/img/emblem/mnfco_16.png" width='35' height='35' style='vertical-align: middle;display: inline-block;'>
				<div style='vertical-align: middle;display: inline-block;'>K3</div>
				</h2>
				<p class="ui-li-aside lastedModify">33루1234</p>
				<p>가솔린 · 5,000km </p>
				<p>1,000 만원</p>
			</a></li>
		</ul>
	</div>
	</div>
	<!--// main_content  -->
</form>

</div><!-- main -->

<!-- 화면 하단 include  -->
<!-- ################################# bottom.jsp -->
<!-- <div class='footer'>
	<h1 style='text-align: center;'>Footer</h1>
</div> -->
<c:import url="/mgr/mgr0006/MGR0006$DetailSearch.do"></c:import>
</div><!-- page -->
<script>
$(document).ready(function(){
	$(".main_content").trigger('create');
	$j.initDocument();
});
</script>
<!-- ################################# bottom.jsp -->
<!-- ############################################################################################################################################ -->
<!-- 코드등록/수정화면 시작 -->
<!-- second page start -->
<c:import url="/mgr/mgr0006/MGR0006$Insert.do"></c:import>
<!-- 코드등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>