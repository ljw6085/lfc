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
	$j.documentReady('carModelInsertForm', function($form,$uiPage){
		var frm = $form[0];
		MENU.createHeaderBackButton( $form.find('.header') );
		var backBtn = $form.find('.header').find('a');
		
		$(".companyListInsert").on('change',function(){
			var gbn = $("[name='carComp']:checked").val();
			var selectedCompany = $("select."+gbn+" > option:selected").val();
			
// 			$(this).closest('.ui-grid-a').next(".carAttr").find('.title').next('div').slideDown('fast');
		});
		
		$('.carAttr').on('click',function(e){
			var $t = $(e.target);
			if( !$t.hasClass('selectItem')) { return; }
			if( $t.hasClass('selected') ){
				$t.removeClass('selected');
				$(this).find(".currentValue").text('');
				return;
			}
				$(this).find('.selected').removeClass('selected');
				$t.addClass('selected' ,{duration:50});
				$(this).find(".currentValue").text( "선택 : " + $t.text() );
		});
		
		$(".ui-bar-d.title").on('click',function(){
// 			$(this).nextAll('div').slideToggle('fast');
		});
		
		$form.find("#save").on('click',function(){
			if( !confirm('저장하시겠습니까?') ) return;
			
			var gbn = $("[name='carComp']:checked").val() 
				, selectedCompany = $("select."+gbn+" > option:selected").val() 
				, carKind = $("#carKindList .selected").attr('data-value') 
				, carOutline = $("#carOutlineList .selected").attr('data-value') 
				, carFure = $("#carFureList .selected").attr('data-value') 
				, carMsn = $("#carMsnList .selected").attr('data-value') 
				, modelNm = $("#modelNm").val();
			
			var param = {
					carComp : selectedCompany
					,carKind : carKind
					,carOutline:carOutline
					,carFure:carFure
					,carMsn:carMsn
					,modelNm:modelNm
			}
			var msgBox = {
					carKind : "차종을 선택하세요"
					,carOutline:"외관을 선택하세요"
					,carFure:"연료를 선택하세요"
					,carMsn:"미션을 선택하세요"
					,modelNm:"모델명을 입력하세요"
			}
			for( var k in param ){
				var v = param[k] ;
				var msg = '';
				switch (k) {
					case 'carComp':
						if( v == '국내차' || v == '외제차' ) {
							alert("제조사를 선택하세요.");
							return;
						}
						break;
					
					default:
						if( !v ) {
							alert( msgBox[k] );
							return;
						}
						break;
				}
			}
			param.rowStatus = $("[name='rowStatus']").val();
			param.modelCode = $("[name='modelCode']").val();
			var url = "<c:url value='/mgr/mgr0006/MGR0006$Insert.do'/>";
			Common.ajaxJson( url , param ,function(data){
				if( data.ok > 0 ){
					alert('정상적으로 처리되었습니다.');
				}else{
					alert('오류가 발생하였습니다. 다시 시도해주세요.');
				}
	    	});
		});
	});
});
</script> 
<style>
	.ui-block-a label { border-right:1px solid #ddd;}
	
	.selectItem { font-weight: normal;}
/* 	.selectItem.selected { background: #3388cc  !important ; box-shadow: inset 5px  5px 5px rgba(0,0,0,.15) !important;} */
	.currentValue { float: right; }
	.titleText { float:left;}
	.ui-bar-a { font-size:0.8em;}
	.selectCompanyList .ui-select { margin:0;}
	
	.mb0_3 { margin-bottom: 0.3em;}
</style>
<div data-role="page" id='carModelInsert'><!-- second page start -->
	<form name='carModelInsertForm'>
		<input type="hidden" name="rowStatus" value='C'/>
		<input type="hidden" name="modelCode" value=''/>
		<div class='header' data-role='header'><h1>주차장코드 등록/수정</h1></div>
		<div role='main' class='ui-content'>
			<div id='infoArea' style='text-align: center;'>
				<div class='ui-grid-a mb0_3'>
					<div class="ui-bar ui-bar-d title"><span class="titleText">1. 제조사 선택</span></div>
					<div class='ui-block-a'>
						<div class='ui-bar ui-bar-a' id='carComp' style='padding :6px;'></div>
					</div>
					<div class='ui-block-b' >
						<div class='ui-bar ui-bar-a selectCompanyList' style='padding :6px;'>
							<select name="companyList" class="companyListInsert filterable-select CAR_COMP_INTER"  id="company-list-inter-insert" data-native-menu="false" data-mini='true'>
								<option>국내차</option>
							</select>
							<select name="companyList" class="companyListInsert filterable-select CAR_COMP_EXTER"  id="company-list-exter-insert" data-native-menu="false" data-mini='true'>
								<option>외제차</option>
							</select>
						</div>
					</div>
				</div>
				<!-- 차종 -->
				<div id='carKindList' class='carAttr mb0_3'></div>
				<!-- 외관 -->
				<div id='carOutlineList' class='carAttr mb0_3'></div>
				<!-- 연료 -->
				<div id='carFureList' class='carAttr mb0_3'></div>
				<!-- 미션 -->
				<div id='carMsnList' class='carAttr mb0_3'></div>
				<div class='ui-grid-a' style='background: #eee;'>
					<div class="ui-bar ui-bar-d title"><span class="titleText">6. 모델명입력</span></div>
					<input type='text' data-mini='true' placeholder='모델명을 입력하세요.' id='modelNm' name='modelNm'>
				</div>
				<div class='ui-grid-a'>
					<a href='#' data-role='button' data-icon='check' id='save'>저장</a>
				</div>
			</div>
			<div>
				<div class="ui-field-contain">
					
				</div>
			</div>
		</div>
	</form>
</div>
<script>
	var carCompGbn = COMPONENT.radio({
		target 		: $('#carComp')
		,name		: 'carComp'
		,cmmnCode	: carComp
	});
	
	/* var carMsnGbn = COMPONENT.radio({
		target 		: $('#carMsn')
		,name		: 'carMsn'
		,cmmnCode	: carMission
	}); */
	
	var $compInterList = $("#company-list-inter-insert");
	for( var k in carCompInter ){
		var opt = "<option value='"+k+"'>"+carCompInter[k]+"</option>";
		$compInterList.append( opt );
	}
	
	var $compExterList = $("#company-list-exter-insert");
	for( var k in carCompExter ){
		var opt = "<option value='"+k+"'>"+carCompExter[k]+"</option>";
		$compExterList.append( opt );
	}

	var repeat = [
		{
			target :$("#carMsnList") 
			,title : '<div class="ui-bar ui-bar-d title"><span class="titleText">5. 미션 선택</span><span class="currentCarMsn currentValue"></span></div>'
			,option : {
			  	data : carMission
				, cellCount : 2
				, addClass:['selectItem']
			}
		},
		{
			target :$("#carFureList") 
			,title : '<div class="ui-bar ui-bar-d title"><span class="titleText">4. 연료 선택</span><span class="currentCarFure currentValue"></span></div>'
			,option : {
			  	data : carFure
				, cellCount : 3
				, addClass:['selectItem']
			}
		},
		{
			target :$("#carOutlineList") 
			,title : '<div class="ui-bar ui-bar-d title"><span class="titleText">3. 외관 선택</span><span class="currentCarOutline currentValue"></span></div>'
			,option : {
			  	data : carOutline
				, cellCount : 3
				, addClass:['selectItem']
			}
		},
		{
			target :$("#carKindList") 
			,title : '<div class="ui-bar ui-bar-d title"><span class="titleText">2. 차종 선택</span><span class="currentCarKind currentValue"></span></div>'
			,option : {
			  	data : carKind
				, cellCount : 3
				, addClass:['selectItem']
			}
		}
	]
	
	for( var i = 0 , len=repeat.length; i < len ; i ++){
		var o = repeat[i];
		$j.makeGridGroup( o.target , o.title, o.option );
	}
	
	$(document).ready(function(){
		
		$("#company-list-exter-insert-button").hide();
		
		$("[name='carComp']").on('change',function(){
			if( this.value.indexOf('EXTER') > -1   ){
				$("#company-list-exter-insert-button").show();
				$("#company-list-inter-insert-button").hide();
			}else{
				$("#company-list-exter-insert-button").hide();
				$("#company-list-inter-insert-button").show();
			}
		});
	});
</script>