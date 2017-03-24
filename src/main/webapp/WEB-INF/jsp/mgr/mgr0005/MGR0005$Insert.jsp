<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
/** 
	화면이동이 필요할때, jsp를 따로 관리하고자 하면
	$j.documents 에 초기화 함수를 push 해야한다. 
*/
var counter = 0 , drawing = false , pageType = 'C';
$j.documents.push(function(){
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('codeInsertForm', function($form,$uiPage){
		var frm = $form[0];
		MENU.createHeaderBackButton( $form.find('.header') );
		var backBtn = $form.find('.header').find('a');
		$(backBtn).on('click',function(e){
			if(drawing){
				e.preventDefault();
				return false;
			}
		});
		$("#detailInfoPopup").popup();
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
					
					if( !confirm("저장하시겠습니까?") ) return;
					if( !frm.divParentCode.value ) frm.divParentCode.value = 'ROOT';
					
					// CmmnDivCodeVO 클래스에 맞춰 파라미터를 생성하고 전달.
					var cmmnDivCodeVO = Common.getDataFromDoms( $form.find("#infoArea") );
						cmmnDivCodeVO.codeList = [];
						
					var parentCode = frm.divCode.value;
					$codeDetailList.find('li').each(function(i,item){
						var t = $(this);
						var rowInfo = Common.getDataFromDoms( t );
							rowInfo.sort = i;
							rowInfo.parentCode = parentCode;
						cmmnDivCodeVO.codeList.push(rowInfo);
					});
			    	
					var url = "<c:url value='/mgr/mgr0005/MGR0005$Insert.do'/>";
					Common.ajaxJson( url , cmmnDivCodeVO ,function(data){
						console.log( data );
						if( data.result > 0 ){
							alert("저장됨");
						}
			    	});
					
					break;
					
					
				/* 삭제 */
				case '_infoDelete':
					var isDel = confirm('해당코드를 모두 삭제하시겠습니까?');
					
					if( isDel ){
						var $divCode = $form.find("#infoArea");
						var cmmnDivCodeVO = Common.getDataFromDoms( $divCode );
							cmmnDivCodeVO.codeList = [];
							rowStatusChange( $divCode ,  'D' );
						$codeDetailList.find('li').each(function(i,item){
							var t = $(this);
							var rowInfo = Common.getDataFromDoms( t );
								rowInfo.sort = i;
								rowInfo.rowStatus='D'
							cmmnDivCodeVO.codeList.push(rowInfo);
						});
				    	
						console.log( '삭제', cmmnDivCodeVO );
						var url = "<c:url value='/mgr/mgr0005/MGR0005$Insert.do'/>";
						Common.ajaxJson( url , cmmnDivCodeVO ,function(data){
							console.log( data );
							if( data.result > 0 ){
								alert("삭제됨");
							}
				    	});
					}
					break;
					
					
				/* 초기화 */
				case '_infoReset':
					var isReset = confirm('해당코드를 모두 초기화하시겠습니까?');
					if( isReset) {
						if( pageType == 'C' ) initParams = false;
						initCodeList( $form, initParams );
					}
					break;
					
				/* 행추가 */
				case '_rowAdd':
					counter++; // 전역변수
					rowAdd( $form ,{
						parentCode : frm.divCode.value
						,rowStatus:'C'
					}, counter);
					$codeDetailList.listview('refresh');
					
					$('body').animate( { 
							scrollTop :  $codeDetailList.find('li:last').offset().top 
					},200 );
					
					$j.refreshPage();
					break;
				default:
					break;
			}
		});
		
		var parentCodeInfo = "<li>"
			parentCodeInfo +="<a href='#'>";
			parentCodeInfo +="<input type='hidden' name='parentCode' value='%{code}'>";
			parentCodeInfo +="<span class='parentCode %{isError}'>%{code}</span> · " ;
			parentCodeInfo +="<span class='parentCodeNm %{isError}'>%{codeNm}</span>";
			parentCodeInfo +="</a>";
			parentCodeInfo +="</li>";
			
		$("#divParentCodeInput").on('keyup',function(){
			var url = "<c:url value='/mgr/mgr0005/MGR0005$SelectParentCode.do'/>";
			var $t = $(this);
			var val = $t.val();
			
			var params = {};
			var paramType = $("#parentCodeSrch").val();
			params[paramType] = val;
			Common.ajaxJson( url , params ,function(data){
				var res;
				if( val == 'ROOT' || !val ){
					$(".parentCodeInfo").html( "" );
					$t.parent('.ui-input-search').removeClass('error');
					
					res = Common.matchedReplace( parentCodeInfo ,{
						code:'ROOT'
						,codeNm :'최상위코드'
					});
					
					$(".parentCodeInfo").html( res );
					
				}else if( data.length == 0  ){
					$t.parent('.ui-input-search').addClass('error');
					res = Common.matchedReplace( parentCodeInfo ,{
						code:'#Error'
						,codeNm :'존재하지않는코드'
						,isError:'isError'
					});
					$(".parentCodeInfo").html( res );
				}else{
					$(".parentCodeInfo").html( "" );
					$t.parent('.ui-input-search').removeClass('error');
					for(var i = 0 , len = data.length; i< len ;i++){
						res = Common.matchedReplace( parentCodeInfo , data[i] );
						$(".parentCodeInfo").append( res );
					}
				}
				$(".parentCodeInfo").listview('refresh');
			});
			
		});
		
		
		$(".parentCodeInfo").on('click','li',function(e){
			var d = Common.getDataFromDoms( $(this) );
			if( d.parentCode == '#Error' ) return;
			$("#divParentCodeInputVal").val( d.parentCode );
		});
		
		$(".detailInfoPopupButton").on('click',function(e){
			e.preventDefault();
			switch (e.target.id) {
				case '_detailApply':
					var popup = $("#detailInfoPopup");
					var data = Common.getDataFromDoms( popup );
					if( !data.code ) {
						alert("코드를 입력하세요.");
						return;
					}
					var li = popup.jqmData('clickedLi');
					li.find('input:hidden').each(function(){
						if( data[this.name] ){
							this.value = data[this.name];
							li.find('span.'+this.name).text( this.value );
							if( this.name == 'useAt'){
								var ret;
								if( this.value == 'Y'){
									ret = '사용'
									li.removeClass('disabledRow');
								}else{
									ret = '사용안함'
									li.addClass('disabledRow');
								}
								li.find('.useAtNm').text( ret );
							}
						}
					});
					if( getRowStatus(li) != 'C' ) rowStatusChange( li , 'U' );
					$("#detailInfoPopup").popup('close');
					
					break;
				case '_detailDelete':
					var isDelete = confirm('삭제하시겠습니까?');
					if( isDelete ){
						var $pop = $("#detailInfoPopup") 
							, target = $pop.jqmData('clickedLi');
						if( getRowStatus( target ) == 'C' ){
							target.remove();
							refreshConrner( $(".codeListWrap") );
						}else{
							rowStatusChange( target , 'D' );
						}
						$pop.popup('close');
					}
					break;
				case '_detailCancel':
					$("#detailInfoPopup").popup('close');
					break;

			default:
				break;
			}
		});
		
		$form.find(".codeDetailList").on('click','li',function(e){
			var data = Common.getDataFromDoms( $(this) );
			if( $(e.target).hasClass('itemDelete') ) {
				var msg = "[ %{codeNm}(%{code}) ] 를 삭제하시겠습니까?";
				if( confirm(Common.matchedReplace(msg, data)) ) {
					if( getRowStatus( $(this) ) == 'C' ){
						$(this).remove();
						refreshConrner($(".codeListWrap"));
					}else{
						rowStatusChange( $(this) , 'D' );
					}
				}
				return;
			}else if( $(e.target ).hasClass('itemMove') ){
				return;
			}
			
			$("#detailInfoPopup").popup('open',{
				transition:'pop'
			});
			
			$("#detailInfoPopup").jqmData('clickedLi', $(this) )
			
			var form = $("#detailInfoPopup").find('form')[0];
			
			for( var k in data ){
				var el = form[k];
				if( el  ) {
					if( k == 'useAt'){
						for( var i = 0,len=el.length;i<len;i++ ){
							if( el[i].value == data[k] ) {
								el[i].checked = true;
							}
							$(el).checkboxradio('refresh');
						}
						
					}else{
						el.value = data[k];
						if( k == 'code'){
							if( data[k] != ''){
								el.disabled = true;
								$(el).addClass('ui-state-disabled');
							}else{
								el.disabled = false;
								$(el).removeClass('ui-state-disabled');
							}
						}
					}
				}
			}
			//detailInfoPopup
		});
		
		$(".codeListWrap").sortable({
			items:" > li"
			,axis:'y'
			,handle: ".itemMove"
	        ,opacity: 0.7
	        ,delay: 50
	        ,dropOnEmpty: true
	        ,pullPlaceholder: false
	        ,stop:function(e , ui){
	        	refreshConrner($(this));
	        }
			,helper: function(e, ui) {
				ui.children().each(function() {
			        $(this).width($(this).width());
			    });
				return ui;
			}
		});
		
	});
	
	function rowStatusChange( $target, type ){
		if( type == 'D' ) $target.addClass('ui-state-disabled');
		$target.find("[name='rowStatus']").val( type )
	}
	function getRowStatus( $target ){
		var $r = $target.find("[name='rowStatus']");
		return $r[0] ? $r.val() : '';
	}
	
	function refreshConrner( $target ){
		$target.find("li.ui-first-child").removeClass('ui-first-child')
		.end()
		.find("li.ui-last-child").removeClass('ui-last-child');
		$target.find("li:first").addClass("ui-first-child")
		.end()
		.find("li:last").addClass("ui-last-child");
	}
	
	function initCodeList( $form,  params ){
		var frm = $form[0];
		var $codeDetailList = $form.find(".codeDetailList");
		$codeDetailList.html("");
		$form.find("#infoArea").removeClass( 'ui-state-disabled' );
		var rowStatus;
		if( params ){// 이전 codeList 페이지에서 받아온 파라미터
			$.mobile.loading('show');
			//수정
			$(".parentCodeWrap").hide();
			frm.divCode.disabled = true; // 수정인경우 `분류코드`수정을 막는다.
			frm.divParentCode.disabled = true; // 수정인경우 `부모코드`수정을 막는다.
			$(frm.divCode).addClass('ui-state-disabled');
			$(frm.divParentCode).addClass('ui-state-disabled');
			rowStatus = pageType = 'U';
			
			var url = "<c:url value='/mgr/mgr0005/MGR0005$SelectDetail.do'/>";
			// 분류코드 및 상세코드 조회&세팅
			Common.ajaxJson( url , params ,function(data){
				for(var k in data ){
					var dt = data[k]
						,el = frm[k];
					
					switch (k) {
						case 'codeList': // 상세코드 List 생성
							comLib.asyncLoop( dt , function(i, item){
								drawing = true;
								var row = rowAdd( $form , item , i );
								$codeDetailList.listview('refresh');
								if( i == 5 ) $j.refreshPage();
							},function(){ 
								//callback
								drawing = false;
								$.mobile.loading('hide');
								$j.refreshPage();
							});
							break;
						case 'divParentCode': // 분류코드의 부모코드를 ROOT로 하드코딩
							if( !dt ) el.value='ROOT';
							else el.value = dt;
							break;
						case 'rowStatus':
							break;
						default:// 나머지값 세팅
							if( el )  el.value = dt; 
							break;
					}
					
				}
				$("#divParentCodeInput").trigger('keyup');
	    	});
			
		}else{
			//등록 & 초기화
			frm.divCode.disabled = false; 
			$(frm.divCode).removeClass('ui-state-disabled');
			frm.divParentCode.disabled = true; 
			$(frm.divParentCode).addClass('ui-state-disabled');
			
			$form.find('input:text').val("");
			$(".parentCodeWrap").show();
			$.mobile.loading('hide');
			
			rowStatus = pageType = 'C';
		}
		
		$("#divRowStatus").val( rowStatus );
	}
	
	// dom 관리방법 강구해볼것	- value mapping #.+#
	var row ="<li><a href='#' class='item' >";
		row += "<input type='hidden' name='rowStatus' value='%{rowStatus}'>"
		row += "<input type='hidden' name='grpCode' value='CAR'>"
		row += "<input type='hidden' name='parentCode' value='%{parentCode}'><input type='hidden' name='sort' value='%{sort}'>"
		row += "<input type='hidden' name='code' value='%{code}'>"
		row += "<input type='hidden' name='codeNm' value='%{codeNm}'>"
		row += "<input type='hidden' name='codeDc' value='%{codeDc}'>"
		row += "<input type='hidden' name='useAt' value='%{useAt}'>"
		row += "<p class='ui-li-aside useAtNm'>%{useAtNm}</div>"
		row += "<h2 class='itemCont itemCodeNm'><span class='title'>코드명</span> <span class='codeNm'>%{codeNm}</span></h2>"
		row += "<p class='itemCont itemContent'><span class='title'>코드</span> <span class='code'>%{code}</span></p>"
		row += "<p class='itemCont itemDesc'><span class='title'>코드설명</span><span class='codeDc'>%{codeDc}</span></p>";
		row += "</a>";
		row += "<a href='#' class='itemDelete ui-btn ui-btn-icon-notext ui-icon-delete ui-btn-a'></a>"
		row += "<a href='#' class='itemMove'></a></li>";
	
	/* 상세코드List row 추가 함수 */
	function rowAdd( $form , data , counter){
		if( !data )return;
		var useAt = 	data.useAt;
		if( useAt == 'Y') data.useAtNm = '사용';
		else if( useAt == 'N') data.useAtNm = '사용안함'
		
		if( !data.rowStatus ) data.rowStatus = 'N';
		//row 전역변수
		var _row = Common.matchedReplace(row, data);
		
		var $row = $( _row );
		if ( useAt == 'N' ) $row.addClass('disabledRow');
		rowStatusChange( $row , data.rowStatus );
		$(".codeDetailList").append($row);
		
		return $row;
	}
});
</script> 
<style>
	.ui-field-contain { padding:0;padding-top:0.3em; border:0;}
	.custom-corners .ui-bar {
		-webkit-border-top-left-radius: inherit;
		border-top-left-radius: inherit;
		-webkit-border-top-right-radius: inherit;
		border-top-right-radius: inherit;
	}
	.custom-corners .ui-body {
		border-top-width: 0;
		-webkit-border-bottom-left-radius: inherit;
		border-bottom-left-radius: inherit;
		-webkit-border-bottom-right-radius: inherit;
		border-bottom-right-radius: inherit;
	}
	.ui-field-contain .label{display:none;}
	@media ( min-width: 28em ) {
		.ui-field-contain  .label{display:block;}
	} 
	.ui-input-text { margin: 0.1em;}
	.itemCont { color:#333; }
	
	.ui-block-a, .ui-block-b, .ui-block-c { padding:0;}
	
	.divUseAtRow{text-align: right;}
	
	.ui-input-search.error { border:1px solid red !important; background: #ffc1c1 !important;}
	.parentCodeInfo a { padding-top:0 !important;padding-bottom:0 !important;}
	.parentCodeInfo .parentCode { font-size:0.8em; font-weight: normal;}
	.parentCodeInfo .parentCodeNm { font-size:0.8em; font-weight: normal; } 
	.isError { color:red !important;}
	.selected.isError{color:#ddd !important}
	
	.codeDetailList .item { margin-right:5em !important; }
	.itemDelete { 
		margin-right:2.5em !important;
		border-right:0 !important;
	    -webkit-border-top-left-radius: 0 !important;
	    border-top-left-radius: 0 !important;
	    -webkit-border-top-right-radius: 0 !important;
	    border-top-right-radius: 0 !important;
	    -webkit-border-bottom-left-radius: 0 !important;
	    border-bottom-left-radius: 0 !important;
	    -webkit-border-bottom-right-radius: 0 !important;
	    border-bottom-right-radius: 0 !important;
	}
	.parentCodeWrap { padding:0.5em;}
	.parentCodeWrap .ui-last-child {border-bottom:1px solid #ddd !important;}
	.parentCodeWrap .ui-listview {margin:0 !important;margin-top:0.5em !important}
	.parentCodeWrap .ui-select, .parentCodeWrap .ui-input-search { margin:0 }
	.parentCodeWrap .ui-select { padding-right:0.5em;}
	
</style>
<div data-role="page" id='codeInsert'><!-- second page start -->
	<form name='codeInsertForm' >
		<div class='header' data-role='header'><h1>차량정보코드 등록/수정</h1></div>
		<div role='main' class='ui-content' >
			<div id='infoArea' style='text-align: center;'>
				<div class='ui-corner-all custom-corners ui-shadow '>
					<div data-role="collapsible" class="ui-nodisc-icon ui-alt-icon">
						<h3>
							분류코드정보
						</h3>
						<input type='hidden' name='rowStatus' id='divRowStatus'>
						<input type='hidden' name='divGrpCode' value='CAR'>
						<div class='parentCodeWrap'>
							<div class="ui-field-contain">
								<label for="divParentCodeInput" class='label'>부모코드선택</label>
								<div class='ui-grid-a'>
									<div class='ui-block-a' style='width:50%'>
										<select id='parentCodeSrch' data-mini='true'>
											<option value='codeNm'>코드명</option>
											<option value='code'>코드</option>
										</select>
									</div>
									<div class='ui-block-b' style='width:50%'>
										<input type='search' id='divParentCodeInput' placeholder="부모코드선택" data-mini='true'>
									</div>
								</div>
							</div>
							<ul class='parentCodeInfo' data-role='listview' data-inset="false"></ul>
						</div>
						<div class="ui-field-contain">
							<label for="divParentCodeInputVal" class='label'>부모코드</label>
							<input type='text' id='divParentCodeInputVal' name='divParentCode' placeholder="부모코드" data-mini='true' >
						</div>
						<div class="ui-field-contain">
							<label for="divCodeInput" class='label'>분류코드</label>
							<input type='text' id='divCodeInput' name='divCode' placeholder="분류코드" data-mini='true'>
						</div>
						<div class="ui-field-contain">
							<label for="divCodeNmInput" class='label'>분류코드명</label>
							<input type='text' id='divCodeNmInput' name='divCodeNm' placeholder="분류코드명" data-mini='true'>
						</div>
						<div class="ui-field-contain">
							<label for="divCodeDcInput" class='label'>분류코드설명</label>
							<input type='text' id='divCodeDcInput' name='divCodeDc' placeholder="분류코드설명" data-mini='true'>
						</div>
						<div class="ui-field-contain divUseAtRow">
							<label for="" class='label'>사용여부</label>
							<div class='divUseAt'></div>
						</div>
					</div>
				</div>
			</div>
			<div class='ui-grid-a infoBtnBox'>
				<div class='ui-block-a'>
					<a href='#' data-role='button'  id='_infoSave' class='save' data-icon='check' data-mini='true'>저장</a>
				</div>
				<div class='ui-block-b'>
					<a href='#' data-role='button' id='_infoDelete' class='delete' data-icon='delete' data-mini='true'>삭제</a>
				</div>
			</div>
			<div class='ui-grid-a infoBtnBox'>
				<div class='ui-block-a'>
					<a href='#' data-role='button' id='_infoReset' class='reset' data-icon='refresh' data-mini='true'>초기화</a>
				</div>
				<div class='ui-block-b'>
					<a href='#' id='_rowAdd' class='rowAdd' data-role='button' data-icon='plus' data-mini='true'>행추가</a>
				</div>
			</div>
			<div class='listWrap'>
				<ul class='codeDetailList codeListWrap' data-role='listview' data-inset='true' data-split-icon="move" data-split-theme="a" class='ui-nodisc-icon'>
				</ul>
			</div>
		</div>
	</form>
<div id='detailInfoPopup' class='custom-corners' style='background: #fff;min-width:17em;' data-role="popup" data-overlay-theme="a">
	<form name='detailInfoPopupForm'>
	<h3 class='ui-bar ui-bar-a' style='margin:0;'>코드상세보기</h3>
	<div style='margin:1em;margin-top:0;'>
		<div class="ui-field-contain">
			<label for="detailCode" class='detailLabel'>코드</label>
			<input type='text' id='detailCode' name='code' placeholder="코드" data-mini='true'>
		</div>
		<div class="ui-field-contain">
			<label for="detailCodeNm" class='detailLabel'>코드명</label>
			<input type='text' id='detailCodeNm' name='codeNm' placeholder="코드명" data-mini='true'>
		</div>
		<div class="ui-field-contain">
			<label for="detailCodeDc" class='detailLabel'>코드설명</label>
			<input type='text' id='detailCodeDc' name='codeDc' placeholder="코드설명" data-mini='true'>
		</div>
		<div class="ui-field-contain" >
			<label for="" class='detailLabel'>사용여부</label>
			<div data-role="controlgroup" data-type="horizontal" data-mini="true">
				<input type="radio" name="useAt" id="detailUseAt_y" value="Y" checked>
				<label for="detailUseAt_y">사용</label>
				<input type="radio" name="useAt" id="detailUseAt_n" value="N">
				<label for="detailUseAt_n">사용안함</label>
			</div>
		</div>
	</div>
	<div class='detailInfoPopupButton'>
		<a href='#' id='_detailApply' data-role='button' data-icon='check' data-mini='true'>적용</a>
		<a href='#' id='_detailDelete' data-role='button' data-icon='delete' data-mini='true'>삭제</a>
		<a href='#' id='_detailCancel' data-role='button' data-icon='back' data-mini='true' data-rel='close'>닫기</a>
	</div>
	</form>
</div>
</div>
