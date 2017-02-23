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
		$(document).on('keydown',function(e){
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
		
		$("#cellAdd").on('click',function(){
			var cell = $("<div class='box' style='top:0px;left:0px;'></div>");
			var box = $(".box:last");
			$("#drawable").append(cell);
			cell.draggable(draggableOpt).resizable(resizableOpt);
			var o = box.offset() ,l = o.left + box.width() ,t = o.top;
			cell.offset({ top:t ,left:l });
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

	});
});
</script>
<style type="text/css">
.dragable {
	width: 50px;
	height: 80px;
	border: 3px solid;
	background: #eee;
}

#drawable .ui-selecting { background: #FECA40; }
#drawable .ui-selected { background: #F39814; color: white; }


#drawable {
	background:
		url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAGUlEQVQYV2NkIBIwEqmOYVQh3pAiNnj+AwALaAEKfsPrZgAAAABJRU5ErkJggg==);
	background-position: 18px 11px; 
	position: relative;
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
		</div>
		<div id='drawable' style='width: 100%; height: 800px;'>
			<div class='box' ></div>
		</div>
		</div>
	</form>
</div>