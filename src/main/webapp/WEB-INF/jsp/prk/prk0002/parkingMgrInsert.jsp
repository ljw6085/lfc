<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="<%=request.getContextPath()%>/resources/js/d3.min.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/prk/parking-manager.js"></script>
<%-- <script src="<%=request.getContextPath()%>/resources/js/d3.v3.min.js"></script> --%>
<script>
/** 
 화면이동이 필요할때, jsp를 따로 관리하고자 하면
 $j.documents 에 초기화 함수를 push 해야한다. 
 */
$j.documents.push(function() {
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('prkMgrInsertFrm', function($form, $uiPage) {
		var frm = $form[0];
		MENU.createHeaderBackButton($form.find('.header'));
		var backBtn = $form.find('.header').find('a');
		var initParams;
		$j.pageMoveCallback(function(params) {
			initParams = params;
			console.log(initParams);
		});
		
		var svg = d3.select( "svg" );
		var draw = new ParkingManager( svg );
		
		var selectedTargets = '.box.ui-selected';
		$("#controlBox").on('click',function(e){
			switch (e.target.id) {
				case 'cellChange':
					// cell attr change
					var selectedCellType = frm.cellType.value;
					var o = svgUtils.loadedSvgObjectInfo[selectedCellType];
					if( !o ) o = svgUtils.getSvgObjectInfo( selectedCellType );
					
					$(".box.ui-selected").each(function(){
						var t = $(this) ,curCellType = t.data('cellType');
						t.removeClass(curCellType)
							.addClass( selectedCellType )
								.data('cellType' , selectedCellType)
								.attr({
									'width': o.width
									,'height':o.height
								})
					});
					break;
				case 'cellAdd':
					var selectedCellType = frm.cellType.value;
					console.log( selectedCellType );
					svgUtils.withTargetCreate(  $('.box:last') , selectedCellType  );
					
					break;
				case 'cellDel':
					$( selectedTargets ).remove();
					break;
				case 'cellCopy':
					var targets = $( selectedTargets );
					targets.each(function(){
						var rect = svgUtils.withTargetCreate( $(this) );
						$(this).removeClass('ui-selected');
						svgUtils.convertToJquery(rect).addClass('ui-selected');
					});
					break;
				case 'cellAlignH': 
					var targets = $( selectedTargets );
					/*
						// y축 상단정렬 
						var min = 999999;	
						
						// y축 하단정렬
					*/
					// y축 가운데정렬
					var avg = [];
					targets.each(function(){
						var curTop = $(this).data('trans')[1];	
						avg.push( curTop );
					});
					var avgTop = numLib.getAvg( avg );
					targets.each(function(){
						var x = $(this).data('trans')[0];
						var y = avgTop;
						svgUtils.chageTranslate( this , [x,y]);
					});
					break;
				case 'cellAlignV':
					var targets = $( selectedTargets );
					/* x축 좌측정렬*/
					/* x축 가운데정렬*/
					var avg = [];
					targets.each(function(){
						var curLeft  = $(this).data('trans')[0];	
						avg.push( curLeft );
					});
					var avgLeft = numLib.getAvg( avg );
					targets.each(function(){
						var y = $(this).data('trans')[1];
						var x = avgLeft;
						svgUtils.chageTranslate( this , [x,y]);
					});
					/* x축 우측정렬*/
					
					break;
				case 'cellAlign_H_interval':
					/* Y축 간격정렬 */
					var targets = $( selectedTargets );
					var maxRange = 0, targetCnt = targets.length-1; 
					var minLeft = 9999999 , maxLeft = 0;
					targets.each(function(){
						var x =  $(this).data('trans')[0];
						if( minLeft > x ) minLeft = x;
						if( maxLeft < x ) maxLeft = x;
					});
					maxRange = maxLeft - minLeft;
					var gap = maxRange / targetCnt;
					// 사용자정의 간격 세팅
					var isCustomGap = $("#intervalValueChk").prop('checked');
					if( isCustomGap ) gap = +$("#intervalValue").val();
											
					var cursorX = 0;
					targets.each(function(i){
						var tr = $(this).data('trans');
						if( i > 0 ){
							tr[0] = cursorX + gap;
						}
						if( isCustomGap ) {
							cursorX = tr[0]+(+d3.select(this).attr('width'));
						} else{
							cursorX = tr[0];
						}
						svgUtils.chageTranslate( this, tr );
					});
					//chageTranslate
					
					break;
				case 'cellAlign_V_interval':
					/* x축 간격정렬*/
						var targets = $( selectedTargets );
					var maxRange = 0, targetCnt = targets.length-1; 
					var minTop = 9999999 , maxTop = 0;
					targets.each(function(){
						var y =  $(this).data('trans')[1];
						if( minTop > y ) minTop = y;
						if( maxTop < y ) maxTop = y;
					});
					maxRange = maxTop - minTop ;
					var gap = maxRange / targetCnt;
					// 사용자정의 간격 세팅
					var isCustomGap = $("#intervalValueChk").prop('checked');
					if( isCustomGap ) gap = +$("#intervalValue").val();

					var cursorY = 0;
					targets.each(function(i){
						var tr = $(this).data('trans');
						if( i > 0 ){
							tr[1] = cursorY + gap;	
						}
						
						if( isCustomGap ) {
							cursorY = tr[1]+(+d3.select(this).attr('height'));
						}else{
							cursorY = tr[1];
						}
						svgUtils.chageTranslate( this, tr );
					})	;
					break;
				case 'zoomIn':
					draw.svgVar.currentZoom += 0.1;
					svg
						.transition()
						.duration(500)
						.call(draw.zoom.scaleTo, draw.svgVar.currentZoom );
					break;
				case 'zoomReset':
					draw.svgVar.currentZoom = 1;
					svg.transition()
				      .duration(500)
				      .call(draw.zoom.transform, d3.zoomIdentity);
					break;
				case 'zoomOut':
					draw.svgVar.currentZoom -= 0.1;
					svg
					.transition()
					.duration(500)
					.call(draw.zoom.scaleTo, draw.svgVar.currentZoom );
					break;
				case 'fullByCell':
					var selectedCellType = frm.cellType.value;
					var c = 0;
					var r = 0;
					
					var maxWidth = +draw.$view.attr('width');
					var maxHeight = +draw.$view.attr('height');
					var gap = +$("#intervalValue").val();
					var trns = [0,0];
					while(true){
						while( true ){
							var rect = svgUtils.createShapeByType( d3.select( '.viewWrap' ) ,{
								transform:'translate('+(trns[0])+','+(trns[1])+')'
								,cellType:selectedCellType
							});
							var $rect = svgUtils.convertToJquery(rect);
							var h = +rect.attr('height');
							var w = +rect.attr('width');
							trns[0] += w+gap;
							if( r == 0)++c;
							if( maxWidth < trns[0]) {
								trns[1] += h + gap;
								trns[0] = 0;
								break;
							}
						}
						++r;
						if( maxHeight < trns[1] ) break;
					}
					console.log( '가로 ',c,'세로 ',r);
					break;
				case 'makeJson':
					var parking = $("#parkingId").val();
					var floor = $("#floorId").val();
		    		var rects = $('.box');
		    		var boxArray = [];
		    		var minX = 999999;
		    		var maxX = 0;
		    		var minY = 999999;
		    		var maxY = 0;
		    		var maxH = 0;
		    		var maxW = 0;
					rects.each(function(i){
						var t = $(this);
						var shape = this.tagName;
			    		var id = 'box_'+i;
			    		var trans = t.attr('transform');
			    		var cellType = t.attr('cellType');
			    		var xy = svgUtils.getTranslate(trans);
			    		var w = +t.attr('width');
			    		var h = +t.attr('height');
			    		var x = +xy[0] , y = +xy[1];
			    		if( x < minX ) minX = x;
			    		if( x > maxX ) maxX = x;
			    		if( y < minY ) minY = y;
			    		if( y > maxY ) maxY = y;
			    		if( h > maxH ) maxH = h;
			    		if( w > maxW ) maxW = w;
							t.attr('id', id );
							var o = {
									width		:	w
									,height		:	h
									,transform	: 	trans 
									,cellMapngId: 	id
									,styleCls	: 	t.attr('class')
									,style		: 	t.attr('style')
									,cellType	:	cellType
									,shape : shape
									,prkplceCode :parking
									,prkplceFlrCode : floor
								}
							boxArray.push( o );
					});
					console.log( minX+','+minY , maxX+maxW,',',maxY + maxH );
					console.log( boxArray );
					
					var url = "<c:url value='/prk/prk0002/parkingMgrInsert.do'/>";
					Common.ajaxJson( url , boxArray ,function(data){
						console.log( data );
			    	});
					
					break;
			}
			
		});

		$("#intervalValue").val( draw.svgVar.resolution );
		$("#intervalValueChk").on("change",function(){
			var chk = this.checked;
			$("#intervalValue").prop('disabled',!chk);
		}).trigger('change');
		
		
		var cellType = COMPONENT.radio({
			target 		: $(".createTarget")
// 			,appendTo 	: 'before'
			,name		: "cellType"
			,cmmnCode	: 'PRK_CELL_TYPE'
			,classes 	: ''
			,defaultVal : 'P0'
		});
	});
});
</script>
<style type="text/css">
.selectHelper{
	stroke-width: 0;
    stroke: #aaa;
    fill: #000;
	fill-opacity: 0.3;
}
.box:hover{
	cursor:move;
	fill-opacity:0.5
}
.box{
	fill-opacity: 0.8;
    stroke: none;
}
.box.ui-selected { 
	fill: #F39814; 
	color: white;  
}
.P0{/* 기본 */
	fill:darkgray;
}
.P1{/* 소유 */
	fill: darkcyan;
}
.P2{/* 미소유 */
	fill:#333;
}
.P3{/* 타겟 */
	fill: crimson;	
}
.P4{/* 엘리베이터 */
	fill: gold;	
}
.axis path {
  display: none;
}
.axis text{
	display: none;
}
.axis line {
	stroke: #aaa;
	stroke-opacity: 0.3;
	shape-rendering: crispEdges;
}

.view {
  fill:#eee;
  fill-opacity:0.2;
  stroke: #bbb;
  stroke-width:10;
}
.cursorMove{
	cursor:move;
}
</style>
<div data-role="page" id='parkingMgrInsert'>
	<!-- second page start -->
	<form name='prkMgrInsertFrm'>
		<div class='header' data-role='header'>
			<h1>주차장정보 등록/수정</h1>
		</div>
		<div role='main' class='ui-content'>
			<div>
				<div style='width:200px;display: inline-block;' data-type="horizontal" >
					<label for="intervalValueChk">간격사용자정의</label>
					<input type='checkbox' id='intervalValueChk'>
					<input type='text' id='intervalValue' data-mini='true' placeholder='px'>
				</div>
				<div style='width:200px;display: inline-block;'>
					<label for="parkingId">주차장</label>
					<input type='text' id='parkingId' data-mini='true' placeholder='주차장' value='MAIN'>
				</div>
				<div style='width:200px;display: inline-block;'>
					<label for="floorId">층</label>
					<input type='text' id='floorId' data-mini='true' placeholder='층' value='5F'>
				</div>
			</div>
			<div id='controlBox'>
				<div class='createTarget' data-role="controlgroup" data-type="horizontal" data-mini="true">
				</div>
				<div class='controlBox1' data-role="controlgroup" data-type="horizontal" data-mini="true">
					<a href='#' id='cellAdd' class='btn' data-icon='plus'>셀추가</a>
					<a href='#' id='fullByCell' class='btn' data-icon='search'>셀가득채우기</a>
					<a href='#' id='cellChange' class='btn' data-icon='refresh'>셀타입변경</a>
				</div>
				<div class='controlBox2' data-role="controlgroup" data-type="horizontal" data-mini="true">
					<a href='#' id='cellDel' class='btn' data-icon='delete'>선택삭제</a>
					<a href='#' id='cellCopy' class='btn' data-icon='delete'>선택복사</a>
				</div>
				<div class='controlBox3' data-role="controlgroup" data-type="horizontal" data-mini="true">
					<a href='#' id='cellAlignH' class='btn' data-icon='refresh'>가로정렬(T/C/B)</a>
					<a href='#' id='cellAlign_H_interval' class='btn' data-icon='refresh'>가로간격정렬</a>
					<a href='#' id='cellAlignV' class='btn' data-icon='refresh'>세로정렬(L/C/R)</a>
					<a href='#' id='cellAlign_V_interval' class='btn' data-icon='refresh'>세로간격정렬</a>
				</div>
				<div class='controlBox4' data-role="controlgroup" data-type="horizontal" data-mini="true">
					<a href='#' id='zoomReset' class='btn' data-icon='search'>zoomReset</a>
					<a href='#' id='zoomIn' class='btn' data-icon='search'>zoomIn</a>
					<a href='#' id='zoomOut' class='btn' data-icon='search'>zoomOut</a>
					<a href='#' id='makeJson' class='btn' data-icon='search'>Json데이터생성</a>
				</div>
				<div class='controlBox4' data-role="controlgroup" data-type="horizontal" data-mini="true">
					<a href='#' id='makeJson' class='btn' data-icon='search'>Json데이터생성</a>
				</div>
			</div>
			<div style='width:100%;text-align: center;'>
				<svg id='svg' width="800" height="500" style='background: #eee;border:1px solid #aaa;'></svg>
			</div>
		</div>
	</form>
</div>