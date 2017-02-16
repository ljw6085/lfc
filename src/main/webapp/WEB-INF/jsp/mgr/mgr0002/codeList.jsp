<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/js/zgrid/css/zgrid.css'/>" type="text/css">
<script type="text/javascript" src="<c:url value='/resources/js/zgrid/zgrid.js'/>"></script>
<script>
var data = [
			{no:'1',groupCode:'GRP0001',divCode:'SYS_DIV_CD',divCodeNm:'시스템구분',useAt:'Y'}
			,{no:'2',groupCode:'GRP0001',divCode:'USE_AT',divCodeNm:'사용여부',useAt:'Y'}
			,{no:'3',groupCode:'GRP0002',divCode:'MN_KIND_CD',divCodeNm:'메뉴종류코드',useAt:'Y'}
			,{no:'4',groupCode:'GRP0002',divCode:'BRD_DIV_CD',divCodeNm:'게시판구분',useAt:'Y'}
			,{no:'5',groupCode:'GRP0003',divCode:'CAR_DIV_CD',divCodeNm:'차량구분코드',useAt:'Y'}
	]
var col = [
			{ colId:'no', name:'No', priority:'2' ,width:50 },
			{ colId:'groupCode', name:'그룹코드', priority:'1', width:100} ,
			{ colId:'divCode', name:'분류코드', priority:'' , width:100},
			{ colId:'divCodeNm', name:'코드명', priority:'' , width:150},
			{ colId:'useAt', name:'사용여부', priority:'3'  , width:80}
		]
/** Form 단위로 스크립팅 한다. */
$j.documentReady('codeSelectForm', function($form){
	$( ":mobile-pagecontainer" ).pagecontainer({
		change:function(){
			$(window).trigger('resize');
		}
	});
	
	grid = $(".gridWrap").grid({
		col:col
		,data : data
		,type:'b'
 		,columnToggle:false
		,autoFit : true
		,height:400
	});
	
    $("#codeInsert").bind('click',function(e){
    	e.preventDefault();
    	$( ":mobile-pagecontainer" ).pagecontainer( "change", '#codeInsert' , {
            transition: "slide"
        });
    });
    
    grid.boxForDom.$body.find("tr").bind('click',function(e){
    	//클릭된 row 정보를 세팅
    	var params = {};
    	var dt = grid.data[this.id] ;
    	$.extend( params , dt );
    	$.mobile.pageChange('#codeInsert',{
    		transition: "slide",
            params:params
    	});
    	/* $( ":mobile-pagecontainer" ).pagecontainer( "change", '#codeInsert' , {
            transition: "slide",
            params:params
        }); */
    });
    
});

/** Form 단위로 스크립팅 한다. */
$j.documentReady('codeInsertForm', function($form){
	var backBtn = MENU.createHeaderBackButton( $form.find('.header') );
	
	
	$(document).on('swiperight','.ui-page',function(e){
		$form.find('.header').find('a').trigger('click');
	});
	
	$( ":mobile-pagecontainer" ).pagecontainer({
		// page change 콜백함수.
		change:function(event,ui){
			if( ui.options.target == '#codeInsert'){
				if( ui.options.params ){
					console.log( '수정!');
					var prm = ui.options.params;
					for(var k in prm ){
						if( $form[0][k] ) $form[0][k].value = prm[k];
					}
				}else{
					$form.find('input:text').val("");
					console.log( '등록!');
				}
			}
		}
	});
});
</script>
<style>
</style>
<!-- form 단위로 이루어진 content -->
<form name='codeSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
	<div id='searchBox' class='ui-grid-a'>
		<div class='ui-block-a'>
			<input type='search' id='srch' data-mini='true' placeholder="Search..">
		</div>
		<div class='ui-block-b' style='text-align: center;'>
			<a href='#' id='searchBtn' data-icon='search'></a>
		</div>
	</div>
	<div class='buttonBox' style='text-align: right;'>
		<a href='#' id='codeInsert' class='btn' data-icon='plus'>코드등록</a>
		<a href='#' id='codeSelect' class='btn' data-icon='search'>조회</a>
	</div>
	<div class='gridWrap' ></div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<!-- ############################################################################################################################################ -->
<!-- 코드등록/수정화면 시작 -->
<div data-role="page" id='codeInsert'><!-- second page start -->
<form name='codeInsertForm'>
	<div class='header' data-role='header'><h1>공통코드 등록/수정</h1></div>
	<div role='main' class='ui-content'>
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
								<a href='#' class='btn menuAdd' data-icon='check' >저장</a>
								<a href='#' class='btn menuEdit' data-icon='edit' >수정</a>
								<a href='#' class='btn menuDelete' data-icon='delete'>삭제</a>
							</div>
						</td>
					</tr>
					<tr>
						<th class='insertTh'>그룹코드</th>
						<td class='insertTd'><input type='text' name='groupCode' placeholder="그룹코드"></td>
						<th class='insertTh'>분류코드</th>
						<td class='insertTd'><input type='text' name='divCode' placeholder="분류코드"></td>
					</tr>
					<tr>
						<th class='insertTh'>분류코드명</th>
						<td class='insertTd'><input type='text' name='divCodeNm' placeholder="분류코드명"></td>
						<th class='insertTh'>사용여부</th>
						<td class='insertTd'><input type='text' name='useAt' placeholder="사용여부"></td>
					</tr>
					<tr>
						<td class='insertTd' colspan='4' style='border:0;'>
							<table class='defaultTable'>
								<tbody>
									<tr>
										<td style='padding:0.1em'>1</td>
									</tr>
									<tr>
										<td style='padding:0.1em'>1</td>
									</tr>
									<tr>
										<td style='padding:0.1em'>1</td>
									</tr>
								</tbody>
							</table>
						
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</form>
</div>
<!-- 코드등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>