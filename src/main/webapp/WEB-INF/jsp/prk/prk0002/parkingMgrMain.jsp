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
		<ul data-role="listview" data-inset="true">
			<li><a href="#">
				<img src="../_assets/img/apple.png" class="ui-li-thumb">
				<h2>iOS 6.1</h2>
				<p>Apple released iOS 6.1</p>
				<p class="ui-li-aside">iOS</p>
			</a></li>
			<li><a href="#">
				<img src="../_assets/img/blackberry_10.png" class="ui-li-thumb">
				<h2>BlackBerry 10</h2>
				<p>BlackBerry launched the Z10 and Q10 with the new BB10 OS</p>
				<p class="ui-li-aside">BlackBerry</p>
			</a></li>
			<li><a href="#">
				<img src="../_assets/img/lumia_800.png" class="ui-li-thumb">
				<h2>WP 7.8</h2>
				<p>Nokia rolls out WP 7.8 to Lumia 800</p>
				<p class="ui-li-aside">Windows Phone</p>
			</a></li>
			<li><a href="#">
				<img src="../_assets/img/galaxy_express.png" class="ui-li-thumb">
				<h2>Galaxy</h2>
				<p>New Samsung Galaxy Express</p>
				<p class="ui-li-aside">Samsung</p>
			</a></li>
			<li><a href="#">
				<img src="../_assets/img/nexus_7.png" class="ui-li-thumb">
				<h2>Nexus 7</h2>
				<p>Rumours about new full HD Nexus 7</p>
				<p class="ui-li-aside">Android</p>
			</a></li>
			<li><a href="#">
				<img src="../_assets/img/firefox_os.png" class="ui-li-thumb">
				<h2>Firefox OS</h2>
				<p>ZTE to launch Firefox OS smartphone at MWC</p>
				<p class="ui-li-aside">Firefox</p>
			</a></li>
			<li><a href="#">
				<img src="../_assets/img/tizen.png" class="ui-li-thumb">
				<h2>Tizen</h2>
				<p>First Samsung phones with Tizen can be expected in 2013</p>
				<p class="ui-li-aside">Tizen</p>
			</a></li>
			<li><a href="#">
				<h2>Symbian</h2>
				<p>Nokia confirms the end of Symbian</p>
				<p class="ui-li-aside">Symbian</p>
			</a></li>
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