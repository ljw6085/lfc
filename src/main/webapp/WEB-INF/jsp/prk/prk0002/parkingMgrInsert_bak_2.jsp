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
	
		var svg = d3.select('#svg');
		var g = svg.select('#wrapG');
		
		$("#cellAdd").on('click',function(){
			var rect = g.append("rect")
							.attr('class','box2')
							.attr('width',50)
							.attr('height',80)
							.attr('x',10)
							.attr('y',10)
							.attr('transform',"translate(0,0)"); //translate
// 							.attr('transform',"matrix(1 0 0 1 0 0)"); // matrix
			$(rect._groups[0][0]).data({
// 				matrix:[1.0,0.0,0.0,1.0,0.0,0.0]
				trans:[0.0,0.0]
			});
			rect.call(d3.drag()
						.on("start", snapStart)
						.on("drag", snapDrag));
// 						.on("drag", on_drag)
// 						.on('start',drag_start)
// 						.on('end',drag_end));
		});
		
		var isZoom = false;
		var ZOOM_MIN = 0.2,ZOOM_MAX = 10;
		var curEvent;
		var zoom = d3.zoom()
					.scaleExtent([ZOOM_MIN, ZOOM_MAX])	// x0.2 ~ x2  ZOOM 범위 설정 
					.on("zoom", function(){
						//zoom 이벤트 콜백함수
					  	g.attr("transform", d3.event.transform );
					})
					; 	// zoom 이벤트 바인드
		svg.call( zoom );
		
		var position = [0,0,0,0];  // internal variable
		var target; 
		function drag_start(d){
			target = d3.event.sourceEvent.target;
		}
		function drag_end(){
		}
		
		function on_drag() {
			if( target.tagName != 'rect') return; 
		    var position = d3.event
		    var trans= d3.select( target ).attr('transform');
		    	trans = trans.substring(10,trans.length-1).split(',');
		    	for( var i in trans ) trans[i] = parseFloat(trans[i]);
		    	trans[0] += position.dx;
		    	trans[1] += position.dy;
	    		d3.select( target ).attr('transform','translate('+trans[0]+','+trans[1]+')');
	    		$(target).data('trans',trans);
		   
		 /*   var matrix = d3.select( target ).attr('transform');
	    		matrix = matrix.substring(7,matrix.length-1).split(' ');
	    		for( var i in matrix ) matrix[i] = parseFloat(matrix[i]);
	    		matrix[4] += position.dx;
	    		matrix[5] += position.dy;
	    	d3.select( target ).attr('transform','matrix('+matrix.join(' ')+')'); 
	    	$(target).data('matrix',matrix); */
	    	console.log('-------------!!!?!?!?!');
	    	// selected 동시 moving
	    	$('.box2.ui-selected').not(target).each(function(){
	    		var trn = $(this).data('trans');
	    			trn[0] += position.dx;
	    			trn[1] += position.dy;
		    	d3.select( this ).attr('transform','translate('+trn[0]+','+trn[1]+')'); 
		    	$(this).data('trans',trn);
/* 	    		var mat = $(this).data('matrix');
		    		mat[4] += position.dx;
		    		mat[5] += position.dy;
		    	d3.select( this ).attr('transform','matrix('+mat.join(' ')+')'); 
		    	$(this).data('matrix',mat); */
	    	});
	    	
	    	/* 
	    	  translate(50,50) rotate(-45) translate(-25,-50)
	    	.attr("transform", function() {
	    	    return d3.svg.transform()
	    		    .translate(50, 50)
	    		    .rotate(-45)
	    		    .translate(-d3.select(this).attr("width")/2, -d3.select(this).attr("height")/2)()
	    	} */
		}
		
		var width = 960,
	    height = 500,
	    resolution = 20,
	    r = 15;
		var position = [0,0,0,0];  // internal variable
		var target; 
		function snapStart(){
			target = d3.event.sourceEvent.target;
		}
		function snapDrag() {
		 var x = d3.event.x,
			      y = d3.event.y,
			      gridX = round(Math.max(r, Math.min(width, x)), resolution) - (+$(this).attr('width')/2),
			      gridY = round(Math.max(r, Math.min(height, y)), resolution) - (+$(this).attr('height')/2) ;
		  var trn = [ gridX,gridY ];
		  d3.select( this ).attr('transform','translate('+trn[0]+','+trn[1]+')');
		}

		function round(p, n) {
		  return p % n < n / 2 ? p - (p % n) : p + n - (p % n);
		}
		
		var svgSelectable={
				opos : []
				,helper: null
				,$helper:null			
			}
			var clicked = false;
			var dragging = false;
			var boxClicked = false;
			var boxDragging = false;
			var boxClickedPos = {x:0,y:0}
			var draggingTarget = []
		
			var helper = svg.append('rect').attr('class','selectHelper').attr('transform',"translate("+0+","+0+")");
			$(helper._groups[0][0]).data({
				trans:[0.0,0.0]
			});
/* 			var helper = svg.append('rect').attr('class','selectHelper').attr('transform',"matrix(1 0 0 1 0 0)");
			$(helper._groups[0][0]).data({
				matrix:[1.0,0.0,0.0,1.0,0.0,0.0]
			}); */
// 			var g2 = svg.select('#helper').append(helper);
			
			svg.call(d3.drag()
				.on('start', selectingDragStart)
				.on("drag", selectingDragging)
				.on('end',selectingDragEnd));
			
			function selectingDragStart(){
				var event = d3.event.sourceEvent;
				var target = event.target;
				console.log(event.ctrlKey , event.target  );
				if( !event.ctrlKey ){
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
/* 				    var mat = svgSelectable.$helper.data('matrix');
				mat[4] = svgSelectable.opos[0];
				mat[5] = svgSelectable.opos[1];
				var newMatrix = "matrix(" + mat.join(' ') + ")";
				svgSelectable.helper.attr('transform',newMatrix);
				svgSelectable.$helper.data('matrix',mat); */
			    var trn = svgSelectable.$helper.data('trans');
				trn[0] = svgSelectable.opos[0];
				trn[1] = svgSelectable.opos[1];
				var trns = "translate(" + trn[0]+","+trn[1] + ")";
				svgSelectable.helper.attr('transform',trns);
				svgSelectable.$helper.data('trans',trn);
				console.log(  svgSelectable.$helper );
			}
			function selectingDragging(){
				var event = d3.event.sourceEvent;
				var target = $("#svg");
				if( !event.ctrlKey ){
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
				console.log( d3.select("#wrapG").attr('transform') );
				
				var scale = d3.select("#wrapG").attr('transform');//.match(/scale(.+)/g)[0];
				if( scale ){
					scale = scale.match(/scale(.+)/g)[0];
					scale= scale.substring(6, scale.length-1);
				}else{
					scale=1
				}
				var newTrns = "translate(" + curTrns[0] +','+curTrns[1]+ ") scale("+scale+")";
				svgSelectable.helper
					.attr('transform',newTrns)
					.attr('width', x2 - x1 )
					.attr('height', y2 - y1 );
				svgSelectable.$helper.data('trans',curTrns);
/* 					var curMat = svgSelectable.$helper.data('matrix');
				curMat[4] = x1;
				curMat[5] = y1;
				var newMatrix = "matrix(" + curMat.join(' ') + ")";
				svgSelectable.helper
					.attr('transform',newMatrix)
					.attr('width', x2 - x1 )
					.attr('height', y2 - y1 );
				svgSelectable.$helper.data('matrix',curMat); */
				
				var selectableItem = $(target).find(".box2");
				
				for(var i = 0 ; i<selectableItem.length;i++){
					var $item 	= $( selectableItem[i] ) ,item = d3.select($item[0]);
//						var  curMat = $item.data('matrix');
					var  curTrns = $item.data('trans');
					
//						var	left 	= +curMat[4] 
//							,top 	= +curMat[5] 
					var	left 	= +curTrns[0] 
						,top 	= +curTrns[1] 
						,width 	= +item.attr('width') 
						,height = +item.attr('height') 
						,right 	= left + width 
						,bottom = top + height
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
				console.log('drag end event', d3.event );
			}
	});
});
</script>
<style type="text/css">
.selectHelper{
	stroke-width: 1;
    stroke: red;
    stroke-dasharray: 3;
    fill: none;
}
.box2.ui-selected { fill: #F39814; color: white; }
</style>
<div data-role="page" id='parkingMgrInsert'>
	<!-- second page start -->
	<form name='prkMgrInsertFrm'>
		<div class='header' data-role='header'>
			<h1>주차장정보 등록/수정</h1>
		</div>
		<div role='main' class='ui-content'>
			<svg id='svg' style='width:100%;height:300px;'>
				<g id='wrapG'></g>
			</svg>
		<div>
			<a href='#' id='cellAdd' class='btn' data-icon='plus'>Cell Add</a>
			<a href='#' id='cellDel' class='btn' data-icon='delete'>Cell Del</a>
			<a href='#' id='cellCopy' class='btn' data-icon='delete'>Cell Copy</a>
			<a href='#' id='cellTopAlign' class='btn' data-icon='refresh'>Top Align</a>
			<a href='#' id='cellBottomAlign' class='btn' data-icon='refresh'>Bottom Align</a>
			<a href='#' id='cellLeftAlign' class='btn' data-icon='refresh'>Left Align</a>
			<a href='#' id='cellRightAlign' class='btn' data-icon='refresh'>Right Align</a>
			<a href='#' id='zoomIn' class='btn' data-icon='search'>zoomIn</a>
			<a href='#' id='zoomOut' class='btn' data-icon='search'>zoomOut</a>
		</div>
		</div>
	</form>
</div>