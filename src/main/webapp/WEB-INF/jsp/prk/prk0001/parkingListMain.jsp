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
		var managerPage = '#parkingManager';
		$m.openMenuFromSwipe($uiPage);
		
	});
});
</script>
<style>
</style>
<!-- form 단위로 이루어진 content -->
<form name='prkMainFrm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
		<div class='searchArea'>
			<table class='defaultTable'>
					<colgroup>
						<col style='width:40%;'/>
						<col style='width:60%;'/>
					</colgroup>
					<tbody>
						<tr>
							<th class='insertTh'>주차장명</th>
							<td class='insertTd'><input type='text' name='prkplceNm' data-mini="true" placeholder="주차장명"></td>
						</tr>
						<tr>
							<th class='insertTh'>층구분명</th>
							<td class='insertTd'><input type='text' name='prkplceFlrNm' data-mini="true" placeholder="층구분명"></td>
						</tr>
						
						<tr>
							<th class='insertTh'>차번호</th>
							<td class='insertTd'><input type='text' name='prkplceNm' data-mini="true" placeholder="주차장명"></td>
						</tr>
					</tbody>
				</table>
		</div>
		<div class='buttonBox' style='text-align: right;margin-top:.5em;'>
			<a href='#' class='btn' id='prkAdd' data-icon='plus'>신규등록</a>
			<a href='#' class='btn' id='prkSelect' data-icon='search'>조회</a>
		</div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>
<!-- ############################################################################################################################################ -->
<!-- second page start -->
<c:import url="/prk/prk0001/parkingListManager.do"></c:import>
<!-- ############################################################################################################################################ -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom2.jsp" %>