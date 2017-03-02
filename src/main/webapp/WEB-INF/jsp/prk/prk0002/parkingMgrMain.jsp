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
/* First breakpoint is 48em (768px). 3 column layout. Tiles 250x250 pixels incl. margin at the breakpoint. */
.main_content .ui-listview li h2{
	margin-top:0.8em;
}
.main_content .ui-listview{
	margin:0 -1em;
}
@media ( min-width: 48em ) {
	.main_content .ui-listview li h2 {
		color:#fff;
	}
	/* A bit custom styling */
	.main_content .ui-listview li .ui-btn p {
	color: #c0c0c0;
	}
	.main_content .ui-listview li .ui-btn .ui-li-aside {
	color: #eee;
	font-size:0.9em;
	}
	.main_content  {
	padding: .5625em; /* 9px */
	}
	.main_content .ui-listview li {
	float: left;
	width: 30.9333%; /* 33.3333% incl. 2 x 1.2% margin */
	height: 14.5em; /* 232p */
	margin: .5625em 1.2%;
	}
	.main_content .ui-listview li > .ui-btn {
	-webkit-box-sizing: border-box; /* include padding and border in height so we can set it to 100% */
	-moz-box-sizing: border-box;
	box-sizing: border-box;
	height: 100%;
	}
	.main_content .ui-listview li.ui-li-has-thumb .ui-li-thumb {
	height: auto; /* To keep aspect ratio. */
	max-width: 100%;
	max-height: none;
	}
	/* Make all list items and anchors inherit the border-radius from the UL. */
	.main_content .ui-listview li,
	.main_content .ui-listview li .ui-btn,
	.main_content .ui-listview .ui-li-thumb {
	-webkit-border-radius: inherit;
	border-radius: inherit;
	}
	/* Hide the icon */
	.main_content .ui-listview .ui-btn-icon-right:after {
	display: none;
	}
	/* Make text wrap. */
	.main_content .ui-listview h2,
	.main_content .ui-listview p {
	white-space: normal;
	overflow: visible;
	position: absolute;
	left: 0;
	right: 0;
	}
	/* Text position */
	.main_content .ui-listview h2 {
	font-size: 1.25em;
	margin: 0;
	padding: .125em 1em;
	bottom: 50%;
	}
	.main_content .ui-listview p {
	font-size: 1em;
	margin: 0;
	padding: 0 1.25em;
	min-height: 50%;
	bottom: 0;
	}
	/* Semi transparent background and different position if there is a thumb. The button has overflow hidden so we don't need to set border-radius. */
	.ui-listview .ui-li-has-thumb h2,
	.ui-listview .ui-li-has-thumb p {
	background: #111;
	background: rgba(0,0,0,.8);
	}
	.ui-listview .ui-li-has-thumb h2 {
	bottom: 35%;
	}
	.ui-listview .ui-li-has-thumb p {
	min-height: 35%;
	}
	/* ui-li-aside has class .ui-li-desc as well so we have to override some things. */
	.main_content .ui-listview .ui-li-aside {
	padding: .125em .625em;
	width: auto;
	min-height: 0;
	top: 0;
	left: auto;
	bottom: auto;
	/* Custom styling. */
	background: #990099;
	background: rgba(153,0,153,.85);
	background: #044363;
	-webkit-border-top-right-radius: inherit;
	border-top-right-radius: inherit;
	-webkit-border-bottom-left-radius: inherit;
	border-bottom-left-radius: inherit;
	-webkit-border-bottom-right-radius: 0;
	border-bottom-right-radius: 0;
	}
	/* If you want to add shadow, don't kill the focus style. */
	.main_content .ui-listview li {
	-moz-box-shadow: 0px 0px 9px #111;
	-webkit-box-shadow: 0px 0px 9px #111;
	box-shadow: 0px 0px 9px #111;
	}
	/* Images mask the hover bg color so we give desktop users feedback by applying the focus style on hover as well. */
	.main_content .ui-listview li > .ui-btn:hover {
	-moz-box-shadow: 0px 0px 12px #33ccff;
	-webkit-box-shadow: 0px 0px 12px #33ccff;
	box-shadow: 0px 0px 12px #33ccff;
	}
	/* Animate focus and hover style, and resizing. */
	.main_content .ui-listview li,
	.main_content .ui-listview .ui-btn {
	-webkit-transition: all 500ms ease;
	-moz-transition: all 500ms ease;
	-o-transition: all 500ms ease;
	-ms-transition: all 500ms ease;
	transition: all 500ms ease;
	}
	.splitStr {
		display: none;
	}
	.enter{
		display: block;
	}
}
/* Second breakpoint is 63.75em (1020px). 4 column layout. Tiles will be 250x250 pixels incl. margin again at the breakpoint. */
@media ( min-width: 63.75em ) {
	.main_content .ui-listview li h2 {
		color:#fff
	}
	/* A bit custom styling */
	.main_content .ui-listview li .ui-btn p {
	color: #c0c0c0;
	}
	.main_content .ui-listview li .ui-btn .ui-li-aside {
	color: #eee;
	font-size: 0.9em;
	}
	.main_content  {
	padding: .625em; /* 10px */
	}
	/* Set a max-width for the last breakpoint to prevent too much stretching on large screens.
	By setting the max-width equal to the breakpoint width minus padding we keep square tiles. */
	.main_content .ui-listview {
	max-width: 62.5em; /* 1000px */
	margin: 0 auto;
	}
	/* Because of the 1000px max-width the width will always be 230px (and margin left/right 10px),
	but we stick to percentage values for demo purposes. */
	.main_content .ui-listview li {
	width: 23%;
	height: 230px;
	margin: .625em 1%;
	}
}


.splitStr {
	margin:0 1em;
}
.prkTitle {
	font-size:0.9em;
	display: inline-block;
	min-width: 2em; 
}
.prkValue {
	font-size:1.3em;
	color:#888;
	font-weight: bold;
}
.usedValue {
	padding-left:0.2em;
	color:orange;
}
.lastedModify {
	color:#aaa;
}
/* For this demo we used images with a size of 310x310 pixels. Just before the second breakpoint the images reach their max width: 1019px - 2 x 9px padding = 1001px x 30.9333% = ~310px */
</style>
<!-- form 단위로 이루어진 content -->
<form name='prkMainFrm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
		<span id='tester'>관리페이지는 import, 주차장조회페이지는 location으로 아예 페이지를 이동하자</span>
		<ul data-role="listview" data-inset="false">
			<li><a href="#">
				<img src="/lfc/images/test.png" class="ui-li-thumb">
				<h2>8F</h2>
				<p class="ui-li-aside lastedModify">최종수정일 | 2017. 03. 02</p>
				<p>
					<span class='prkTitle'>수용</span>	<span class='prkValue'>354</span><span class='splitStr'>|</span><span class='enter'></span> 
					<span class='prkTitle'>소유</span>	<span class='prkValue'>125</span><span class='splitStr'>|</span><span class='enter'></span>
					<span class='prkTitle'>사용중</span><span class='prkValue usedValue'>102</span>
				</p>
			</a></li>
			<li><a href="#">
				<img src="/lfc/images/test.png" class="ui-li-thumb">
				<h2>5F</h2>
				<p class="ui-li-aside lastedModify">최종수정일 | 2017. 03. 02</p>
				<p>
					<span class='prkTitle'>수용</span>	<span class='prkValue'>354</span><span class='splitStr'>|</span><span class='enter'></span> 
					<span class='prkTitle'>소유</span>	<span class='prkValue'>125</span><span class='splitStr'>|</span><span class='enter'></span>
					<span class='prkTitle'>사용중</span><span class='prkValue usedValue'>102</span>
				</p>
			</a></li>
			<li><a href="#">
				<img src="/lfc/images/test.png" class="ui-li-thumb">
				<h2>1F</h2>
				<p class="ui-li-aside lastedModify">최종수정일 | 2017. 03. 02</p>
				<p>
					<span class='prkTitle'>수용</span>	<span class='prkValue'>354</span><span class='splitStr'>|</span><span class='enter'></span> 
					<span class='prkTitle'>소유</span>	<span class='prkValue'>125</span><span class='splitStr'>|</span><span class='enter'></span>
					<span class='prkTitle'>사용중</span><span class='prkValue usedValue'>102</span>
				</p>
			</a></li>
			<li><a href="#">
				<img src="/lfc/images/test.png" class="ui-li-thumb">
				<h2>B2F</h2>
				<p class="ui-li-aside lastedModify">최종수정일 | 2017. 03. 02</p>
				<p>
					<span class='prkTitle'>수용</span>	<span class='prkValue'>354</span><span class='splitStr'>|</span><span class='enter'></span> 
					<span class='prkTitle'>소유</span>	<span class='prkValue'>125</span><span class='splitStr'>|</span><span class='enter'></span>
					<span class='prkTitle'>사용중</span><span class='prkValue usedValue'>102</span>
				</p>
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