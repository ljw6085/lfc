<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
	#detailSearch .ui-panel-inner{padding:0;}
	p.company{font-size:0.8em; margin:0; padding:0;}
	.companyList { max-height:200px;overflow-y:scroll;border:1px solid #ddd;text-align: center;}
	.ui-block-a
	,.ui-block-b
	,.ui-block-c
	,.ui-block-d
	,.ui-block-e
	, .companyList .ui-btn { padding:0; margin:0;}
	.grid-block{ 
		min-height:85px;
		border-right: 1px solid #ddd;
    	border-bottom: 1px solid #ddd;
	}
	.ui-block-e.grid-block { border-right:0;}
	.selected{
		background: #044363 !important;
	    color: #fff !important;
	}
	.car-kind ,.car-fure  {}
	.car-fure {}
/* 	.title{border-top:0;border-bottom:0;} */
	.cont{ border-top:0; }
	#detailSearch .ui-corner-all{
		-webkit-border-top-left-radius: 0;
	    border-top-left-radius: 0;
	    -webkit-border-top-right-radius: 0;
	    border-top-right-radius: 0;
		-webkit-border-bottom-left-radius: 0;
	    border-bottom-left-radius: 0;
	    -webkit-border-bottom-right-radius: 0;
	    border-bottom-right-radius: 0;
	}
	.ui-block-a label,  .ui-block-a .ui-bar{ border-right:0;}
	.ui-selectmenu-list.ui-listview{ margin-top:0;}
	.ui-selectmenu .ui-input-clear{ padding:0;}
	.detailSearch .ui-select {margin-top:0; margin-bottom:0;}
</style>
<!-- 상세조회옵션 판넬 -->
	<div id="detailSearch" data-role='panel' data-position='right' data-display='overlay' data-position-fixed="true" >
<!-- 			<div class='ui-bar ui-bar-c'>상세조회옵션</div> -->
			<div class='ui-bar ui-bar-c'>제조사</div>
			<div class='detailSearch'>
				<select name="carComp" class="filterable-select"  id="company-list" data-native-menu="false" data-has-icon='true'>
					<option value="">제조사</option>
					<option value="" >전체</option>
				</select>
			</div>
			<div class='detailSearch'>
				<div class='car-model'>
					<div class='ui-bar ui-bar-c title'>모델명</div>
				</div> 
				<div class='car-model cont' data-iconpos="right" data-mini='true'  style='padding:0.5em;'>
					<input type='search' name='modelNm' placeholder='모델명을입력하세요.'>
				</div> 
			</div>
			<div>
				<div class='ui-grid-a'>
					<div class='ui-block-a car-kind'>
						<div class='ui-bar ui-bar-c title'>차종</div>
					</div> 
					<div class='ui-block-b car-fure'>
						<div class='ui-bar ui-bar-c title'>연료</div>
					</div>
				</div>
				<div class='ui-grid-a'>
					<!-- 자동차종류 -->
					<div class='ui-block-a car-kind cont' id='carKind' data-role="controlgroup" data-iconpos="right" data-mini='true'></div>
					<!-- 자동차연료구분 -->
					<div class='ui-block-b car-fure cont' id='carFure' data-role="controlgroup" data-iconpos="right" data-mini='true'></div>
				</div>
			</div>
			<div class='ui-bar ui-bar-c title'>외관</div>
			<div>
				<!-- 자동차 외관 -->
				<div class='ui-grid-a car-outline-wrap'>
					<div class='ui-block-a cont' id='car-outline-0' data-role="controlgroup" data-iconpos="right" data-mini='true'></div>
					<div class='ui-block-b cont' id='car-outline-1' data-role="controlgroup" data-iconpos="right" data-mini='true'></div>
				</div>
			</div>
			<div class='ui-bar ui-bar-c title'>미션</div>
			<div>
				<!-- 자동차 미션 -->
				<div class='ui-grid-a car-mission-wrap'>
					<div class='ui-block-a cont' id='car-mission-0' data-role="controlgroup" data-iconpos="right" data-mini='true'></div>
					<div class='ui-block-b cont' id='car-mission-1' data-role="controlgroup" data-iconpos="right" data-mini='true'></div>
				</div>
			</div>
	</div>
<script>
	var $compList = $("#company-list");
	for( var k in totalCompList ){
		var opt = "<option value='"+k+"'>"+totalCompList[k]+"</option>";
		$compList.append( opt );
	}
	
	// car kind list
	var $carKind = $("#carKind") , carKindHtml=""
	for( var k in carKind ){
		var val = carKind[k] 
			, id = "car-kind-"+k;
		carKindHtml += "<label for='"+id+"'>"+val+"</label>";
		carKindHtml += "<input type='checkbox' id='"+id+"' name='carKind' value='"+k+"' data-label='"+val+"'>";
		
	}
	$carKind.html( carKindHtml );
	
	
	var $carFure = $("#carFure") , carFureHtml=""
	for( var k in carFure ){
		var val = carFure[k] 
			, id = "car-fure-"+k;
		carFureHtml += "<label for='"+id+"'>"+val+"</label>";
		carFureHtml += "<input type='checkbox' id='"+id+"' name='carFure' value='"+k+"' data-label='"+val+"'>";
		
	}
	$carFure.html( carFureHtml );
	
	
	var i=0;
	for( var k in carOutline ){
		var area = i % 2  
			, val = carOutline[k] 
			, id = "car-outline-"+k 
			, carOutlineHtml=""
			carOutlineHtml += "<label for='"+id+"'>"+val+"</label>";
			carOutlineHtml += "<input type='checkbox' id='"+id+"' name='carOutline' value='"+k+"' data-label='"+val+"'>";
		
		$("#car-outline-"+area).append( carOutlineHtml );
		i++;
	}
	
	var i=0;
	for( var k in carMsn ){
		var area = i % 2  
			, val = carMsn[k] 
			, id = "car-mission-"+k 
			, carMissionHtml=""
			carMissionHtml += "<label for='"+id+"'>"+val+"</label>";
			carMissionHtml += "<input type='checkbox' id='"+id+"' name='carMsn' value='"+k+"' data-label='"+val+"'>";
		
		$("#car-mission-"+area).append( carMissionHtml );
		i++;
	}
	

</script>
