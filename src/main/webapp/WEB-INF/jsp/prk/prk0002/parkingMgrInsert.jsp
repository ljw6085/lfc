<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
	<title>Insert title here</title>
	<script>var CONTEXT_PATH="<%=request.getContextPath() %>"</script>
	<script src="<%=request.getContextPath() %>/resources/js/jquery-1.12.0.min.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/jquery-ui.min.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/jquery.ui.touch-punch.js"></script>
	
	<script src="<%=request.getContextPath() %>/resources/js/lib/uc-com-lib.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/lib/uc-data-lib.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/lib/uc-date-lib.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/lib/uc-num-lib.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/lib/uc-str-lib.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/lib/uc-form-lib.js"></script>
	<script src="<%=request.getContextPath() %>/resources/js/cmm/common.js"></script>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/jquery-ui.css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/jquery.mobile-1.4.5.css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/common.css">
	<script src="<%=request.getContextPath() %>/resources/js/jquery.mobile-1.4.5.min.js"></script>
	
	<%-- <script src="<%=request.getContextPath()%>/resources/js/d3.min.js"></script> --%>
	<script src="<%=request.getContextPath()%>/resources/js/d3.js"></script>
	<script src="<%=request.getContextPath()%>/resources/js/prk/parking-manager.js"></script>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/parking-css.css">
	<script>
	$(document).ready(function(){
		var svg = d3.select("#svgArea")
					.append("svg")
					.attr("id",'drawableArea')
					.attr('class','parkplaceSVG')
					.attr('width',1000)
					.attr('height',500);
			
			//var svg = d3.select( "svg" );
			var draw = new ParkingManager( svg );
			var minimap;
			var selectedTargets = '#drawableArea > .viewWrap .box.ui-selected';
		
		$(window).bind('resize',function(){
			var body = $('body').height();
			var header = $('#headerBox').outerHeight();
			var info = $('#infoBox').outerHeight();
			var control = $('#controlBox').outerHeight();
			var diff =  body - ( header + info + control);
			
			var width = $('body').width();
			$("#svgArea")
				.height( diff - 100 )
				.width( width - 50 );
			d3.select( $("#drawableArea")[0] )
					.attr('height', diff - 100 )
					.attr('width', width - 60 );
			
			draw.setSvgSize()
// 				.setBackgroundGrid();
			
		}).trigger('resize');
		
		$("#controlBox").on('click',function(e){
			switch (e.target.id) {
				case 'cellChange':
					// cell attr change
					var selectedCellType = $("[name='cellType']:checked").val();;
					var o = svgUtils.loadedSvgObjectInfo[selectedCellType];
					if( !o ) o = svgUtils.getSvgObjectInfo( selectedCellType );
					console.log( o );	
					$( selectedTargets ).each(function(){
						var _t = d3.select(this) , curCellType = _t.attr('cellType');
						_t.attr('cellType', selectedCellType )
							.classed(curCellType  , false)
							.classed(selectedCellType , true)
							.attr('width',o.width)
							.attr('height',o.height);
					});
				break;
				case 'cellAdd':
					var selectedCellType = $("[name='cellType']:checked").val();
					svgUtils.withTargetCreate(  $('#drawableArea > .viewWrap .box:last') , selectedCellType  );
				break;
				case 'cellDel':
					$( selectedTargets ).remove();
				break;
				case 'cellCopy':
					var targets = $( selectedTargets );
					targets.each(function(){
						var rect = svgUtils.withTargetCreate( $(this) , d3.select(this).attr('cellType') );
						
						if( rect.attr('id') )  rect.attr('id', rect.attr('id')+"_cp" );
						
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
					//		var curTop = $(this).data('trans')[1];	
						var curTop = svgUtils.getTranslate( d3.select(this).attr('transform') )[1];	
						avg.push( curTop );
					});
					var avgTop = numLib.getAvg( avg );
					targets.each(function(){
					//		var x = $(this).data('trans')[0];
						var x = svgUtils.getTranslate( d3.select(this).attr('transform') )[0];
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
					//		var curLeft  = $(this).data('trans')[0];	
						var curLeft  = svgUtils.getTranslate( d3.select(this).attr('transform') )[0];	
						avg.push( curLeft );
					});
					var avgLeft = numLib.getAvg( avg );
					targets.each(function(){
					//		var y = $(this).data('trans')[1];
						var y = svgUtils.getTranslate( d3.select(this).attr('transform') )[1];
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
					//		var x =  $(this).data('trans')[0];
						var x =  svgUtils.getTranslate( d3.select(this).attr('transform') )[0];
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
					//		var tr = $(this).data('trans');
						var tr = svgUtils.getTranslate( d3.select(this).attr('transform') );
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
					//		var y =  $(this).data('trans')[1];
						var y =  svgUtils.getTranslate( d3.select(this).attr('transform') )[1];
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
					//		var tr = $(this).data('trans');
						var tr = svgUtils.getTranslate( d3.select(this).attr('transform') );
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
					var selectedCellType = $("[name='cellType']:checked").val();;
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
					var rects = $('#drawableArea > .viewWrap .box');
					var boxArray = [];
					var maxX = 0;
					var maxY = 0;
					var maxH = 0;
					var maxW = 0;
					rects.each(function(i){
						var t = d3.select(this);
						var shape = this.tagName;
						var id = 'box_'+i;
						var trans = t.attr('transform');
						var originalTransform = $(this).data('originalTransform');
						if( originalTransform ) trans = originalTransform;
						var cellType = t.attr('cellType');
						var xy = svgUtils.getTranslate(trans);
					//		var w = +t.attr('width');
					//		var h = +t.attr('height');
						var o = svgUtils.getSvgObjectInfo(cellType);
						var w = +o.width;
						var h = +o.height;
						var x = +xy[0] , y = +xy[1];
						if( x > maxX ) maxX = x;
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
					var w = Math.ceil( maxX+maxW );
					var h = Math.ceil( maxY+maxH );
					var param ={
						prkplceCode : 		parking
						,prkplceFlrCode : 	floor
						,drwSizeWidth :		w
						,drwSizeHeight : 	h
					}
					console.log( param  );
					var url = "<c:url value='/prk/updatePrkFlrData.do'/>";
					Common.ajaxJson( url ,  param ,function(data){
						console.log( data );
					});
					
					var url = "<c:url value='/prk/prk0002/parkingMgrInsert.do'/>";
					Common.ajaxJson( url , boxArray ,function(data){
						console.log( data );
					});
					
				break;
				case 'loadMap':
					var placeId , floorId;
					var param = {
							prkplceCode : $("#parkingId").val()
							,prkplceFlrCode :$("#floorId").val()
					}
					var url = "<c:url value='/prk/selectPrkData.do'/>";
					Common.ajaxJson( url , param ,function(res){
						var target = d3.select('#drawableArea > .viewWrap');
						console.log( res );
						var sizeInfo = res.sizeInfo;
						if( sizeInfo ){
							target.select('.view')
									.attr("width",sizeInfo.drwSizeWidth)
									.attr("height",sizeInfo.drwSizeHeight);
						}
						
						var data = res.list;
						var targetObject;
						for( var i =0, len = data.length; i < len ; i ++ ){
							var d  = data[i]  , applied = {}
							for( var k in d ){
								switch (k) {
								case 'height':
								case 'width':
								case 'transform':
								case 'cellType':
									applied[k] = d[k];
									break;
								case 'styleCls':
									applied['class'] = d[k];
									break;
								case 'cellMapngId':
									applied['id'] = d[k];
									break;
								default:
									break;
								}
							}
							// target인경우 마지막에 append 하자
							if( applied.cellType == 'P3' ){
								targetObject = applied;
							}else{
								svgUtils.createShapeByType( target , applied );
							}
						}
						//마지막에 target create;
						svgUtils.createShapeByType( target , targetObject );
					});
				break;
				case 'currentTarget': // 타겟 애니메이션
					var target = d3.select(".box.P3");
					var loopCount = 0;
					var order = [1, -1];
					var range = 20;
					var delay = 500;
					// original transform setting
					$( target.node() ).data('originalTransform', target.attr('transform') );
					setInterval(function(){
						var w = +target.attr('width') 
							, h = +target.attr('height')
							, tr = svgUtils.getTranslate( target.attr('transform') ) 
							, num = ( order[ loopCount++%2 ] )
							, newW = w + ( num * range )
							, newH = h + ( num * range )
						target.transition()
						        .duration(delay)
						        .ease(d3.easeLinear)
						        .attr('width', newW )
						        .attr('height', newH )
						        .attr('transform','translate('+(tr[0] + (-num *(range/2)))+','+(tr[1] + (-num *(range/2))) +')' )
					}, delay+5 );
					
				break;
				case 'currentTargetFocused':
					var w = d3.select('svg').attr('width')
						,h = d3.select('svg').attr('height')
						,curTrans = svgUtils.getTranslate( draw.viewGroup.attr('transform') )
						,scale = curTrans[2]
						,targetTrans = svgUtils.getTranslate(d3.select(".box.P3").attr('transform') )
						,tW = targetTrans[0] * scale
						,tH = targetTrans[1] * scale
						,resultW = w / 2 - tW
						,resultH = h / 2 - tH;
					
					var z = d3.zoomIdentity.translate(resultW, resultH).scale( scale );
					draw.svg
					        .transition()
							.duration(500)
							.ease(d3.easeLinear)
							.call(draw.zoom.transform , z );
					
				break;
			}
		
		});
		//---------------------------- moving
		
		//----------------- moving;
		$("#intervalValue")
			.val( draw.svgVar.resolution )
			.on("change",function(){
				var chk = this.checked;
				$("#intervalValue").prop('disabled',!chk);
			}).trigger('change');
		
		
		var cellType = COMPONENT.radio({
			target 		: $(".createTarget")
			//,appendTo 	: 'before'
			,name		: "cellType"
			,cmmnCode	: 'PRK_CELL_TYPE'
			,classes 	: ''
			,defaultVal : 'P0'
		});
	});
	
	$(window).on('beforeunload',function(e){
		return "";
	});
	</script>
</head>
<body>
	<div data-role="page" id='parkingMgrInsert'>
		<!-- second page start -->
		<form name='prkMgrInsertFrm'>
			<div id='headerBox' data-role='header'>
				<h1>주차장정보 등록/수정</h1>
			</div>
			<div role='main' >
				<div id='infoBox'>
					<table class='defaultTable'>
						<colgroup>
							<col style='width:20%;'/>
							<col style='width:30%;'/>
							<col style='width:20%;'/>
							<col style='width:30%;'/>
						</colgroup>
						<tbody>
							<tr>
								<th class='insertTh'>주차장</th>
								<td class='insertTd'><input type='text' id='parkingId' name='parkingId' data-mini="true"  placeholder='주차장' value='MAIN' ></td>
								<th class='insertTh'>층</th>
								<td class='insertTd'><input type='text' id='floorId' name='floorId' data-mini="true"  placeholder='층' value='5F' ></td>
							</tr>
							<tr>
								<th class='insertTh'>
									<div style='width:200px;display: inline-block; vertical-align: middle;'>
										<label for="intervalValueChk">간격사용자정의</label>
										<input type='checkbox' id='intervalValueChk' >
									</div>
								</th>
								<td class='insertTd' >
									<div  style='width:100px;display: inline-block;vertical-align: middle;'>
										<input type='text' id='intervalValue' data-mini='true' placeholder='px'>
									</div>
								</td>
								<th class='insertTh'></th>
								<td class='insertTd' >
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id='controlBox'>
					<div class='controlBox createTarget' data-role="controlgroup" data-type="horizontal" data-mini="true"></div>
					<div class='controlBox controlBox1' data-role="controlgroup" data-type="horizontal" data-mini="true">
						<a href='#' id='cellAdd' class='btn' data-icon='plus'>셀추가</a>
						<a href='#' id='fullByCell' class='btn' data-icon='search'>셀가득채우기</a>
						<a href='#' id='cellChange' class='btn' data-icon='refresh'>셀타입변경</a>
					</div>
					<div class='controlBox controlBox2' data-role="controlgroup" data-type="horizontal" data-mini="true">
						<a href='#' id='cellDel' class='btn' data-icon='delete'>선택삭제</a>
						<a href='#' id='cellCopy' class='btn' data-icon='delete'>선택복사</a>
					</div>
					<div class='controlBox controlBox3' data-role="controlgroup" data-type="horizontal" data-mini="true">
						<a href='#' id='cellAlignH' class='btn' data-icon='refresh'>가로정렬</a>
						<a href='#' id='cellAlign_H_interval' class='btn' data-icon='refresh'>가로간격정렬</a>
						<a href='#' id='cellAlignV' class='btn' data-icon='refresh'>세로정렬</a>
						<a href='#' id='cellAlign_V_interval' class='btn' data-icon='refresh'>세로간격정렬</a>
					</div>
					<div class='controlBox controlBox4' data-role="controlgroup" data-type="horizontal" data-mini="true">
						<a href='#' id='zoomReset' class='btn' data-icon='search'>zoomReset</a>
						<a href='#' id='zoomIn' class='btn' data-icon='search'>zoomIn</a>
						<a href='#' id='zoomOut' class='btn' data-icon='search'>zoomOut</a>
						<a href='#' id='makeJson' class='btn' data-icon='search'>Json데이터생성</a>
					</div>
					<div class='controlBox controlBox4' data-role="controlgroup" data-type="horizontal" data-mini="true">
						<a href='#' id='loadMap' class='btn' data-icon='search'>loadMap</a>
					</div>
					<div class='controlBox controlBox4' data-role="controlgroup" data-type="horizontal" data-mini="true">
						<a href='#' id='currentTarget' class='btn' data-icon='search'>currentTarget</a>
					</div>
					<div class=' controlBox controlBox4' data-role="controlgroup" data-type="horizontal" data-mini="true">
						<a href='#' id='currentTargetFocused' class='btn' data-icon='search'>currentTargetFocused</a>
					</div>
				</div>
				<div style='clear: both;'></div>
				<div style='width:100%;text-align: center;margin:10px auto;' id='svgArea'></div>
			</div>
		</form>
	</div>
</body>
</html>