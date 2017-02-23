<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
/** -----------  POPUP ------------ Form 단위로 스크립팅 한다. */
$j.documentReady('menuPopupFrm', function(form,$uiPage){
	form.find(".popupMenuApply").on("click", function(){
		// menuId 자동채번
		var resultMenuId =  getNewMenuId();
		var result = Common.getDataFromDoms(form);
		//[1] menuId 자동채번 후 세팅
		result.menuId = resultMenuId;
		
		var clickedId = result.tempRowId;
		for( var k in result ){
			if( k == 'tempRowId') continue;
			var newK = strLib.toUnderScore( k , false, '-');
				$("#"+clickedId).setAttr('data-'+newK , result[k]);
		}
		$("#"+clickedId).attr('id', result.menuId );
		$("#"+result.menuId)
			.find('span.menuNmText').text( result.menuNm )
			.end()
			.find('span.menuUrlText').text( result.menuUrl );
		
		form.find(".popupMenuClose").trigger('click');
	});
	
	// icon 관련 이벤트
	var $iconListArea = $("#iconArea");
	form.find("#popupIcon").on('click',function(){
		var w = $iconListArea.width();
		var h = $iconListArea.height();
		$iconListArea.css({
			'margin-left': w/2 * -1 + 'px'
			,'margin-top': h/2 * -1 + 'px'
		});
		$iconListArea.slideDown('fast');
	});
	form.find(".iconClose").on('click',function(){
		$iconListArea.slideUp('fast');
	});
	form.find(".iconList li").on('click',function(){
		var icon = $(this).find(".text").text();
		$("#setIconName").text(icon);
		form[0].menuIcon.value = icon;
		$iconListArea.slideUp('fast');
	});
	
/**  메뉴ID 자동채번 함수 */
function getNewMenuId(){
	var	pageMaxMenuNum = 0 ,dbMaxMenuNum = 0
	//max menu Id setting
	$(".menuDataList").find('.imMenu').each(function(i){
		var num = +this.id.substring(1);
		if( pageMaxMenuNum < num ) pageMaxMenuNum = num;
	});
	pageMaxMenuNum++; // 현재페이지에서의 menuId max값
	
	var url = "<c:url value='/mgr/mgr0001/getMaxMenuId.do'/>";
	Common.ajaxJson(url,null,function(result){
		dbMaxMenuNum = +result.menuId.substring(1)  // DB에서의 menuId max값
	},'post',false);
	
	// 두 max값을 비교해서 더 큰 max값을 이용하여 채번한다.
	var maxId = (dbMaxMenuNum >= pageMaxMenuNum )? dbMaxMenuNum : pageMaxMenuNum ;
	var resultMenuId = 'M'+ strLib.fillLeft(maxId+'',4,'0');	
	return resultMenuId ;
}
});


/** -------- MAIN --------- Form 단위로 스크립팅 한다. */
$j.documentReady('menuSelectForm', function(form,$uiPage){
/********************************** 전역변수 */
	var sortableManager = {
			movingTarget:[]	
	}
	var clicked = 	false;
	var rIdx	=	0;
	var $menuDataList = $uiPage.find(".menuDataList");
	
/********************************* INITAILIZE AREA */
	// popup 초기화
	$("#dialog").popup();
	
	// ROOT Btn Area Append
	var colCnt = $('.menuListTable').find("col").length;
	var rootTr ="<tr data-menu-pid='null' data-menu-id='newRoot' data-depth='0'>";
		rootTr+="<td><a href='#' class='btnIcon menuAdd' data-icon='plus' ></a></td>";
		rootTr+="<td colspan='"+(colCnt-1)+"'></td></tr>";
	
	$menuDataList.append( rootTr );
	
	// MENU List Create
	makeMenuList( MENU.TREE.data.child );
	
	$uiPage.find(".buttonBox").on('click',function(e){
		
		switch (e.target.id) {
			case 'save':
				/** 지금은 귀찮아서 menu 등록시, 메뉴를 전체 삭제한 후, 그냥 다시 insert한다.
					나중에 안귀찮을때,
					추가 또는 수정되거나 삭제된 메뉴에 대해서는 flag를 따로 주어 넘긴후,
					flag에 맞게 update/delete/insert 하도록 수정하자
				*/
				var param = [];
				$menuDataList.find(".imMenu").each(function(i){
					var o = {};
					var data = $(this).data();
					$.extend(o,data);
					delete o.sortableItem;
					if( o.menuPid.toUpperCase() == 'NULL') o.menuPid = null;
					o.sort = i;
					param.push( o );
				});
				var url = "<c:url value='/mgr/mgr0001/menuInert.do'/>";
				Common.ajaxJson(url,param,function(e){
					console.log( e );
				});
				
				break;
			case 'reset':
				$(".imMenu").remove();
				makeMenuList( MENU.TREE.data.child );
				$j.refreshPage();
				break;
		}
	});

	function convertDataAttribute( dom ){
		
	}
/********************************** EVENT BIND AREA 
	target : $(".menuDataList")
	events : mouse[enter,leave, down, up, click], sortable
 */
$menuDataList
	.on( 'mouseenter','.imMenu', function(e){
		rowHoverFunction.call(this, 'over' ,clicked );
	})
	.on( 'mouseleave','.imMenu', function(e){
		rowHoverFunction.call(this, 'out' ,clicked );
	})
	.on('change', '.authChk, .useAtChk' ,function(e){
		var t = e.target , $row = $(t).closest('tr') , auth = +$row.attr('data-use-auth');
		if( $(t).hasClass('useAtChk')){// 사용여부 체크박스
		
			if( t.checked ){
				$row.setAttr('data-use-at','Y');
			}else{
				$row.setAttr('data-use-at','N');
			}
		
		}else if( !isNaN( auth ) ){ // 권한체크박스
			var _auth = 0;
			$row.find( '.authChk:checked').each(function(e){
				_auth += +this.value;
			});
			$row.setAttr('data-use-auth',_auth);
		}
	})
	.on('mousedown',function(e){
		// sortable 전 mousedown 이벤트로 선행작업을 실행한다.
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
		
	})
	.on('mouseup',function(e){
		// 초기화
		clicked = false;
		$(".this").removeClass("this");
		$(".disabled").removeClass("disabled");
		
	})
	.on('click',function(e){ // menu Folder
		var target = e.target;
		var $row = $(target).closest('tr');	
		
		switch (true) {
			//[1] click target이 moving일때
			case $(target).hasClass('move_icon'):
				return;
				break;

			//[2] click target이 버튼일때
			case target.tagName == 'A':
				mgrButtonClickFunction( $(target) );
				return;
				break;
				
			//[3] click target이 checkbox 일때
			case target.type == 'checkbox':
				setCheckboxChangeFunction($row, target);
				return;
				break;
			
			//[4] 새로 생성된 row를 클릭한 경우 메뉴등록화면을 보여주자
			case  $row[0].id.indexOf('_new_') > -1 :
				console.log( $row.find(".menuMgr") );
				$row.find(".menuMgr").trigger('click');	
				return;
				break;
	
			// 그외에는 row folder
			default:
				var $row = $(target).closest('tr') 
				, childs = getChildes( $row ) ;
				$row.toggleClass('hiddenChilds','');
			
				var isHide = $row.hasClass('hiddenChilds');
				for( var i in  childs ){
					var child = childs[i]; 
					child.removeClass('hiddenChilds');
					if( isHide ) child.hide();
					else 		 child.show();
				}
				break;
		}
		
	})
	.sortable({
		// drag&drop
        handle		: ".move_icon"
        ,opacity	: 0.7
		,items		:"tr:not(.disabled)"
		,placeholder: "placeholderBox"
		,axis		:'y'
		,start		:function(e,ui){
			ui.placeholder.height( ui.item.height() );
			sortableManager.movingTarget = getChildes( ui.item , ui.placeholder );
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

/***** Page 최종 Refresh */
	$j.refreshPage();
	
	
/***************************************** FUNCTION AREA */
function setCheckboxChangeFunction( $row ,checkbox ){
	
	var auth = $(checkbox).attr('data-auth');
	var useAt = $(checkbox).hasClass('useAtChk');
	
	// 체크&체크해제 할 대상 체크박스를 찾는 selectQuery 세팅
	var targetCheckbox;
	if( auth ){
		targetCheckbox = '[data-auth="'+auth+'"]'; // 권한
	}else if ( useAt ){
		targetCheckbox = '.useAtChk'; // 사용여부
	}else{
		return;
	}
		
	var childs 	= getChildes($row)
		,pid 	= $row.attr('data-menu-pid')
		,id 	= $row.attr('data-menu-id')
		,chk 	= checkbox.checked;
	
	
	
	// 하위메뉴는 무조건 따라감(check/uncheck).
	for( var i in childs ){
		childs[i].find( targetCheckbox )
					.prop('checked',chk)
						.trigger('change');
	}
	
	if( chk ){
		// 체크된경우 무조건 자신의 부모를 체크함.
		var parents = getParents($row);
		for( var i in parents ){
			parents[i]
				.find( targetCheckbox )
					.prop('checked',chk)
						.trigger('change');
		}
	}else{
		// 체크안된경우 자신의 형제엘리먼트들 상태를 확인 후에,
		var siblings = $('[data-menu-pid="'+pid+'"]:not([data-menu-id="'+id+'"])'); 
		var isChecked=false;
		for(var i = 0 , len=siblings.length;i< len; i++ ){
			if($(siblings[i]).find( targetCheckbox ).prop('checked')){
				isChecked = true;
				break;
			}
		}
		
		// 형제엘리먼트가 한개라도 체크되있으면 넘어가고
		// 하나도 체크가 안되있는경우 부모엘리먼트를 체크해제한다.
		if( !isChecked ){
			var _row = $('[data-menu-id="'+pid+'"]'); // 1단계 위 부모
			var _checkBox = _row.find( targetCheckbox );
			if( _row.length > 0 && _checkBox.length > 0 ){
				_checkBox.prop('checked',isChecked).trigger('change');
				//부모메뉴의 또 부모가 있을 수 있으니, 재귀호출한다.
				arguments.callee( _row, _checkBox[0] );
			}
		}
	}
	
}
function mgrButtonClickFunction( target ){
	var curRow = target.closest('tr') 
		,curId = curRow.attr('data-menu-id')
// 		,menuInfo = MENU.TREE.getById(curId);
		,menuInfo = curRow.data();
	switch (true) {
		case target.hasClass('menuDel'): // 메뉴삭제
			var childs = getChildes( curRow ) ;
			for( var i in  childs ) childs[i].remove();
			curRow.remove();
			break;
		case target.hasClass('menuMgr'): //메뉴관리(팝업)
			
			var rowData = curRow.data() 
				, _openedId = curId; //temp
			if( curId.indexOf('_new_') == 0 ) curId = "";
			rowData.menuId = curId;
			
			setMenuEditPopup( rowData );
			openMenuEditPopup( _openedId );
			
			break;
		case target.hasClass('menuAdd'): //메뉴추가
		
			// 메뉴정보를 입력하지않은경우( 아직 id가 _new_x 인경우) 진행하지않음
			if( curId.indexOf('_new_') > -1) return;
			
			// 상위메뉴가 있는경우 상위메뉴를 상속받아 기본값으로 세팅
			var newMenuPid	= menuInfo.menuId,  
				newDepth 	= menuInfo.depth+1, 
				newUseAt	= menuInfo.useAt,   
				newUseAuth	= menuInfo.useAuth;
			
			// Root 메뉴인경우 기본값세팅
			if ( curId == 'newRoot' ){ 
				newMenuPid	= null;
				newDepth 	= 0;
				newUseAt	= 'Y';
				newUseAuth	= 15;
			}
			
			// 새로운메뉴 객체 정보
			var newMenuInfo = {
					menuId 	: "_new_"+(rIdx++), 
					menuNm 	: "",    
					menuUrl : "클릭하여 정보를 입력하세요.",
					menuIcon : "",              
					menuPid : newMenuPid,  
					depth 	: newDepth, 
					useAt	: newUseAt,   
					useAuth : newUseAuth
			};
			
			var $tr = makeRow( newMenuInfo );
			curRow.after($tr);
			$j.refreshPage();
			break;
		default:
			break;
	}
}
function rowHoverFunction( type, clicked ){
		var $t = $(this);
		switch (type) {
			case 'over':
				// row over
				if( clicked ) return;
				var rows = getChildes( $t );
				for( var i in rows ) rows[i].addClass('mouseoverClass');
				$t.addClass('mouseoverMainClass');
				
				// button over
				$t.find(".menuAdd, .menuMgr").each(function(){
					var t = $(this),tCls = 'ui-btn-color-gray'; 
					if( t.hasClass(tCls) )t.removeClass(tCls);
				});
				
				break;
			case 'out':
				// row out
				var rows = getChildes( $t );
				for( var i in rows ) rows[i].removeClass('mouseoverClass');
				$t.removeClass('mouseoverMainClass');
				
				// button out
				$t.find(".menuAdd, .menuMgr").each(function(){
					var t = $(this) ; 
					if( t.attr('data-color') == 'gray' ) t.addClass('ui-btn-color-gray');
				});
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

//현재 메뉴의 부모들을 반환한다.
function getParents($row ){
	var depth = $row.attr('data-depth');
	var p_id = $row.attr('data-menu-pid');
	var targets=[];
	var _prv = $row.prev();
	while(true){
		if( p_id.toUpperCase() == 'NULL' ) break;

		if( _prv.length && _prv.attr("data-menu-id") == p_id ){
			targets.push( _prv );
			p_id = _prv.attr('data-menu-pid');
		}
		_prv = _prv.prev();	
	}
	return targets;
}

// Menu List를 생성한다.
var topMenuCounter = 0;
function makeMenuList( mData ){
	for( var i = 0 , len=mData.length;i<len;i++){
		var mnInfo = mData[i]; 
		var $tr = makeRow(mnInfo);
		
// 		$(".menuDataList").append($tr);
		$menuDataList.append($tr);
		
		if( mnInfo.child.length > 0) arguments.callee( mnInfo.child ); // 하위메뉴가 있으면 재귀
	}
}
// Menu Row 생성
function makeRow(mnInfo){
	mnInfo.blankBox	= "<div style='display:inline-block;width:"+mnInfo.depth*20+"px;height:20px;'>&nbsp;</div>";
	mnInfo.mgrBtn 	= "<a href='#' class='btnIcon menuMgr' data-icon='gear' 	data-color='gray' ></a>";
	mnInfo.addBtn 	= "<a href='#' class='btnIcon menuAdd' data-icon='plus' 	data-color='gray' ></a>";
	mnInfo.delBtn 	= "<a href='#' class='btnIcon menuDel' data-icon='delete' 	data-color='red'></a>";
	mnInfo.useAtCheck = '';
	if( mnInfo.depth > 1 ) mnInfo.addBtn = mnInfo.blankBox;
	
	//사용여부 세팅
	if( mnInfo.useAt == 'Y' ) mnInfo.useAtCheck = 'checked';
	// 권한 세팅
	var authList = [1, 2, 4, 8];
	for( var i = 0 ; i < authList.length;i++){
		var val = authList[i];
		var _auth = '';
		if( mnInfo.useAuth && ( authList[i] &  mnInfo.useAuth ) ) _auth = 'checked';
		mnInfo['useAuth'+val] = val;
		mnInfo['useAuth'+val+'Chk'] = _auth;
	}
	
	// %{ ... } 형태로 key 값을 매핑시킨다. -- dom html
	var tr = "<tr id='%{menuId}' class='imMenu'>"; 
		tr += "<td style='text-align:center;' ><div class='move_icon'></div></td>"; // menu명
		tr += "<td style='border-left:0'>%{blankBox}<span class='menuNmText'>%{menuNm}</span>%{addBtn}</td>"; // menu명
		tr += "<td><span class='menuUrlText'>%{menuUrl}</span></td>"; // url
		tr += "<td><input type='checkbox' class='txtC useAtChk' %{useAtCheck} ></td>"; // useAt
		tr += "<td><input type='checkbox' class='txtC authChk' data-auth='%{useAuth1}' value='%{useAuth1}' %{useAuth1Chk}></td>"; // userAuth -1
		tr += "<td><input type='checkbox' class='txtC authChk' data-auth='%{useAuth2}' value='%{useAuth2}' %{useAuth2Chk}></td>"; // userAuth -2
		tr += "<td><input type='checkbox' class='txtC authChk' data-auth='%{useAuth4}' value='%{useAuth4}' %{useAuth4Chk}></td>"; // userAuth -4
		tr += "<td><input type='checkbox' class='txtC authChk' data-auth='%{useAuth8}' value='%{useAuth8}' %{useAuth8Chk}></td>"; // userAuth -8
		tr += "<td style='text-align: center;'>%{mgrBtn}</td>"; // detail
		tr += "<td style='text-align: center;'>%{delBtn}</td>"; // detail
		tr += "</tr>";
	
	var newTr = Common.matchedReplace( tr, mnInfo );
	
	var $tr =$(newTr);
	for(var k in mnInfo){
		switch (k) {  // skip
			case 'blankBox': case 'mgrBtn': case 'addBtn': case 'delBtn': case 'useAtCheck':	 
			case 'useAuth1': case 'useAuth2': case 'useAuth4': 	case 'useAuth8': 
			case 'useAuth1Chk': case 'useAuth2Chk':	case 'useAuth4Chk':	case 'useAuth8Chk': 
				continue; 
			break; 
		}
		
		var data = mnInfo[k];
		if( k == 'menuPid' && !data )	$tr.setAttr('data-menu-pid','NULL');
		if( typeof data == 'object' || typeof data == 'undefined') continue;
		
		var newK = strLib.toUnderScore( k , false, '-');
		
		$tr.setAttr('data-'+newK, data );
	}
	return $tr;
}

function setMenuEditPopup( rowData ){
	$("#dialog").find("input").val("");
	$("#setIconName").text("");
	for( var k in  rowData){
		if( menuPopupFrm[k] ) {
			menuPopupFrm[k].value = rowData[k];
			if( k == 'menuIcon')$("#setIconName").text(rowData[k]);
		}
	}
}

function openMenuEditPopup( openId ){
	$("#dialog")
			.find("#tempRowId").val( openId )
		.end()
		.popup("open",{
			transition:'pop'
		});
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
	
	.ui-checkbox input, .ui-radio input{
		width:16px;
		height:16px;
	}
	.ui-checkbox input.txtC, .ui-radio input.txtC{
		margin:-13px -8px;
	}
	tr[id^='_new_']{
		cursor:pointer;
		background: #ffdcdc !important;
	}
</style>
<!-- form 단위로 이루어진 content -->
<form name='menuSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content' style='width:800px;'>
		<div>
			<div class='buttonBox' style='margin:.5em 0;'>
				<a href='#' id='save' class='btn' data-icon='check'>저장</a>
				<a href='#' id='reset' class='btn' data-icon='refresh' data-color='gray'>초기화</a>
			</div>
		</div>
		<div style='width: 800px;table-layout: fixed;'>
			<table class='defaultTable menuListTable'>
				<colgroup>
					<col style='width:5%'/>
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
			</table>
		</div>
		<div id='menuLoadList' style='width: 800px;table-layout: fixed;'>
			<table class='defaultTable menuListTable'>
				<colgroup>
					<col style='width:5%'/>
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
				<tbody class='menuDataList'></tbody>
			</table>
		</div>
	</div>
	<!--// main_content  -->
</form>
<!-- menu Manager popup -->
<div id="dialog" data-role="popup" data-overlay-theme="a" data-theme="a" style='width:600px'>
	<form name='menuPopupFrm'>
	  	<div style="padding:10px 20px;">
				<h3>Menu Detail Info</h3>
				<table class='defaultTable'>
					<colgroup>
						<col style='width:20%'/>
						<col style='width:30%'/>
						<col style='width:20%'/>
						<col style='width:30%'/>
					</colgroup>
					<tbody>
						<tr>
							<th class='insertTh'>부모메뉴ID</th>
							<td colspan='4' style='text-align: center;'>
								<input type='hidden' id='tempRowId' name='tempRowId'>
								<input type='hidden' name='menuId'>
								<input type='text' name='menuPid' disabled="disabled">
							</td>
						</tr>
						<tr>
							<th class='insertTh'><label for='popupMenuNm'>메뉴명</label></th>
							<td>
								<input type='text' id='popupMenuNm' name='menuNm' placeholder='메뉴명' data-mini='true'>
							</td>
							<th class='insertTh'><label for='popupIcon'>ICON</label></th>
							<td style='text-align: center;'>
								<input type='hidden' name='menuIcon'>
								<span id='setIconName'></span>
								<a href='#' data-rel='popup' id='popupIcon' class='btn' data-icon='search' data-mini='true'>선택</a>
							</td>
						</tr>
						<tr>
							<th class='insertTh'><label for='popupMenuUrl'>URL</label></th>
							<td colspan='3'>
								<input type='text' id='popupMenuUrl' name='menuUrl' placeholder='URL' data-mini='true'>
							</td>
						</tr>
						<tr>
							<th class='insertTh'><label for='popupMenuImg1'>IMG1</label></th>
							<td colspan='3'>
								<input type='text' id='popupMenuImg1' name='menuImg1' placeholder='메뉴이미지 1' data-mini='true'>
							</td>
						</tr>
						<tr>
							<th class='insertTh'><label for='popupMenuImg2'>IMG2</label></th>
							<td colspan='3' >
								<input type='text' id='popupMenuImg2' name='menuImg2' placeholder='메뉴이미지 2' data-mini='true'>
							</td>
						</tr>
						<tr>
							<td colspan='2' style='border:0'>
								<a href='#' class="btn popupMenuApply" data-full='true' data-icon='check' data-color='green'>적용</a>
							</td>
							<td colspan='2' style='border:0'>
								<a href='#' class="btn popupMenuClose" data-full='true' data-icon='delete' data-color='red' data-rel='back'>닫기</a>
							</td>
						</tr>
					</tbody>	
				</table>
				
		<!-- 아이콘 팝업창 -->
		<div id='iconArea' style='display:none;background: #fff;position: absolute;top:50%;left:50%;width:400px;height:400px;'
			class='ui-popup ui-body-a ui-overlay-shadow ui-corner-all' >
			<style>
				#iconArea ul { list-style-type: none; padding: 0; margin: 1em; }
				#iconArea li { width: 6em; float: left; padding:0 0.5em; }
				.iconList .ui-btn-icon-notext:after {margin-top : 0 }
				.iconList .ui-icon, #iconArea .text { display: inline-block; vertical-align: middle; }
				.iconList .text { padding-left: 1.2em; font-size:.9em; cursor:pointer; }
				.iconList .text:hover { font-weight: bold; }
				.iconList span { position: relative; left: 20px; cursor: pointer;}
				.iconList span.ui-btn-icon-notext { vertical-align: middle; }
			</style>
			<a href='#' class='btnIcon iconClose' data-icon='delete' data-color='red' style='position: absolute;top:-10px;right:-10px;'></a>
			<ul class="iconList">
				<li> <span class="ui-btn-icon-notext ui-icon-action"></span> <span class="text">action</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-alert"></span> <span class="text">alert</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-d"></span> <span class="text">arrow-d</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-d-l"></span> <span class="text">arrow-d-l</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-d-r"></span> <span class="text">arrow-d-r</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-l"></span> <span class="text">arrow-l</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-r"></span> <span class="text">arrow-r</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-u"></span> <span class="text">arrow-u</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-u-l"></span> <span class="text">arrow-u-l</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-arrow-u-r"></span> <span class="text">arrow-u-r</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-audio"></span> <span class="text">audio</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-back"></span> <span class="text">back</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-bars"></span> <span class="text">bars</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-bullets"></span> <span class="text">bullets</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-calendar"></span> <span class="text">calendar</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-camera"></span> <span class="text">camera</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-carat-d"></span> <span class="text">carat-d</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-carat-l"></span> <span class="text">carat-l</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-carat-r"></span> <span class="text">carat-r</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-carat-u"></span> <span class="text">carat-u</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-check"></span> <span class="text">check</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-clock"></span> <span class="text">clock</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-cloud"></span> <span class="text">cloud</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-comment"></span> <span class="text">comment</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-delete"></span> <span class="text">delete</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-edit"></span> <span class="text">edit</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-eye"></span> <span class="text">eye</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-forbidden"></span> <span class="text">forbidden</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-forward"></span> <span class="text">forward</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-gear"></span> <span class="text">gear</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-grid"></span> <span class="text">grid</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-heart"></span> <span class="text">heart</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-home"></span> <span class="text">home</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-info"></span> <span class="text">info</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-location"></span> <span class="text">location</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-lock"></span> <span class="text">lock</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-mail"></span> <span class="text">mail</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-minus"></span> <span class="text">minus</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-navigation"></span> <span class="text">navigation</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-phone"></span> <span class="text">phone</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-plus"></span> <span class="text">plus</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-power"></span> <span class="text">power</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-recycle"></span> <span class="text">recycle</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-refresh"></span> <span class="text">refresh</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-search"></span> <span class="text">search</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-shop"></span> <span class="text">shop</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-star"></span> <span class="text">star</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-tag"></span> <span class="text">tag</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-user"></span> <span class="text">user</span> </li>
				<li> <span class="ui-btn-icon-notext ui-icon-video"></span> <span class="text">video</span> </li>
				<li> <span class="ui-btn-icon-notext "></span> <span class="text"></span> </li>
	 		</ul>
		</div>
		</div>
    </form>
</div>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>