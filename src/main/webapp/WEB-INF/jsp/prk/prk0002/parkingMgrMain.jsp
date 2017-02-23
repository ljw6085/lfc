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
	$j.documentReady('prkMainFrm', function($form,$uiPage){
		var managerPage = '#parkingMgrInsert';
		
		$m.openMenuFromSwipe($uiPage);
		
		$('#tester').on('click',function(e){
			$j.pageMove( managerPage , {
				test:'moving!'
			});
		})
	});
});
</script>
<style>
	.parkFloorList a { padding-top:0; padding-bottom:0; padding-left:0; border-bottom: .5em solid #ddd !important;}
	.parkFloorList a.lastFloor { padding-top:0; padding-bottom:0; padding-left:0; border-bottom: 1px solid #ddd !important;}
	.parkFloorList div { border-right:1px solid #ddd;}
</style>
<!-- form 단위로 이루어진 content -->
<form name='prkMainFrm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
		<span id='tester'>관리페이지는 import, 주차장조회페이지는 location으로 아예 페이지를 이동하자</span>
		<ul class='parkFloorList' data-role="listview" data-count-theme="b" data-inset="true">
			<li>
				<a href="#">
					<div style='height:80px;display: block;'></div>
					<span class="ui-li-count">12</span>
				</a>
			</li>
			<li>
				<a href="#">
					<div style='height:80px;display: block;'></div>
					<span class="ui-li-count">0</span>
				</a>
			</li>
			<li>
				<a href="#">
					<div style='height:80px;display: block;'></div>
					<span class="ui-li-count">4</span>
				</a>
			</li>
			<li>
				<a href="#">
					<div style='height:80px;display: block;'></div>
					<span class="ui-li-count">329</span>
				</a>
			</li>
			<li>
				<a href="#" class='lastFloor'>
					<div style='height:80px;display: block;'></div>
					<span class="ui-li-count">62</span>
				</a>
			</li>
		</ul>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<!-- ############################################################################################################################################ -->
<!-- second page start -->
<c:import url="/prk/prk0002/parkingMgrInsert.do"></c:import>
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>