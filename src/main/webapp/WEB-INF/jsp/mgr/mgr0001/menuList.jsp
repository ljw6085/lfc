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
	var sortableManager = {
			movingTarget:[]	
			,wscrolltop:0
	}
	makeMenuList( MENU.TREE.data.child );
	
	var clicked = false;
	// 하위메뉴class add
	$(".menuDataList > tr").hover(function(){
		rowHoverFunction.call(this, 'over' ,clicked );
	},function(){
		rowHoverFunction.call(this, 'out' ,clicked );
	});
	$("#dialog").popup();
	//********************************* EVENT BIND------------------------------------------------------------------------------------
	var rIdx=0;
	$(".menuDataList").on('click' , '.btnIcon' ,function(e){
		var curRow = $(e.target).closest('tr')
			,curId = curRow.attr('data-menu-id')
			,menuInfo = MENU.TREE.getById(curId);
		
		switch (true) {
			case $(e.target).hasClass('menuDel'): // 메뉴삭제
				var childs = getChildes( curRow ) ;
				for( var i in  childs ) $(childs[i]).remove();
				curRow.remove();
				break;
			case $(e.target).hasClass('menuMgr'): //메뉴관리(팝업)
				$("#dialog").popup("open",{
					transition:'pop'
				});
				break;
			case $(e.target).hasClass('menuAdd'): //메뉴추가
				var newMenuInfo = {}
				$.extend(newMenuInfo , menuInfo);
				newMenuInfo.menuNm 	= "메뉴명을입력하세요.";
				newMenuInfo.menuUrl = "URL을 입력하세요.";
				newMenuInfo.menuPid = menuInfo.menuId;
				newMenuInfo.depth 	= menuInfo.depth+1;
				newMenuInfo.menuId 	= "new_"+(rIdx++);
				var $tr = makeRow(newMenuInfo);
				curRow.after($tr);
				$j.refreshPage();
				break;
			default:
				break;
		}
	});
	
	// sortable 전 mousedown 이벤트로 선행작업을 실행한다.
	$(".menuDataList").bind('mousedown',function(e){
		clicked = true;
		var tbody = $(this)
			,$row = $(e.target).closest('tr')
			,pid = $row.attr("data-menu-pid");
		
		tbody
			.find('[data-menu-pid="'+pid+'"]')
				.addClass('this')
			.end()
			.find("tr:not(.this)")
				.addClass('disabled');
		
	}).bind('mouseup',function(e){
		clicked = false;
		$(".this").removeClass("this");
		$(".disabled").removeClass("disabled");
		
	}).bind('click',function(e){ // menu Folder
		if( e.target.tagName == 'INPUT' || $(e.target).hasClass('move_icon')|| e.target.tagName == 'A')return;
		
		var $row = $(e.target).closest('tr') 
			, childs = getChildes( $row ) ;
			$row.toggleClass('hiddenChilds','');
		
		var isHide = $row.hasClass('hiddenChilds');
		for( var i in  childs ){
			var child = $(childs[i]); 
			child.removeClass('hiddenChilds');
			if( isHide ) child.hide();
			else 		 child.show();
		}
		
	}).sortable({
		// drag&drop
        handle		: ".move_icon"
        ,opacity	: 0.7
		,items		:"tr:not(.disabled)"
		,placeholder: "placeholderBox"
		,axis		:'y'
		,start		:function(e,ui){
			ui.placeholder.height( ui.item.height() );
			sortableManager.movingTarget = getChildes( ui.item , ui.placeholder );
			sortableManager.wscrolltop = $(window).scrollTop();
		}
		,sort		: function(e,ui){
			// 유효하지 않은 움직임은 보여주지말자
			if( ui.placeholder.next('tr').attr('data-depth') != ui.item.attr('data-depth') ) ui.placeholder.hide();
			else ui.placeholder.show();
		}
		,stop		: function(e, ui){
			// 유효하지 않은 움직임은 cancel 시킨다.
			if( ui.item.next('tr').attr('data-depth') != ui.item.attr('data-depth') ) $(this).sortable('cancel');
			
			// 배열에 저장해놓은 자식객체들을 이동시킨다.
			var mt = sortableManager.movingTarget;
			for(var i = mt.length-1 ,len=0;i>=len;i--) ui.item.after(  mt[i]  );
			
			// hide시켰던 자식들을 show 시킴.
			$('.movingSelected').show().removeClass('movingSelected');
			
			// 배열초기화
			sortableManager.movingTarget = [];
		},
		helper		: function(e, ui) {
			ui.children().each(function() {  
			    $(this).width($(this).width());  
			  });  
			  return ui; 
		}
		
	}).disableSelection();
	
	$j.refreshPage();
	
	
// ************************************* FUNCTION AREA *****************
function rowHoverFunction( type, clicked ){
		var $t = $(this);
		switch (type) {
			case 'over':
				if( clicked ) return;
				var rows = getChildes( $t );
				for( var i in rows ) $(rows[i]).addClass('mouseoverClass');
				$t.addClass('mouseoverMainClass');
				break;
			case 'out':
				var rows = getChildes( $t );
				for( var i in rows ) $(rows[i]).removeClass('mouseoverClass');
				$t.removeClass('mouseoverMainClass');
				break;
		}
}
//현재 row의 자식 menu들을 반환한다.
function getChildes($row, placeholder){
	var pid = $row.attr("data-menu-pid")
		,depth = $row.attr("data-depth");
	var _holder = $row;
	if(placeholder) _holder = placeholder;
	var movingTarget = [];
	var _nxt = _holder.next();
	while(true){
		if( _nxt.length && _nxt.attr('data-depth') > depth ){
				movingTarget.push( _nxt );
				if(placeholder) _nxt.hide().addClass("movingSelected");
		}else {
			break;
		}
		_nxt = _nxt.next();
	}
	return movingTarget;
}

// Menu List를 생성한다.
var topMenuCounter = 0;
function makeMenuList( mData ){
	for( var i = 0 , len=mData.length;i<len;i++){
		var mnInfo = mData[i]; 
		var $tr = makeRow(mnInfo);
		$(".menuDataList").append($tr);
		
		if( mnInfo.child.length > 0) arguments.callee( mnInfo.child ); // 하위메뉴가 있으면 재귀
	}
}
function makeRow(mnInfo){
	mnInfo.blankBox= "<div style='display:inline-block;width:"+mnInfo.depth*20+"px;height:20px;'>&nbsp;</div>";
	mnInfo.mgrBtn = "<a href='#' class='btnIcon menuMgr' data-icon='gear' ></a>";
	mnInfo.addBtn = "<a href='#' class='btnIcon menuAdd' data-icon='plus' ></a>";
	mnInfo.delBtn = "<a href='#' class='btnIcon menuDel' data-icon='delete' data-color='red'></a>";
	if( mnInfo.depth > 1 ) mnInfo.addBtn = mnInfo.blankBox;
	// %{ ... } 형태로 key 값을 매핑시킨다.
	var tr = "<tr id='%{menuId}' class='imMenu'>"; 
		tr += "<td style='text-align:center;' ><div class='move_icon'></div></td>"; // menu명
// 		tr += "<td style='text-align: center;'>%{addBtn}</td>"; // detail
		tr += "<td style='border-left:0'>%{blankBox}%{menuNm}%{addBtn}</td>"; // menu명
		tr += "<td>%{menuUrl}</td>"; // url
		tr += "<td><input type='checkbox' class='txtC'></td>"; // useAt
		tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -1
		tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -2
		tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -3
		tr += "<td><input type='checkbox' class='txtC'></td>"; // userAuth -4
		tr += "<td style='text-align: center;'>%{mgrBtn}</td>"; // detail
		tr += "<td style='text-align: center;'>%{delBtn}</td>"; // detail
		tr += "</tr>";
	var newTr = Common.matchedReplace( tr, mnInfo );
	
	var $tr =$(newTr);
	for(var k in mnInfo){
		var data = mnInfo[k];
		if( k == 'menuPid' && !data )$tr.attr('data-menu-pid','NULL');
		if( typeof data == 'object' || typeof data == 'undefined') continue;
		var newK = strLib.toUnderScore( k , false, '-');
		$tr.attr('data-'+newK, data );
	}
	return $tr;
}
});
</script>
<style>
	.ui-btn-icon-left:after, .ui-btn-icon-right:after, .ui-btn-icon-top:after, .ui-btn-icon-bottom:after, .ui-btn-icon-notext:after{
		width:20px;
		height:20px;
	}
	.ui-mini.ui-btn-icon-notext{
		font-size: 10px;
	}
	.ui-btn-icon-notext:after, .ui-btn-icon-top:after, .ui-btn-icon-bottom:after{
		margin-left: -10px;
	}
	.ui-btn-icon-notext:after, .ui-btn-icon-left:after, .ui-btn-icon-right:after{
		margin-top: -10px;
	}
</style>
<!-- form 단위로 이루어진 content -->
<form name='menuSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content' style='min-width:900px;'>
		<div>
			<div class='buttonBox' style='margin:.5em 0;'>
				<a href='#' id='insert' class='btn' data-icon='check'>저장</a>
				<a href='#' id='select' class='btn' data-icon='refresh' data-color='gray'>초기화</a>
			</div>
		</div>
		<div id='menuLoadList'>
			<table class='defaultTable menuListTable'>
				<colgroup>
					<col style='width:5%'/>
<%-- 					<col style='width:6%'/> --%>
					<col style='width:25%'/>
					<col style='width:*'/>
					<col style='width:5%'/>
					
					<col style='width:6%'/>
					<col style='width:6%'/>
					<col style='width:6%'/>
					<col style='width:6%'/>
					<col style='width:6%'/>
					<col style='width:6%'/>
				</colgroup>
				<thead>
					<tr>
						<th rowspan='2'>순서</th>
<!-- 						<th rowspan='2'>추가</th> -->
						<th rowspan='2'>메뉴명</th>
						<th rowspan='2'>URL</th>
						<th rowspan='2'>사용<br/>여부</th>
						<th colspan='4'>메뉴권한</th>
						<th rowspan='2'>관리</th>
						<th rowspan='2'>삭제</th>
					</tr>
					<tr>
						<th>일반<br/>사용자</th>
						<th>업무<br/>사용자</th>
						<th>업무<br/>관리자</th>
						<th>운영<br/>관리자</th>
					</tr>
				</thead>
				<tbody class='menuDataList'> </tbody>
			</table>
		</div>
	</div>
	<!--// main_content  -->
</form>
	<div id="dialog" data-role="popup" data-overlay-theme="a" data-theme="a" style='width:500px'>
	  <form>
	        <div style="padding:10px 20px;">
	            <h3>Please sign in</h3>
	            <label for="un" class="ui-hidden-accessible">Username:</label>
	            <input type="text" name="user" id="un" value="" placeholder="username" data-theme="a">
	            <label for="pw" class="ui-hidden-accessible">Password:</label>
	            <input type="password" name="pass" id="pw" value="" placeholder="password" data-theme="a">
				<button type="submit" class="ui-btn ui-corner-all ui-shadow ui-btn-b ui-btn-icon-left ui-icon-check">Sign in</button>
				<a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-b" data-rel="back">Cancel</a>
				<a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-b" data-rel="back" data-transition="flow">Delete</a>
	        </div>
	    </form>
	</div>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>