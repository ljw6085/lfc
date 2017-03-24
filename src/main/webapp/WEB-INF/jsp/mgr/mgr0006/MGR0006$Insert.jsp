<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
/** 
	화면이동이 필요할때, jsp를 따로 관리하고자 하면
	$j.documents 에 초기화 함수를 push 해야한다. 
*/
$j.documents.push(function(){
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('carInsertForm', function($form,$uiPage){
		var frm = $form[0];
		MENU.createHeaderBackButton( $form.find('.header') );
		var backBtn = $form.find('.header').find('a');
		
		var $codeDetailList = $form.find(".codeDetailList");
		
		var initParams;
		$j.pageMoveCallback(function(params){
			initParams = params;
			console.log( params );
			initCodeList( $form, params );
		});
		/* $( ":mobile-pagecontainer" ).pagecontainer({
			// page change 콜백함수.
			change:function(event,ui){
				initParams = ui.options.params;
				initCodeList( $form, initParams );
			}
		});// page move */
		
		$form.find(".infoBtnBox").on('click',function(e){
			switch (e.target.id) {
				/** 저장*/	
				case '_infoSave':
					// PrkplceMngVO 클래스에 맞춰 파라미터를 생성하고 전달.
					var prkplceMngVO = Common.getDataFromDoms( $form.find(".searchArea") );
						prkplceMngVO.floorList = [];
					$codeDetailList.find('tr').each(function(i,item){
						var t = $(this);
						var rowInfo = Common.getDataFromDoms( t );
						// 라디오버튼(사용여부)의 경우 name이 다르므로( USE_AT_x 형태 ), 따로 세팅해줌
						for(var k in rowInfo) {
							if ( k == 'sort') rowInfo.sort = i;
							else continue;
						}
						prkplceMngVO.floorList.push(rowInfo);
					});
			    	
					console.log( prkplceMngVO );
					var url = "<c:url value='/mgr/mgr0003/codeInsert.do'/>";
					Common.ajaxJson( url , prkplceMngVO ,function(data){
						if( data.result > 0 ){
							alert("수정됨");
						}
			    	});
					
					break;
					
					
				/* 삭제 */
				case '_infoDelete':
					var url = "<c:url value='/mgr/mgr0003/codeDelete.do'/>";
					var prkplceCode = $("#prkplceCode").val();
					Common.ajaxJson( url , { prkplceCode : prkplceCode } ,function(data){
						if( data.result > 0 ){
							alert("삭제됨");
						}
						$(backBtn).trigger('click');
			    	});
					break;
					
					
				/* 초기화 */
				case '_infoReset':
					initCodeList( $form, initParams );
					break;
				default:
					break;
			}
		});
		
		$form.find(".rowBtnBox").on('click',function(e){
			switch ( e.target.id ) {
				case '_rowAdd':
					var prkplceCode = $("#prkplceCode").val();
					rowAdd( $form ,{
						prkplceCode : prkplceCode
					});
					break;
		
				default:
					break;
			}
			
		});//row add
		
		$uiPage.on( 'click', '.rowDelete', function(e){
			$(e.target).closest('tr').remove();
		});// delete
	
		$(".codeListTable").sortable({
			items:" > tbody > tr"
			,axis:'y'
			,handle: ".move_icon"
	        ,opacity: 0.7
	        ,delay: 50
	        ,dropOnEmpty: true
	        ,pullPlaceholder: false
	        ,stop:function(e){
	        }
			,helper: function(e, ui) {
/* 				ui.children().each(function() {
			        $(this).width($(this).width());
			    }); */
				return ui;
			}
		});
		
	});
	
	function initCodeList( $form,  params ){
		var frm = $form[0];
		var $codeDetailList = $form.find(".codeDetailList");
		$codeDetailList.html("");
		if( params ){			// 이전 codeList 페이지에서 받아온 파라미터 
			//수정
			frm.prkplceCode.disabled = true; // 수정인경우 `분류코드`수정을 막는다.
			var url = "<c:url value='/mgr/mgr0003/codeDetailSelect.do'/>";
			// 분류코드 및 상세코드 조회&세팅
			Common.ajaxJson( url , params ,function(data){
				for(var k in data ){
					var dt = data[k]
						,el = frm[k];
					switch (k) {
						case 'floorList': // 상세코드 List 생성
							for( var i = 0; i < dt.length;i++) {
								rowAdd( $form , dt[i] , i );
							}
							break;
						default:// 나머지값 세팅
							if( el )  el.value = dt; 
							break;
					}
				}
	    	});
			
		}else{
			//등록 & 초기화
			frm.prkplceCode.disabled = false;
			$form.find('input:text').val("");
		}
	}
	
	// dom 관리방법 강구해볼것	- value mapping #.+#
	var row ="<tr>";
		row += "<input type='hidden' name='prkplceCode' value='%{prkplceCode}'><input type='hidden' name='sort' value='%{sort}'>"
		row += "<td style='text-align:center;'><div class='move_icon'></div></td>"
		row += "<td><input type='text' data-mini='true' name='prkplceFlrCode' style='text-align:center' placeholder='층코드' size='6' value='%{prkplceFlrCode}'></td>"
		row += "<td><input type='text' data-mini='true'  name='prkplceFlrNm' class='filter:require' placeholder='층구분명' value='%{prkplceFlrNm}'></td>"
		row += "<td style='text-align: center;'><a href='#' class='btnIcon rowDelete' data-icon='delete' data-color='red' data-notext='true'>삭제</a></td>"
		row += "</tr>";
		
	/* 상세코드List row 추가 함수 */
	function rowAdd( $form , data ){
		console.log( data );
		//row 전역변수
		var _row = Common.matchedReplace(row, data);
		var $row = $( _row );
		$(".codeDetailList").append($row);
		$j.refreshPage($form);
	}
});
</script> 
<style>
	.insertTh { font-size: 0.9em;}
</style>
<div data-role="page" id='carInsert'><!-- second page start -->
	<form name='carInsertForm'>
		<div class='header' data-role='header'><h1>주차장코드 등록/수정</h1></div>
		<div role='main' class='ui-content'>
			<div id='infoArea' style='text-align: center;'>
				<table class='defaultTable searchArea'  >
					<colgroup>
						<col style='width:40%;'/>
						<col style='width:60%;'/>
					</colgroup>
					<tbody>
						<tr>
							<td class='insertTd' colspan='2' style='border:0;padding:0;'>
								<div class='buttonBox infoBtnBox' style='margin-bottom:.5em;'>
									<a href='#' id='_infoSave' class='btn save' data-icon='check' data-mini='true'>저장</a>
									<a href='#' id='_infoDelete' class='btn delete' data-icon='delete' data-mini='true' data-color='red'>삭제</a>
									<a href='#' id='_infoReset' class='btn reset' data-icon='refresh' data-mini='true' data-color='gray'>초기화</a>
								</div>
							</td>
						</tr>
						<tr >
							<th class='insertTh'>주차장코드</th>
							<td class='insertTd'>
								<input type='text' name='prkplceCode' id='prkplceCode' placeholder="주차장코드">
							</td>
						</tr>
						<tr>
							<th class='insertTh'>주차장명</th>
							<td class='insertTd'><input type='text' name='prkplceNm' placeholder="주차장명" data-mini='true'></td>
						</tr>
						<tr class='searchArea'>
							<th class='insertTh'>비고</th>
							<td class='insertTd' colspan='3'><input type='text' name='rm' placeholder="비고" data-mini='true'></td>
						</tr>
						<tr>
							<td class='insertTd' colspan='2' style='border:0;'>
								<div class='buttonBox rowBtnBox' style='margin-top:.5em;'>
									<a href='#' id='_rowAdd' class='btn rowAdd' data-icon='plus' data-mini='true'>행추가</a>
								</div>
							</td>
						</tr>
						<tr>
							<td class='insertTd' colspan='4' style='border:0;width:100%'>
							</td>
						</tr>
					</tbody>
				</table>
				<table class='defaultTable codeListTable'  style='width:100%'>
					<colgroup>
						<col style='width:10%'>
						<col style='width:30%'>
						<col style='width:50%'>
						<col style='width:10%'>
					</colgroup>
					<thead>
						<tr>
							<th class='insertTh'>이동</th>
							<th class='insertTh'>층코드</th>
							<th class='insertTh'>층구분명</th>
							<th class='insertTh'>삭제</th>
						</tr>
					</thead>
					<tbody class='codeDetailList'></tbody>
				</table>
			</div>
		</div>
	</form>
</div>