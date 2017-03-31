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
		
		var url = "<c:url value='/mgr/mgr0006/MGR0006$List.do'/>";
		var param = {};
		
		/*  
		carComp
:
"CAR_COMP_00"
carFure
:
"D"
carKind
:
"CAR_KIND_2"
carMsn
:
"A"
carOutline
:
"CAR_OUTLINE_0"
modelCode
:
"C0001"
modelNm
:
"아반떼"
		*/
		var html = "";
		 	html += "<li><a href='#'>";
		 	html += "<input type='hidden' name='modelCode' value='%{modelCode}'/>";
		 	html += "<img class='ui-li-thumb' />";
		 	html += "<h2>";
		 	html += "<span class='ui-icon-%{carComp}' style='display: inline-block;width:35px;height:35px;vertical-align: middle;'></span>";
		 	html += "<div style='vertical-align: baseline;display: inline-block;height:35px;'>%{modelNm}</div>";
		 	html += "</h2>";
		 	html += "<p class='ui-li-aside lastedModify'>%{carComp}</p>";
		 	html += "<p>";
		 	html += "<span class='attr'>%{carFure}</span>";
		 	html += "<span class='split'>|</span>";
		 	html += "<span class='attr'>%{carMsn}</span>";
		 	html += "<span class='split'>|</span>";
		 	html += "<span class='attr'>%{carOutline}</span>";
		 	html += "<span class='split'>|</span>";
		 	html += "<span class='attr'>%{carKind}</span>";
		 	html += "</p>";
		 	html += "</a></li>";
		Common.ajaxJson( url , param ,function(data){
			$("#carInfoList").html("");
			console.log( data );
			for( var i = 0 , len = data.length;i <len;i++){
				var res = Common.matchedReplace (html , data[i] )
				$("#carInfoList").append(res);
			}
			$("#carInfoList").listview('refresh');
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
.split{margin:0 0.5em;}
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
				<a href='#carModelInsert' data-role='button' id='add' data-icon='plus' data-mini='true' data-transition='slide'>신규등록</a>
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
					<span class='ui-icon-CAR_COMP_01' style='display: inline-block;width:35px;height:35px;vertical-align: middle;'></span>
					<div style='vertical-align: baseline;display: inline-block;height:35px;'>K3</div>
				</h2>
				<p class="ui-li-aside lastedModify">기아자동차</p>
				<p>
					<span class='attr'>가솔린</span>
					<span class='split'>|</span>
					<span class='attr'>오토</span>
					<span class='split'>|</span>
					<span class='attr'>세단</span>
					<span class='split'>|</span>
					<span class='attr'>준중형</span>
				</p>
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
<script>
var CarInfoCode = {
		getCarCompGbnList	: function(){return Common.getCommonCode("CAR_COMP")}
	  , getCarCompInterList : function(){return Common.getCommonCode("CAR_COMP_INTER")}
	  , getCarCompExterList : function(){return Common.getCommonCode("CAR_COMP_EXTER")}
	  , getCarKindList 		: function(){return Common.getCommonCode("CAR_KIND")}      
	  , getCarFureList 		: function(){return Common.getCommonCode("CAR_FURE")}      
	  , getCarOutlineList	: function(){return Common.getCommonCode("CAR_OUTLINE")}   
	  , getCarMissionList	: function(){ return Common.getCommonCode("CAR_MSN")}
	  , getCarTotalCompList : function(){ return $.extend({},this.getCarCompInterList(), this.getCarCompExterList());}
}

var   carComp 		= CarInfoCode.getCarCompGbnList() 
	, carCompInter	= CarInfoCode.getCarCompInterList() 
	, carCompExter	= CarInfoCode.getCarCompExterList() 
	, totalCompList	= CarInfoCode.getCarTotalCompList() 
	, carKind 		= CarInfoCode.getCarKindList() 
	, carFure 		= CarInfoCode.getCarFureList()
	, carOutline	= CarInfoCode.getCarOutlineList()
	, carMission	= CarInfoCode.getCarMissionList();
</script>
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
<script>
( function( $ ) {
	
	function pageIsSelectmenuDialog( page ) {
		var isDialog = false
			, id = page && page.attr( "id" ); 
		$( ".filterable-select" ).each( function() { 
			if ( $( this ).attr( "id" ) + "-dialog" === id ) { 
				isDialog = true; 
				return false; 
			}
		});
		return isDialog; 
	}
	
	$.mobile.document
		.on( "selectmenucreate", ".filterable-select", function( event ,a,b) { 
			var input, selectmenu = $( event.target )
				, list = $( "#" + selectmenu.attr( "id" ) + "-menu" ) 
				,form = list.jqmData( "filter-form" ); 
			
			if ( !form ) {
				if( event.target.name == 'companyList' ){
					selectmenu.find('option').each(function(i){
						var val = this.value;
						$( list.find("li")[i] ).find('a').addClass('ui-icon-'+val+' ui-btn-icon-left ui-nodisc-icon')
					});
				}
				input = $( "<input data-type='search' class='keyword'></input>" ); 
				form = $( "<form></form>" ).append( input ); 
				input.textinput(); 
				list
					.before( form )
					.jqmData( "filter-form", form );
				form.jqmData( "listview", list ); 
			}
			
			//실질적으로 필터링하는 함수
			selectmenu
				.filterable({
					input: input
					,children: "> option[value]"
				})
				.on( "filterablefilter", function(event,b,c) {
					selectmenu.selectmenu( "refresh" );
					list.find('li:not(.ui-screen-hidden)').each(function(){
						var t = $(this) 
							, idx = t.attr('data-option-index') 
							, val = selectmenu.find('option:eq('+idx+')').val();
						t.find('a').addClass('ui-icon-'+val+' ui-btn-icon-left ui-nodisc-icon');
					});
				});
			
			selectmenu.on('change',function(e){
				$(this).find('.ui-screen-hidden').removeClass('ui-screen-hidden')
				selectmenu.selectmenu('refresh');
			});
		})
		.on( "pagecontainerbeforeshow", function( event, data ) {
	        var listview, form;
			if ( !pageIsSelectmenuDialog( data.toPage ) ) {
				return;
			}
			listview = data.toPage.find( "ul" );
			form = listview.jqmData( "filter-form" );
			data.toPage.jqmData( "listview", listview );
			listview.before( form );
	    })
		.on( "pagecontainerhide", function( event, data ) {
			var listview, form;
			if ( !pageIsSelectmenuDialog( data.toPage ) ) {
				return;
			}
			listview = data.toPage.jqmData( "listview" );
			form = listview.jqmData( "filter-form" );
			listview.before( form );
		})
		//**********************
		.on("pagebeforechange",function(event,data){
			if( data.prevPage && data.prevPage.hasClass('ui-selectmenu')){
				$("#detailSearch").panel('open');
			}
		});
})( jQuery );
</script>
<!-- 코드등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>