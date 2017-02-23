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

			         if( !$(this).hasClass("ui-selected")) $(this).addClass("ui-selected");
			         offset = $(this).offset();
			     },
			     drag: function(ev, ui) {
			         var dt = ui.position.top - offset.top, dl = ui.position.left - offset.left;

			         // take all the elements that are selected expect $("this"), which is the element being dragged and loop through each.
			         selected.not(this).each(function() {
			              // create the variable for we don't need to keep calling $("this")
			              // el = current element we are on
			              // off = what position was this element at when it was selected, before drag
			              var el = $(this), off = el.data("offset");
			              el.css({top: off.top + dt, left: off.left + dl});
			         });
			     }
		}
		var resizableOpt = {
			grid : grid_size * 2
		}
		$(" .box ").draggable(draggableOpt).resizable(resizableOpt);
		
		$('#drawable').on("mouseover"," .box ", function() {
			$(this).addClass("move-cursor")
		}).on("mousedown"," .box ",function() {
			$(this).removeClass("move-cursor").addClass("grab-cursor").addClass("opac");
		})
		.on("mouseup"," .box ",function() {
			$(this).removeClass("grab-cursor").removeClass("opac").addClass("move-cursor");
		});
		
		$("#cellAdd").on('click',function(){
			var cell = $("<div class='box'></div>");
			cell.draggable(draggableOpt).resizable(resizableOpt);
			$(".box:last").before(cell);
		});
		
		
		$("#drawable").selectable({
			filter: ".box"
		});
		/* var dragableOption = {
				snap: "#drawable"
				, grid: [ 56, 86 ]
				, snapMode:'outer'
				, scope: "tasks"
				, containment: "parent"
		}
		$(".dragable").draggable( dragableOption );
		
		$("#cellAdd").on('click',function(){
			var cell = $("<div class='dragable'></div>");
			cell.draggable(dragableOption);
			$("#drawable").prepend(cell);
			var rect = d3.select("#drawable")
				.append('svg')
				.append('rect')
				.attr('class','dragable')
				.attr("x",0)
				.attr("y",0)
				.attr('width','56')
				.attr('height','86')
				.attr('fill','hotpink');
			console.log($(rect._groups[0]).draggable(dragableOption) );
		}); */
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
/* 	background-position: 18px 11px; */
	background-position: 36px 22px;
}

.box {
	width: 50px;
	height: 80px;
	background-color: #54cfb3;
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
			</div>
			<div id='drawArea'
				style='width: 100%; height: 500px; overflow: auto;'>
				<div id='drawable' style='width: 100%; height: 800px;'>
					<div class='box'></div>
				</div>
			</div>
		</div>
	</form>
</div>