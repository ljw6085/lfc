<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="<%=request.getContextPath()%>/resources/js/d3.min.js"></script>
<%-- <script src="<%=request.getContextPath()%>/resources/js/d3.v3.min.js"></script> --%>
<script>
/** 
 화면이동이 필요할때, jsp를 따로 관리하고자 하면
 $j.documents 에 초기화 함수를 push 해야한다. 
 */
 //translate형태로 하자!
 /////////////// zoom, selectable 호환 적용해야함.
 //https://github.com/d3/d3-drag/blob/master/README.md#drag
 //http://www.redblobgames.com/articles/curved-paths/making-of.html
 //https://bl.ocks.org/danasilver/cc5f33a5ba9f90be77d96897768802ca
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
	
		var margin = {top: -5, right: -5, bottom: -5, left: -5};
// 	    width = 1500 - margin.left - margin.right,
// 	    height = 1500 - margin.top - margin.bottom;
		var svg = d3.select('#svg')
			,width = +svg.attr("width")
		    ,height = +svg.attr("height");
		
		var isZoom = false
			,orgTransform
			,orgTransformApply = false
			,ZOOM_MIN = 0.2,ZOOM_MAX = 10
			,curEvent
			,resolution = 20
			,currentZoom = 1;
		//도화지에 적용될 zoom 이벤트 세팅
		var zoom = d3.zoom()
					.scaleExtent([ZOOM_MIN, ZOOM_MAX])	// x0.2 ~ x2  ZOOM 범위 설정 
					.translateExtent([[0, 0], [width, height]])
					.on('start',function(e){
						if( !d3.event.sourceEvent )return;
							isZoom = !d3.event.sourceEvent.ctrlKey 
							if(  !isZoom ){
								orgTransform = d3.event.transform
								selectingDragStart();
							}else{
								$(".box2.ui-selected").removeClass('ui-selected');
							}
					})
					.on("zoom", zoomFunc)
					.on("end", function(){
						selectingDragEnd();
					});
		// 도화지 세팅	
		
		svg.call(zoom);
		
		// 배경 그리드 line 세팅
		var container = svg.append("g");
		
		
		// 선택된 객체들에 대한 셀렉트쿼리
		var selectedTargets = '.box2.ui-selected';
		$("#controlBox").on('click',function(e){
				switch (e.target.id) {
					case 'cellAdd':
						withTargetCreate( $('.box2:last') );
						break;
					case 'cellDel':
						$( selectedTargets ).remove();
						break;
					case 'cellCopy':
						var targets = $( selectedTargets );
						targets.each(function(){
							var rect = withTargetCreate( this );
							$(this).removeClass('ui-selected');
							convertToJquery(rect).addClass('ui-selected');
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
							chageTranslate( this , [x,y]);
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
							chageTranslate( this , [x,y]);
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
							chageTranslate( this, tr );
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
							chageTranslate( this, tr );
						})	;
						break;
					case 'zoomIn':
						currentZoom += 0.1;
						svg
							.transition()
							.duration(500)
							.call(zoom.scaleTo, currentZoom );
						break;
					case 'zoomReset':
						currentZoom = 1;
						svg.transition()
					      .duration(500)
					      .call(zoom.transform, d3.zoomIdentity);
						break;
					case 'zoomOut':
						currentZoom -= 0.1;
						svg
						.transition()
						.duration(500)
						.call(zoom.scaleTo, currentZoom );
						break;
				}
			
		});

		$("#intervalValue").val(resolution);
		$("#intervalValueChk").on("change",function(){
			var chk = this.checked;
			$("#intervalValue").prop('disabled',!chk);
			console.log( chk );
		}).trigger('change');
		
		/*
		 target을 기준으로 rect를 생성한다.	
		*/	
		function withTargetCreate( target ){
			var trns = $(target).data('trans');
			if( !trns ) trns = [ 0.0 , 0.0 ];
			else trns = [ trns[0]+resolution , trns[1]+resolution ];

			return createRect( d3.select('svg').select('g') ,{
				transform:'translate('+(trns[0])+','+(trns[1])+')'
				,trans : trns
			});
		}	
		/* d3 객체를 jquery 객체로 변환한다*/
		function convertToJquery( d3Object ){
			return $(d3Object._groups[0][0])
		}	
		/* jquery 객체를 d3객체로 변환한다 */
		function convertToD3( jqueryObejct ){
			return d3.select( $(jqueryObject)[0] );
		}
		
		
		container.append('g')
			.selectAll('.vertical')
		    .data(d3.range(1, width / resolution))
		  .enter().append('line')
		    .attr('class', 'vertical')
		    .attr('x1', function(d) { return d * resolution; })
		    .attr('y1', 0)
		    .attr('x2', function(d) { return d * resolution; })
		    .attr('y2', height);

		container.append('g')
			.selectAll('.horizontal')
		    .data(d3.range(1, height / resolution))
		  .enter().append('line')
		    .attr('class', 'horizontal')
		    .attr('x1', 0)
		    .attr('y1', function(d) { return d * resolution; })
		    .attr('x2', width)
		    .attr('y2', function(d) { return d * resolution; });

		function zoomFunc(){
			if( isZoom ){
				var trans = d3.event.transform; 
				if( orgTransformApply && orgTransform){
					svg.transition().duration(0).call(zoom.transform, orgTransform);
					orgTransformApply = false;
					orgTransform = null;
				}
				container.attr("transform", trans);
			}
			else{
				selectingDragging();
			}
		}
		
		function createRect( pGroup , $option ){
			var option = {
					'class':'box2'
					,'width':25	
					,'height':40
					,'transform':'translate(0,0)'
			}
			if( typeof $option == 'object') $.extend( option , $option );

			var newG = pGroup.append('g');
			var rect = newG.append('rect');

			for( var k in option){ rect.attr(k,option[k]); }
			rect.call(d3.drag().on("start", snapStart).on("drag", snapDrag));
	
			var trns = [ 0.0, 0.0 ];
			if( $option.trans ){ trns = $option.trans ; }
			$(rect._groups[0][0]).data({ trans: trns  });
			
			return rect;
		}	
		
		var target;
		var targetList = $([]);
		function snapStart(){
			target = d3.event.sourceEvent.target;
			if( !$(target).hasClass('ui-selected') ){
				$(target).addClass('ui-selected');
			}else{
				if(d3.event.sourceEvent.ctrlKey){
					$(target).removeClass('ui-selected');
				}
			}	
			targetList = $('.ui-selected');
		}
		
		function snapDrag() {
			 var gp = resolution/2
				, evt = d3.event , _t = this , t = $(_t)
				,x = evt.x , y = evt.y
				,w = +t.attr('width')
				,h = +t.attr('height')
				,gridX = round(Math.min(width, x), gp) - (w/2)
				,gridY = round(Math.min(height, y), gp) - (h/2) ;

			  	gridX = Math.round( gridX /gp ) * gp ;
			  	gridY = Math.round( gridY /gp) * gp ;
			
			  	//--------------------------------------------
			  	if( 0 > gridX ) gridX = 0;
			  	if( 0 > gridY) gridY = 0;
			  	if( width - w < gridX )	gridX = width-w;
			  	if( height - h < gridY )gridY = height-h;
			  	//-----------------------------------------------
			  	
			  	var tempTrans = t.data('trans');
			  	var newTrans = [gridX,gridY];
				chageTranslate(_t, newTrans );
				var diffTrans = [newTrans[0]-tempTrans[0], newTrans[1]-tempTrans[1]];
				
			  targetList.not(_t).each(function(){
				  	var tr = $(this).data('trans');
				  	tr[0] += diffTrans[0];
				  	tr[1] += diffTrans[1];
					chageTranslate( this, tr );
			  });
		}

		function round(p, n) {
		  return p % n < n / 2 ? p - (p % n) : p + n - (p % n);
		}
		
		// 객체 이동
		function chageTranslate( target , posArray ){
			  d3.select( target ).attr('transform','translate('+posArray[0]+','+posArray[1]+')');
			  $(target).data('trans',posArray);
		}		
		//---------------------------------- svg selectable	
		var svgSelectable={
			opos : []
			,helper: null
			,$helper:null			
		}
		var clicked = false;
		var dragging = false;
	
		var helper = svg.append('rect').attr('class','selectHelper').attr('transform',"translate("+0+","+0+")");
		$(helper._groups[0][0]).data({
			trans:[0.0,0.0]
		});
	
		svg.call(d3.drag()
			.on('start', selectingDragStart)
			.on("drag", selectingDragging)
			.on('end',selectingDragEnd));
		
		function selectingDragStart(){
			var event = d3.event.sourceEvent;
			var target = event.target;
			if(event && !event.ctrlKey ){
				$(".box2.ui-selected").removeClass('ui-selected');
				return;
			}
			if( event.target != $("#svg")[0] )return;
			$(".box2.ui-selected").removeClass('ui-selected');
			
			clicked = true;
			
			svgSelectable.opos[0] = event.pageX - $(target).offset().left 
			svgSelectable.opos[1] = event.pageY - $(target).offset().top
			if( !svgSelectable.helper ){
				svgSelectable.helper = d3.select(".selectHelper");
				svgSelectable.$helper = $(".selectHelper");
			}
			var trn = svgSelectable.$helper.data('trans');
			trn[0] = svgSelectable.opos[0];
			trn[1] = svgSelectable.opos[1];
			var trns = "translate(" + trn[0]+","+trn[1] + ")";
			svgSelectable.helper.attr('transform',trns);
			svgSelectable.$helper.data('trans',trn);
		}
		function selectingDragging(){
			var event = d3.event.sourceEvent;
			var target = $("#svg");
			if(event&& !event.ctrlKey ){
				svgSelectable.$helper.hide();
				dragging = clicked = false;
				return;
			}
			if (!clicked ) return;
			svgSelectable.$helper.show();
			
			dragging = true;
			var tmp,
				offset = target.offset(),
				x1 = svgSelectable.opos[0],
				y1 = svgSelectable.opos[1],
				x2 = event.pageX - offset.left,
				y2 = event.pageY - offset.top;

			if (x1 > x2) { tmp = x2; x2 = x1; x1 = tmp; }
			if (y1 > y2) { tmp = y2; y2 = y1; y1 = tmp; }
			var curTrns = svgSelectable.$helper.data('trans');
			curTrns[0] = x1;
			curTrns[1] = y1;
			
			var newTrns = "translate(" + curTrns[0] +','+curTrns[1]+ ")";// scale("+scale+")";
			svgSelectable.helper
				.attr('transform',newTrns)
				.attr('width', x2 - x1 )
				.attr('height', y2 - y1 );
			svgSelectable.$helper.data('trans',curTrns);
			
			var selectableItem = $(target).find(".box2");
			
			var scale = container.attr('transform');
			if( scale ){
				scale = scale.match(/scale(.+)/g)[0];
				scale = +scale.substring(6,scale.length-1);
			}else{
				scale = 1;
			}
			
			for(var i = 0 ; i<selectableItem.length;i++){
				var $item 	= $( selectableItem[i] ) ,item = d3.select($item[0]);
				var  curTrns = $item.data('trans');
				
				var	left 	= $( selectableItem[i] ).offset().left - $("#svg").offset().left//+curTrns[0] 
					,top 	= $( selectableItem[i] ).offset().top - $("#svg").offset().top//+curTrns[1] 
					,width 	= +item.attr('width') * scale
					,height = +item.attr('height') *scale
					,right 	= left + width 
					,bottom = top + height;
				//------ left,right,top,bottom --> 부모(g)태그의 scale을 곱해야함.
				var hit = ( !( left > x2 || right < x1 || top > y2 || bottom < y1) );
				
				if( hit ) {
					$item.addClass('ui-selected');
					$item.data('selected',true);
				}else{
					if ( $item.data('selected') ) {
						$item.removeClass("ui-selected");
						$item.data('selected', false);
					}
				}
			}
		}
		function selectingDragEnd(){
			if( dragging && clicked )svgSelectable.$helper.hide();
			dragging = clicked = false;
			orgTransformApply = true;
		}
	});
});
</script>
<style type="text/css">
.crossHair {
	cursor:crosshair;
}
.selectHelper{
	stroke-width: 0;
    stroke: #aaa;
    fill: #000;
	fill-opacity: 0.3;
}
.box2:hover{
	cursor:move;
}
.box2{
	fill-opacity: 0.9;
    stroke: none;
    fill: darkcyan;
}
.box2.ui-selected { 
	fill: #F39814; color: white;  
}

line {
  stroke: #757575;
    stroke-width: 1px;
    shape-rendering: crispEdges;
    stroke-dasharray: 3;
    stroke-dashoffset: 4;
}
#svg {
	stroke:#000;
	stroke:1px;
}
</style>
<div data-role="page" id='parkingMgrInsert'>
	<!-- second page start -->
	<form name='prkMgrInsertFrm'>
		<div class='header' data-role='header'>
			<h1>주차장정보 등록/수정</h1>
		</div>
		<div>
			<div style='width:200px;' data-type="horizontal">
				<label for="intervalValueChk">간격사용자정의</label>
				<input type='checkbox' id='intervalValueChk'>
				<input type='text' id='intervalValue' data-mini='true' placeholder='px'>
			</div>
		</div>
		<div id='controlBox'>
			<a href='#' id='cellAdd' class='btn' data-icon='plus'>셀추가</a>
			<a href='#' id='cellDel' class='btn' data-icon='delete'>선택삭제</a>
			<a href='#' id='cellCopy' class='btn' data-icon='delete'>선택복사</a>
			<a href='#' id='cellAlignH' class='btn' data-icon='refresh'>가로정렬(T/C/B)</a>
			<a href='#' id='cellAlign_H_interval' class='btn' data-icon='refresh'>가로간격정렬</a>
			<a href='#' id='cellAlignV' class='btn' data-icon='refresh'>세로정렬(L/C/R)</a>
			<a href='#' id='cellAlign_V_interval' class='btn' data-icon='refresh'>세로간격정렬</a>
			<a href='#' id='zoomReset' class='btn' data-icon='search'>zoomReset</a>
			<a href='#' id='zoomIn' class='btn' data-icon='search'>zoomIn</a>
			<a href='#' id='zoomOut' class='btn' data-icon='search'>zoomOut</a>
			<a href='#' id='fullByCell' class='btn' data-icon='search'>셀가득채우기</a>
		</div>
		<div role='main' class='ui-content' style='max-width:2000px !important;max-height:650px; overflow: scroll;text-align: center;'>
			<svg id='svg' width="1300" height="600" style='background: #eee;'></svg>
		</div>
	</form>
</div>