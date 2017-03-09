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
	$j.documentReady('codeSelectForm', function($form,$uiPage){
		
		$m.openMenuFromSwipe($uiPage);
		
		
		$form.find('.buttonBox').on('click',function(e){
			var $target = $(e.target);
			switch (e.target.id) {
				case 'codeAdd':
					addCode();
					break;
				case 'codeSelect':
					selectCodeList( $form );
					break;
				default:
					break;
			}
		});
		$("#prkplceList").on('click',function(e){
			var $target = $(e.target);
			var data = Common.getDataFromDoms( $target.closest('li') );
			$j.pageMove( '#codeInsert' , data );
			console.log( data );
		});
	   /*  grid.boxForDom.$body.on('click','tr',function(e){
	    	//클릭된 row 정보를 세
	    	var dt = grid.data[this.id] ;
	    	$j.pageMove( '#codeInsert' , dt );
	    }); */
	});
	
	function addCode(){
		$j.pageMove( '#codeInsert' );
	}
	
	var item = "";
		item += "<li class='ui-li-has-thumb'><a href='#'>";
		item += "<input type='hidden' name='prkplceCode' value='%{prkplceCode}'>";
		item += "<input type='hidden' name='prkplceNm' value='%{prkplceNm}'>";
		item += "<input type='hidden' name='rm' value='%{rm}'>";
		item += "<h2><span class='prkplceNm'>%{prkplceNm}</span></h2>";
		item += "<p class='ui-li-aside'><span class='prkplceCode'>%{prkplceCode}</span></p>";
		item += "<p><span class='rm'>%{rm}</span></p>";
		item += "</a></li>";
	
	function selectCodeList( $form  ){
		$("#prkplceList").html("");
		var url = "<c:url value='/mgr/mgr0003/codeList.do'/>";
    	Common.ajaxJson( url ,$form,function(data){
    		for( var i in data ){
    			var _row = Common.matchedReplace(item, data[i] );
	    		$("#prkplceList").append( _row );
    		}
	    	$("#prkplceList").listview('refresh');
//     		var $row = $( _row );
//     		$(".codeDetailList").append($row);
//     		$j.refreshPage($form);
// 			grid.reload( data );
    	});
	}
	
});
</script>
<!-- form 단위로 이루어진 content -->
<form name='codeSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content' >
	<div id='searchBox'>
		<table class='defaultTable'>
				<colgroup>
					<col style='width:30%;'/>
					<col style='width:70%;'/>
				</colgroup>
				<tbody>
					<tr>
						<th class='insertTh'>주차장코드</th>
						<td class='insertTd'><input type='search' name='prkplceCode' data-mini="true" placeholder="주차장코드"></td>
					</tr>
				</tbody>
			</table>
	</div>
	<div class='buttonBox' style='text-align: right;margin-top:.5em;'>
		<a href='#' class='btn' id='codeAdd' data-icon='plus'>코드등록</a>
		<a href='#' class='btn' id='codeSelect' data-icon='search'>조회</a>
	</div>
	<div class='listWrap' >
		<ul id='prkplceList' data-role="listview" data-inset="false"  class='dataList'>
			<!-- <li class='ui-li-has-thumb'><a href="#">
				<input type='hidden' name='prkplceId' >
				<h2><span class='prkplceNm'>메인주차장</span></h2>
				<p class="ui-li-aside"><span class='prkplceId'>MAIN</span></p>
				<p><span class='rm'>메인주차장입니다.</span></p>
			</a></li> -->
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
<c:import url="/mgr/mgr0003/codeInsert.do"></c:import>
<!-- 코드등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>