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
	$j.documentReady('codeSelectForm', function($form,$uiPage){
		
		$m.openMenuFromSwipe($uiPage);
		
		$form.find('.buttonBox').on('click',function(e){
			var $target = $(e.target);
			switch (true) {
				case $target.hasClass('codeAdd'):
					addCode();
					break;
				case $target.hasClass('codeSelect'):
					selectCodeList($form );
					break;
				default:
					break;
			}
		});
		
		$("#carCodeList").on('click','li',function(){
			var t = $(this);
			setTimeout(function(){
				var param = Common.getDataFromDoms( t );
				$j.pageMove( '#codeInsert' , param );
			},500)
		});
		
	});
	
	function addCode(){
		$j.pageMove( '#codeInsert' );
	}
	
	var item = "";
	item += "<li><a href='#'>";
	item += "<input type='hidden' name='parentCode' value='%{divCode}'>";
	item += "<h2>%{divCodeNm}</h2>";
	item += "<p class='ui-li-aside'>%{divCode}</p>";
	item += "<p>%{divCodeDc}</p>";
	item += "</a></li>"
	function selectCodeList( $form ){
		var url = "<c:url value='/mgr/mgr0005/codeList.do'/>";
Common.ajaxJson( url ,$form,function(data){

    		for( var i =0,len=data.length;i<len;i++){
				var it = Common.matchedReplace( item, data[i]);
				$("#carCodeList").append( it );
    			
    		}
    		$("#carCodeList").listview('refresh');
    	});
	}
	
});
</script>
<!-- form 단위로 이루어진 content -->
<form name='codeSelectForm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
	<div id='searchBox'>
		<table class='defaultTable'>
				<colgroup>
					<col style='width:20%;'/>
					<col style='width:30%;'/>
					<col style='width:20%;'/>
					<col style='width:30%;'/>
				</colgroup>
				<tbody>
					<tr>
						<input type='hidden' name='divGrpCode' value='CAR'>
						<th class='insertTh'>분류코드</th>
						<td class='insertTd'><input type='text' name='divCode' data-mini="true" placeholder="분류코드"></td>
						<th class='insertTh'>분류코드명</th>
						<td class='insertTd'><input type='text' name='divCodeNm' data-mini="true" placeholder="분류코드명"></td>
					</tr>
					<tr>
						<th class='insertTh'>사용여부</th>
						<td class='insertTd' colspan='3' data-role="controlgroup" data-type="horizontal" data-mini="true">
							<input type="radio" name="divUseAt" id="div_use_at_y" value="Y" checked="checked">
					        <label for="div_use_at_y">사용</label>
					        <input type="radio" name="divUseAt" id="div_use_at_n" value="N">
					        <label for="div_use_at_n">사용안함</label>
						</td>
					</tr>
				</tbody>
			</table>
	</div>
	<div class='buttonBox' style='text-align: right;margin-top:.5em;'>
		<a href='#' class='btn codeAdd' data-icon='plus'>코드등록</a>
		<a href='#' class='btn codeSelect' data-icon='search'>조회</a>
	</div>
	<div class='listWrap' >
		<ul id='carCodeList' data-role="listview" data-inset="false"  class='dataList'>
			
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
<c:import url="/mgr/mgr0005/codeInsert.do"></c:import>
<!-- 코드등록화면 끝 -->
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>