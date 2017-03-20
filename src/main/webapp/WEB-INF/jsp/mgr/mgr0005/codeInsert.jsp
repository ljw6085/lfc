<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
/** 
	화면이동이 필요할때, jsp를 따로 관리하고자 하면
	$j.documents 에 초기화 함수를 push 해야한다. 
*/
var counter = 0;
$j.documents.push(function(){
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('codeInsertForm', function($form,$uiPage){
		var frm = $form[0];
		MENU.createHeaderBackButton( $form.find('.header') );
		var backBtn = $form.find('.header').find('a');
		
		var $codeDetailList = $form.find(".codeDetailList");
		// 분류코드 라디오버튼 생성
		var divUseAtRadio = COMPONENT.radio({
			target 		: $form.find('.divUseAt')
			,name		: 'divUseAt'
			,cmmnCode	: 'USE_AT'
		});
		var initParams;
		$j.pageMoveCallback(function(params){
			$.mobile.loading('show');
			initParams = params;
			initCodeList( $form, params );
		});
		
		$form.find(".infoBtnBox").on('click',function(e){
			switch (e.target.id) {
				/** 저장*/	
				case '_infoSave':
					// CmmnDivCodeVO 클래스에 맞춰 파라미터를 생성하고 전달.
					var cmmnDivCodeVO = Common.getDataFromDoms( $form.find(".searchArea") );
						cmmnDivCodeVO.codeList = [];
					$codeDetailList.find('tr').each(function(i,item){
						var t = $(this);
						var rowInfo = Common.getDataFromDoms( t );
						// 라디오버튼(사용여부)의 경우 name이 다르므로( USE_AT_x 형태 ), 따로 세팅해줌
						for(var k in rowInfo) {
							if( /USE_AT*/.test(k) )rowInfo.useAt = rowInfo[k];
							else if ( k == 'sort') rowInfo.sort = i;
							else continue;
						}
						cmmnDivCodeVO.codeList.push(rowInfo);
					});
			    	
					var url = "<c:url value='/mgr/mgr0005/codeInsert.do'/>";
					Common.ajaxJson( url , cmmnDivCodeVO ,function(data){
						if( data.result > 0 ){
							alert("수정됨");
						}
			    	});
					
					break;
					
					
				/* 삭제 */
				case '_infoDelete':
					var url = "<c:url value='/mgr/mgr0005/codeDelete.do'/>";
					Common.ajaxJson( url , { divCode:frm.divCode.value } ,function(data){
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
					counter++; // 전역변수
					rowAdd( $form ,{
						parentCode : frm.divCode.value
					}, counter);
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
				ui.children().each(function() {
			        $(this).width($(this).width());
			    });
				return ui;
			}
		});
		
	});
	
	function initCodeList( $form,  params ){
		var frm = $form[0];
		var $codeDetailList = $form.find(".codeDetailList");
		$codeDetailList.html("");
		if( params ){			// 이전 codeList 페이지에서 받아온 파라미터 
			$.mobile.loading('show');
			//수정
			frm.divCode.disabled = true; // 수정인경우 `분류코드`수정을 막는다.
			var url = "<c:url value='/mgr/mgr0005/codeDetailSelect.do'/>";
			// 분류코드 및 상세코드 조회&세팅
			Common.ajaxJson( url , params ,function(data){
				for(var k in data ){
					var dt = data[k]
						,el = frm[k];
					switch (k) {
						case 'codeList': // 상세코드 List 생성
							comLib.asyncLoop(dt,function(i, item){
									rowAdd( $form , item , i );
								 },function(){
									 $.mobile.loading('hide');
							});
							break;
						case 'divParentCode': // 분류코드의 부모코드를 ROOT로 하드코딩
							if( null ==  dt ) el.value='ROOT';
						default:// 나머지값 세팅
							if( el )  el.value = dt; 
							break;
					}
					
				}
				counter = $codeDetailList.find('tr').length;
	    	});
			
		}else{
			//등록 & 초기화
			frm.divCode.disabled = false;
			$form.find('input:text').val("");
		}
	}
	
	// dom 관리방법 강구해볼것	- value mapping #.+#
	var row ="<tr>";
		row += "<input type='hidden' name='parentCode' value='%{parentCode}'><input type='hidden' name='sort' value='%{sort}'>"
		row += "<td style='text-align:center;'><div class='move_icon'></div></td>"
		row += "<td><input type='text' data-mini='true' name='code' style='text-align:center' class='filter:require:max[6]:eng:num' placeholder='코드' size='6' value='%{code}'></td>"
		row += "<td><input type='text' data-mini='true'  name='codeNm' class='filter:require' placeholder='코드명' value='%{codeNm}'></td>"
		row += "<td><input type='text' data-mini='true'  name='codeDc' placeholder='코드설명' value='%{codeDc}' style='width:100%;'></td>"
		row += "<td class='codeUseAt' style='text-align: center;'></td>"
		row += "<td style='text-align: center;'> <a href='#' class='btnIcon rowDelete' data-icon='delete' data-color='red' data-notext='true'>삭제</a></td>"
		row += "</tr>";
		
	/* 상세코드List row 추가 함수 */
	function rowAdd( $form , data , counter){
		//row 전역변수
		var _row = Common.matchedReplace(row, data);
		
		var $row = $( _row );
		$(".codeDetailList").append($row);
		var $target = $row.find(".codeUseAt");
		
		var radio = COMPONENT.radio({
			target 		: $target	
			,name		:"USE_AT_" + counter
			,cmmnCode	:'USE_AT'
			,classes 	: 'codeUseAt'
			,defaultVal : data.useAt
		},$form);
	}
});
</script> 
<style>
	.insertTh { font-size: 0.9em;}
</style>
<div data-role="page" id='codeInsert'><!-- second page start -->
	<form name='codeInsertForm' >
		<div class='header' data-role='header'><h1>공통코드 등록/수정</h1></div>
		<div role='main' class='ui-content' >
			<div id='infoArea' style='text-align: center;'>
				<table class='defaultTable' >
					<colgroup>
						<col style='width:20%;'/>
						<col style='width:30%;'/>
						<col style='width:20%;'/>
						<col style='width:30%;'/>
					</colgroup>
					<tbody>
						<tr>
							<td class='insertTd' colspan='4' style='border:0;padding:0;'>
								<div class='buttonBox infoBtnBox' style='margin-bottom:.5em;'>
									<a href='#' id='_infoSave' class='btn save' data-icon='check' data-mini='true'>저장</a>
									<a href='#' id='_infoDelete' class='btn delete' data-icon='delete' data-mini='true' data-color='red'>삭제</a>
									<a href='#' id='_infoReset' class='btn reset' data-icon='refresh' data-mini='true' data-color='gray'>초기화</a>
								</div>
							</td>
						</tr>
						<tr class='searchArea'>
							<th class='insertTh'>분류코드</th>
							<td class='insertTd'><input type='hidden' name='divParentCode' value='ROOT'>
								<input type='text' name='divCode' placeholder="분류코드">
							</td>
							<th class='insertTh'>분류코드명</th>
							<td class='insertTd'><input type='text' name='divCodeNm' placeholder="분류코드명" data-mini='true'></td>
						</tr>
						<tr class='searchArea'>
							<th class='insertTh'>분류코드설명</th>
							<td class='insertTd'><input type='text' name='divCodeDc' placeholder="분류코드설명" data-mini='true'></td>
							<th class='insertTh'>사용여부</th>
							<td class='insertTd divUseAt'></td>
						</tr>
						<tr>
							<td class='insertTd' colspan='4' style='border:0;'>
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
						<col style='width:10%'>
						<col style='width:20%'>
						<col style='width:30%'>
						<col style='width:20%'>
						<col style='width:10%'>
					</colgroup>
					<thead>
						<tr>
							<th class='insertTh'>이동</th>
							<th class='insertTh'>코드</th>
							<th class='insertTh'>코드명</th>
							<th class='insertTh'>코드설명</th>
							<th class='insertTh'>사용여부</th>
							<th class='insertTh'>삭제</th>
						</tr>
					</thead>
					<tbody class='codeDetailList'></tbody>
				</table>
			</div>
		</div>
	</form>
</div>