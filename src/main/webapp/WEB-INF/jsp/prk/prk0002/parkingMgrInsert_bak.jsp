<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="<%=request.getContextPath()%>/resources/js/d3.min.js"></script>
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
		
		//http://stackoverflow.com/questions/705250/is-there-a-jquery-plugin-which-combines-draggable-and-selectable
		// 그리드 갭
		var grid_size = 10;
		var selected = $([]), offset = {top:0, left:0}; 
		var draggableOpt = {
				snap: "#drawable"
				,appendTo : "#drawable"
				, scroll : true
				, containment: "parent"
				, scope: "tasks"
				, grid : [ grid_size, grid_size ]
				,start: function(ev, ui) {
					selected = $(".ui-selected").each(function() {
							var el = $(this);
				             el.data("offset", el.offset());
				    });
			        offset = ui.offset;
			     },
			     drag: function(ev, ui) {
			    	 var dt = ui.offset.top - offset.top, dl = ui.offset.left - offset.left;
			    	 selected.not(this).each(function(){
			    		 var _t= $(this)
			    		 	, o = _t.data('offset')
			    		 	, t = o.top
			    		 	, l = o.left;
			    		 _t.offset({ top: t+dt ,left:l+dl });
			    	 });
			     }
		}
		var resizableOpt = {
			grid : grid_size * 2
		}

		$(" .box ")
			.draggable(draggableOpt)
				.resizable(resizableOpt);

		$("#drawable").selectable({
			filter: ".box"
		})	
		.on("mouseover"," .box " ,function() { $(this).addClass("move-cursor") })
		.on("mousedown"," .box " ,function() { $(this).removeClass("move-cursor").addClass("grab-cursor").addClass("opac"); })
		.on("mouseup"  ," .box " ,function() { $(this).removeClass("grab-cursor").removeClass("opac").addClass("move-cursor"); });
		
		var copyCells=$([]);
		var controlKey = false;
		$(document).on('keydown',function(e){
			controlKey = e.ctrlKey;
			
			if( e.keyCode == 67 && e.ctrlKey ){
				copyCells = $('.ui-selected');
			}else if( e.keyCode == 86 && e.ctrlKey ){
				copyCells.each(function(){
					var t = $(this);
					var top = this.offsetTop;
					var left = this.offsetLeft;
					var div = $("<div class='box'></div>")
								.css({
									width: t.width()
									,height:t.height()
									,position:'absolute'
								})
								.offset({
									top:top
									,left:left + (+t.css('width').replace('px',''))
								})
								.draggable(draggableOpt)
								.resizable(resizableOpt);
					$("#drawable").append(div);
				});
			}
		});
		
		var selectedElement = [];
		
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
		$('#svg')
		.on('mousedown',function(event){
			if( event.target != this )return;
			$(".box2.ui-selected").removeClass('ui-selected');
			
			clicked = true;
			
			svgSelectable.opos[0] = event.pageX - $(this).offset().left 
			svgSelectable.opos[1] = event.pageY - $(this).offset().top
			if( !svgSelectable.helper ){
				svgSelectable.helper = d3.select(".selectHelper");
				svgSelectable.$helper = $(".selectHelper");
			}
			
		    var mat = svgSelectable.$helper.data('matrix');
			mat[4] = svgSelectable.opos[0];
			mat[5] = svgSelectable.opos[1];
			var newMatrix = "matrix(" + mat.join(' ') + ")";
			svgSelectable.helper.attr('transform',newMatrix);
			svgSelectable.$helper.data('matrix',mat);
		})
		.on('mousemove',function(event){
			if (!clicked ) return;
			svgSelectable.$helper.show();
			
			dragging = true;
			var tmp,
			that = svgSelectable,
			x1 = svgSelectable.opos[0],
			y1 = svgSelectable.opos[1],
			x2 = event.pageX - $(this).offset().left,
			y2 = event.pageY - $(this).offset().top;
			
			if (x1 > x2) { tmp = x2; x2 = x1; x1 = tmp; }
			if (y1 > y2) { tmp = y2; y2 = y1; y1 = tmp; }
			var curMat = svgSelectable.$helper.data('matrix');
			curMat[4] = x1;
			curMat[5] = y1;
			var newMatrix = "matrix(" + curMat.join(' ') + ")";
			d3.select(".selectHelper")
				.attr('transform',newMatrix)
				.attr('width', x2 - x1 )
				.attr('height', y2 - y1 );
			svgSelectable.$helper.data('matrix',curMat);
			
			var selectableItem = $(this).find(".box2");
			
			for(var i = 0 ; i<selectableItem.length;i++){
				var $item 	= $( selectableItem[i] ) ,item = d3.select($item[0])
					,curMat = $item.data('matrix')
					,left 	= +curMat[4] 
					,top 	= +curMat[5] 
					,width 	= +item.attr('width') 
					,height = +item.attr('height') 
					,right 	= left + width 
					,bottom = top + height
					,hit = ( !( left > x2 || right < x1 || top > y2 || bottom < y1) );
				
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
		})
		.on ('mouseup',function(e){
			if( dragging && clicked ) $(".selectHelper").hide();
			dragging = clicked = false;
		})
		// boxes
		.on('mousedown','.box2',function(evt){
			if( !$(evt.target).hasClass('box2') ) return; 
			var selected = evt.target , curX = evt.clientX , curY = evt.clientY;
			boxClicked 		= true;
			boxClickedPos 	= {y:curY, x:curX}
		    
			$(selected).addClass('movingTarget');
			
			draggingTarget = $(".box2.ui-selected, .box2.movingTarget");
		})
		.on('mousemove','.box2',function(evt){
			
			if(boxClicked)boxDragging = true;
			else return;
			
			var beforeX = boxClickedPos.x	, beforeY 	= boxClickedPos.y
				,afterX = evt.clientX 		, afterY 	= evt.clientY
				,gabX 	= afterX - beforeX 	, gabY 		= afterY - beforeY;
			boxClickedPos = { x : afterX, y : afterY }
			
			var o = {};
			o.grid = [10, 10];
			var left = o.grid[0] ? beforeX + Math.round((afterX - beforeX) / o.grid[0]) * o.grid[0] : beforeX;
			var top = o.grid[1] ? beforeY + Math.round((afterY - beforeY) / o.grid[1]) * o.grid[1] : beforeY;
			
			console.log(  afterY , beforeY);
			console.log(  beforeY , Math.round((afterY - beforeY) / o.grid[1]) , o.grid[1] );
			console.log( left , top);
			console.log('-----------------');
			
			$(draggingTarget).each(function(){
				var o = $(this).data('matrix');
				o[4] += gabX;
				o[5] += gabY;
				var newMatrix = "matrix(" + o.join(' ') + ")";
				d3.select(this).attr('transform',newMatrix);
				$(this).data('matrix',o);
			});
			
		})
		.on('mouseup','.box2',function(e){
			boxClicked = boxDragging = false;
			$('.box2.movingTarget').removeClass('movingTarget');
		});
		
		$("#cellAdd").on('click',function(){
		/* 	var cell = $("<div class='box' style='top:0px;left:0px;'></div>");
			var box = $(".box:last");
			$("#drawable").append(cell);
			cell.draggable(draggableOpt).resizable(resizableOpt);
			var o = box.offset() ,l = o.left + box.width() ,t = o.top;
			cell.offset({ top:t ,left:l }); */
			
			//create rect
			var rect = d3.select('#svg').attr('width',500).attr('height',500)
					.append("rect")
					.attr('class','box2')
					.attr('width',50)
					.attr('height',80)
					.attr('x',10)
					.attr('y',10)
					.attr('transform',"matrix(1 0 0 1 0 0)");
			$(rect._groups[0][0]).data({
				matrix:[1.0,0.0,0.0,1.0,0.0,0.0]
			});
			
			// create helper
			if( $(".selectHelper").length == 0 ){
				var helper = d3.select('#svg').append('rect').attr('class','selectHelper').attr('transform',"matrix(1 0 0 1 0 0)");
				$(helper._groups[0][0]).data({
					matrix:[1.0,0.0,0.0,1.0,0.0,0.0]
				});
			}
		})
		$('#cellDel').on('click',function(){
			$(".ui-selected").remove();	
		});
		$("#cellTopAlign").on('click',function(){
			var minTop = 99999999;
			$('.ui-selected').each(function(){
				var t = $(this).offset().top;
				if( minTop >= t) minTop = t;
			}).offset({top:minTop});
		});
		$("#cellBottomAlign").on('click',function(){
			var maxBottom = 0;
			$('.ui-selected').each(function(){
				var t = $(this).offset().top;
				if( maxBottom <= t) maxBottom = t;
			}).offset({top:maxBottom});
		});
		$("#cellLeftAlign").on('click',function(){
			var minLeft=9999999;
			$('.ui-selected').each(function(){
				var l = $(this).offset().left;
				if( minLeft >= l) minLeft= l;
			}).offset({left:minLeft});
		});
		$("#cellRightAlign").on('click',function(){
			var maxRight= 0;
			$('.ui-selected').each(function(){
				var l = $(this).offset().left;
				if( maxRight <= l) maxRight= l;
			}).offset({left:maxRight});
		});
		var currentZoom = 100;
		$("#zoomIn").on('click',function(){
			currentZoom += 10 ;
			$("#drawable").animate({ 'zoom': currentZoom+'%'}, 'slow');
		});
		$("#zoomOut").on('click',function(){
			currentZoom -= 10 ;
			$("#drawable").animate({ 'zoom': currentZoom+'%'}, 'slow');
		});
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

.dragable {
	width: 50px;
	height: 80px;
	border: 3px solid;
	background: #eee;
}

#drawable .ui-selecting { background: #FECA40; }
#drawable .ui-selected { background: #F39814; color: white; }

.box2.ui-selected { fill: #F39814; color: white; }

#drawable {
	background:
		url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAGUlEQVQYV2NkIBIwEqmOYVQh3pAiNnj+AwALaAEKfsPrZgAAAABJRU5ErkJggg==);
	background-position: 18px 11px; 
	position: relative;
	zoom:100%
}

.box {
	width: 50px;
	height: 80px;
	background-color: #54cfb3;
 	position: absolute;
	border:1px solid #ddd;
}

.opac {
	opacity: .8;
}

.move-cursor {
	cursor: move;
}

.grab-cursor {
	cursor: grab;
	cursor: -webkit-grab;
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
		<svg id='svg'></svg>
		<div id='drawable' style='width: 100%; height: 800px;'>
			<div class='box' ></div>
		</div>
		
		</div>
	</form>
</div>