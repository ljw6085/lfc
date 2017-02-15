<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE script PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
	<%@ include file="/WEB-INF/jsp/cmm/resources.jsp" %>
	<script>
		$.mobile.page.prototype.options.domCache = true;
		var url = location.pathname;
		$(document).ready(function(){
			
			$(".grid-box").addClass('ui-btn');//ui-shadow ui-corner-all
			
			$("#menuPanel").panel();
			MENU.createMenuButton( 'indexMenu_page1' ,'user');
			MENU.createMenuButton( 'indexMenu_page2' ,'user');
			
			$("#codeList").bind('click',function(e){
				location.href=CONTEXT_PATH+'/mgr/mgr0002/codeList.do';
			});
			$("#menuList").bind('click',function(e){
				location.href=CONTEXT_PATH+'/mgr/mgr0001/menuList.do';
			});
			
			$(window).resize(function(e){
				var grdW = $(".ui-grid-a").width() / 2;
				grdW -= 10;
				var w = grdW;
				if( w > 190 ) w = 190;
				$(".grid-box")
					.width( w )
					.height( w );
			}).trigger('resize');
			
			$("#logout").bind('click',function(){
				location.href=CONTEXT_PATH+"/cmm/login/logout.do";
			});
		})
		.on('swipeleft','.ui-page',function(e){
			navnext( url+"#page2" );
			$("#pageNaiv").text(" ○ ● ");
		})
		.on('swiperight','.ui-page',function(e){
			navprev( url+"#page1" );
			$("#pageNaiv").text(" ● ○ ");
		});
		
		
		function navnext( next ) {
		    $( ":mobile-pagecontainer" ).pagecontainer( "change", next , {
		        transition: "slide"
		    });
		}
		function navprev( prev ) {
		    $( ":mobile-pagecontainer" ).pagecontainer( "change",prev, {
		        transition: "slide",
		        reverse: true
		    });
		}
		
		</script>
	<style>
		.ui-panel-wrapper { background: #eee !important;}
	</style>
</head>
<body>
<!-- form 단위로 이루어진 content -->
<div data-role="page" id='page1' >
	<div data-role="header" data-position='fixed' id='indexMenu_page1'>
		<h1>LFC</h1>
	</div>
	<div role='main' class='ui-content ui-index'>
		<div class="ui-grid-a">
		    <div class="ui-block-a block">
		    	<div class='grid-box'>
		    		<div>차량정보조회</div>
			    	<div><img src='<c:url value="/images/car_select_.png"/>' width='50%'></div>
		    	</div>
		    </div>
		    <div class="ui-block-b block">
		    	<div class='grid-box'>
		    		<div >주차정보조회</div>
		    		<div><img src='<c:url value="/images/parking_select_.png"/>' width='50%'></div>
		    	</div>
		    </div>
		    <div class="ui-block-a block">
		    	<div class='grid-box'>
		    		<div>공지사항</div>
		    		<div><img src='<c:url value="/images/notice_icon_.png"/>' width='50%'></div>
		    	</div>
		    </div>
		    <div class="ui-block-b block">
		    	<div class='grid-box' id='codeList'>
		    		<div>차량코드조회</div>
		    		<div><img src='<c:url value="/images/car_code_select_.png"/>' width='50%'></div>
	    		</div>
		    </div>
		    <div class="ui-block-a block">
		    	<div class='grid-box '>
		    		<div>차량정보관리</div>
		    		<div><img src='<c:url value="/images/car_info_mgr_.png"/>' width='50%'></div>
		    	</div>
		    </div>
		    <div class="ui-block-b block">
		    	<div class='grid-box '>
		    		<div>주차정보관리</div>
		    		<div><img src='<c:url value="/images/parking_info_mgr_.png"/>' width='50%'></div>
	    		</div>
		    </div>
		</div><!-- /grid-c -->
	</div>
</div>
<div data-role="page" id='page2'>
	<div data-role="header" data-position='fixed' id='indexMenu_page2'> 
		<h1>LFC - Manager</h1> 
	</div>
	<div role='main' class='ui-content ui-index'>
		<div class="ui-grid-a">
		    <div class="ui-block-a block">
		    	<div class='grid-box '>
		    	<div>공지사항관리</div>
	    		<div><img src='<c:url value="/images/notice_mgr.png"/>' width='50%'></div>
		    </div>
		    </div>
		    <div class="ui-block-b block">
		    	<div class='grid-box ' id='menuList'>
		    		<div>운영관리</div>
		    		<div><img src='<c:url value="/images/op_mgr.png"/>' width='50%'></div>
		    	</div>
		    </div>
		</div><!-- /grid-c -->
	</div>
</div>
<div id="menuPanel" data-role='panel' data-position='left' data-display='push'>
	ID : ${sessionScope.userId }
	이름 : ${sessionScope.userNm }
	권한 : ${sessionScope.userAuth }
	<div id='logout'>로그아웃</div>
</div>
<div id='pageNaiv' style='position:fixed; z-index: 9999;bottom:0;left:50%;margin-left:-19px;'> ● ○ </div>
</body>
</html>