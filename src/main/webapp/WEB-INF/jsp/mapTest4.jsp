<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<%@ include file="./cmm/resources.jsp" %>
	<script src="<%=request.getContextPath() %>/resources/js/d3.min.js"></script>
	<script>
		$(window).resize(function(){
			var $svg = $("svg");
			$svg.css('height', ($svg.width()/1.6));
		});
		$(document).ready(function(){
			var $svg = $("svg").css('width','100%');
			$(window).trigger('resize');

			// *******************************  전역변수 세팅
			// 박스 타입 설정 추후에DB로 관리
			var blockType = {
					ROAD 	: 0,
					OWN 	: 1,
					OTHERS 	: 2,
					DOOR 	: 3,
					ELV 	: 4,
					TARGET	: 9
			}
			//zoom cursor
			var curZoom = 1;
			//target 좌표 세팅
			var TARGET_X=0
				,TARGET_Y=0;
			
			var ZOOM_MIN = 0.2
				,ZOOM_MAX = 5;
			
			// 임의로 test data 세팅
			// 데이터 배열변수 - 추후에 DB에서 로드
			var data = [];
			var col 		  = 30
				, row 		  = 10
				, unit_width  = 30 // 한칸 너비
				, unit_height = 48// 한칸 높이

			// 테스트데이터 생성
			for( var i = 0 ; i < row ; i++){
				for( var k = 0 ; k < col ; k++){
					var df = blockType.OTHERS;
					var y = Math.round( Math.random() * 30);
					if( i%3 == 0 ) {
						df = blockType.ROAD;
					}
					else if( i == 8 && k == 12) {
						df = blockType.TARGET;
					}
					else if( y == k ) {
						df = blockType.OWN;
					}
					data.push({x:i , y:k , type : df });
				}
			}

			//-------------------------------
			// svg객체 세팅 및 너비 높이 세팅
			var svg = d3.select("svg");
			// svg객체에 그룹g 세팅
			var g = svg.append("g");
				// 세팅된 g 객체에 `data` 개수만큼 반복하면서 `rect` 생성 
				g.selectAll("rect")
				    .data(data)
				  	.enter()
				  	.append("rect")
				  	.attr("data-xy",function(d){ // 나중에 찾아갈 수 있도록 svg객체에 좌표정보 세팅 
				  		return d.x+","+d.y;
				  	})
				    .attr("x", function(d){ return d.y * (unit_width+2) } ) // 박스 좌표 x + 간격조정
					.attr("y", function(d){ return d.x * (unit_height+2)})  // 박스 좌표 y + 간격조정 
				    .attr("width", unit_width)	// 박스 너비
					.attr("height", unit_height)// 박스 높이
					.attr("stroke","none")		// border제거
					.attr("fill", function(d) { // 데이터의 상태에따라 색상변경 
						var color = "";
						switch (d.type) {
							case blockType.ROAD 	:
								color = "none";
								break;
							case blockType.OWN :
								color = "#fdc13a";
								break;
							case blockType.OTHERS :
								color = "#eee";
								break;
								
							case blockType.DOOR 	:
								color = "#00bcd4";
								break;
								
							case blockType.ELV 	:
								color = "#cddc39";
								break;
								
							case blockType.TARGET	:
								color = "#e91e63";
								$(this).addClass("targetRect");
								TARGET_X = $(this).attr("x"); 
								TARGET_Y = $(this).attr("y");
								break;
								
							default:
								color = "#eee";
								break;
						}
						return color; 
					});
			
			
			d3.select(".targetRect")
				.style("cursor","pointer");
			var zoom = d3.zoom()
						.scaleExtent([ZOOM_MIN, ZOOM_MAX])	// x0.2 ~ x2  ZOOM 범위 설정 
						.on("zoom", zoomed); 	// zoom 이벤트 바인드

			svg.call( zoom ); // svg객체에 대해 zoom 설정
			
			//zoom focused
			$("#zoomReset").bind("click"	, 	reset ); 
			// zoom scale up
			$("#zoomIn").bind("click" 	,	moveZoom);
			// zoom scale down
			$("#zoomOut").bind("click"	,	moveZoom);
				
			function zoomed() {
				//zoom 이벤트 콜백함수
			  	g.attr("transform", d3.event.transform );
			}
			
			function moveZoom( e ){
				var target = e.target;
				var val = target.id;
				
				switch (val) {
					case 'zoomIn':
						curZoom += 0.15;
						if( curZoom > ZOOM_MAX ) curZoom = ZOOM_MAX;
						break;
					case 'zoomOut':
						curZoom -= 0.15;
						if( curZoom < ZOOM_MIN ) curZoom = ZOOM_MIN;
						break;
				}
				//.attr('transform', 'translate(' + d3.event.transform.x + ',' + d3.event.transform.y + ') scale(' + d3.event.transform.k + ')');
				svg.transition()
		    		.duration(250).call( zoom.transform,  d3.zoomIdentity.scale(curZoom) );

			}
			function reset() {
				// target으로 이동
				var centerX = $("svg").width()  / 2;
				var centerY = $("svg").height() / 2;
				var resetZoom = d3.zoomIdentity
								.translate( centerX - TARGET_X , centerY - TARGET_Y )
								.scale(1);
				curZoom = 1;
				svg.transition()
			    	.duration(500)
			    	.call( zoom.transform, resetZoom );
			}
		});
	</script>
	<style type="text/css">
	</style>
</head>
<body>
<div id='info' style='background: #fff;opacity: 0.5;width:100%;height:100%;display: none; position: absolute; left:0;top:0;z-index:999'>
	차량정보
	<a href='#' id='close' class='ui-btn'>닫기</a>
</div>
	<a href='/lfc/home.do' id='close' class='ui-btn'>닫기</a>
	<input type='button' id='zoomIn' value='+'/>
	<input type='button' id='zoomOut' value='-'/>
	<input type='button' id='zoomReset' value='Focus'/>
<!-- 	<svg width="900" height="500"></svg> -->
	<svg></svg>
</body>
</html>