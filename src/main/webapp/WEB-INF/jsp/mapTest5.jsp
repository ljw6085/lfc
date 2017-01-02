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
			var g = svg.select("#wrap");
			// test --- BOX_21_ 를 NULL 박스로 생성하는 테스트기
			makeNullBox(svg.select("#BOX_21_"));
			makeNullBox(svg.select("#BOX_17_"));
			
			// svg객체에 그룹g 세팅
			/* var g = svg.append("g");
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
					}); */
			
			
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
			
			//-------------------------------------- Null box 생성하기 
			function makeNullBox( targetGroup ){
				targetGroup.select("rect").attr('class','st5');
				makeLineX( targetGroup , 'left');
				makeLineX( targetGroup , 'right');
			}
			
			function makeLineX( targetGrp , type ){
				var target = targetGrp.select("rect")
					,attr = makeLineXAttr(target, type );
				
				targetGrp.append("line")
							.attr("class",'st5')
							.attr("x1",attr.x1)
							.attr("y1",attr.y1)
							.attr("x2",attr.x2)
							.attr("y2",attr.y2);
			}
			
			function makeLineXAttr( target , type ){
				var x = +target.attr("x"),
					y = +target.attr("y"),
					w = +target.attr("width"),
					h = +target.attr("height"),
					returnObj = {};
				switch (type) {
					case 'left':
						returnObj = {
							x1 : x,
							y1 : y,
							x2 : x+w,
							y2 : y+h
						}
						break;
					case 'right':
						returnObj = {
							x1 : x+w,
							y1 : y,
							x2 : x,
							y2 : y+h
						}
						break;
				}
				return returnObj;
			}
			//-------------------------------------- Null box 생성하기 끝
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

<svg version="1.1" id="레이어_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"
	 y="0px" width="1031.811px" height="728.5px" viewBox="0 0 1031.811 728.5" style="enable-background:new 0 0 1031.811 728.5;"
	 xml:space="preserve">
<style type="text/css">
	.st0{font-family:'AdobeMyungjoStd-Medium-KSCpc-EUC-H';}
	.st1{font-size:27.1233;}
	.st2{fill:#8E8E8E;}
	.st3{fill:#8EC5EC;}
	.st4{fill:#F5BE43;}
	.st5{fill:none;stroke:#000000;stroke-miterlimit:10;}
	.st6{font-size:21;}
	.st7{font-size:16.2814;}
</style>
<g id='wrap'>
	<g id="BOX_1_">
		<rect id="box_1_" x="101.212" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_3_">
		<rect id="box_3_" x="145.732" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_2_">
		<rect id="box_2_" x="190.251" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_6_">
		<rect id="box_6_" x="279.291" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_5_">
		<rect id="box_5_" x="323.81" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_4_">
		<rect id="box_4_" x="368.33" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_11_">
		<rect id="box_11_" x="412.849" y="126.684" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_10_">
		<rect id="box_10_" x="457.369" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_9_">
		<rect id="box_9_" x="501.888" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_8_">
		<rect id="box_8_" x="546.408" y="126.684" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_12_">
		<rect id="box_12_" x="907.35" y="315.762" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_47_">
		<rect id="box_47_" x="56.693" y="196.677" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_46_">
		<rect id="box_46_" x="101.212" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_45_">
		<rect id="box_45_" x="145.732" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_44_">
		<rect id="box_44_" x="190.251" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_42_">
		<rect id="box_42_" x="279.291" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_41_">
		<rect id="box_41_" x="323.81" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_40_">
		<rect id="box_40_" x="368.33" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_39_">
		<rect id="box_39_" x="412.849" y="196.677" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_38_">
		<rect id="box_38_" x="457.369" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_37_">
		<rect id="box_37_" x="501.888" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_36_">
		<rect id="box_36_" x="546.408" y="196.677" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_35_">
		<rect id="box_35_" x="708.012" y="603.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_34_">
		<rect id="box_34_" x="752.531" y="603.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_33_">
		<rect id="box_33_" x="797.051" y="603.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_32_">
		<rect id="box_32_" x="841.57" y="603.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_31_">
		<rect id="box_31_" x="886.09" y="603.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_30_">
		<rect id="box_30_" x="930.609" y="603.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_29_">
		<rect id="box_29_" x="57.693" y="601.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_28_">
		<rect id="box_28_" x="102.212" y="601.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_27_">
		<rect id="box_27_" x="146.732" y="601.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_26_">
		<rect id="box_26_" x="191.251" y="601.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_24_">
		
			<rect id="box_24_" x="839.039" y="67.692" transform="matrix(0.8185 0.5745 -0.5745 0.8185 214.5483 -475.756)" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_70_">
		<rect id="box_70_" x="280.291" y="334.746" class="st2" width="42.519" height="68.031"/>
	</g>
	<g id="BOX_69_">
		<rect id="box_69_" x="324.81" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_68_">
		<rect id="box_68_" x="369.329" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_67_">
		<rect id="box_67_" x="413.849" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_64_">
		<rect id="box_64_" x="547.407" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_63_">
		<rect id="box_63_" x="591.927" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_62_">
		<rect id="box_62_" x="636.446" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_61_">
		<rect id="box_61_" x="680.966" y="334.746" class="st2" width="42.521" height="68.031"/>
	</g>
	<g id="BOX_60_">
		<rect id="box_60_" x="725.486" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_58_">
		<rect id="box_58_" x="280.291" y="404.777" class="st2" width="42.519" height="68.031"/>
	</g>
	<g id="BOX_57_">
		<rect id="box_57_" x="324.81" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_56_">
		<rect id="box_56_" x="369.329" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_55_">
		<rect id="box_55_" x="413.849" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_52_">
		<rect id="box_52_" x="547.407" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_51_">
		<rect id="box_51_" x="591.927" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_50_">
		<rect id="box_50_" x="636.446" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_49_">
		<rect id="box_49_" x="680.966" y="404.777" class="st2" width="42.521" height="68.031"/>
	</g>
	<g id="BOX_48_">
		<rect id="box_48_" x="725.486" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_25_">
		
			<rect id="box_25_" x="875.982" y="93.668" transform="matrix(0.8185 0.5745 -0.5745 0.8185 236.1747 -492.2648)" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_72_">
		
			<rect id="box_72_" x="912.926" y="119.668" transform="matrix(0.8185 0.5745 -0.5745 0.8185 257.8149 -508.7693)" class="st2" width="42.52" height="68.032"/>
	</g>
	<g id="BOX_73_">
		<rect id="box_73_" x="907.35" y="359.762" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_14_">
		<rect id="box_14_" x="907.35" y="404.281" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_13_">
		<rect id="box_13_" x="907.35" y="448.281" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_17_">
		<rect id="box_17_" x="56.693" y="315.258" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_16_">
		<rect id="box_16_" x="56.693" y="359.258" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_15_">
		<rect id="box_15_" x="56.693" y="403.777" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_7_">
		<rect id="box_7_" x="56.693" y="447.777" class="st2" width="68.031" height="42.52"/>
	</g>
	<g id="BOX_19_">
		<rect id="box_19_" x="235.771" y="334.746" class="st2" width="42.519" height="68.031"/>
	</g>
	<g id="BOX_18_">
		<rect id="box_18_" x="235.771" y="404.777" class="st2" width="42.519" height="68.031"/>
	</g>
	<g id="BOX_21_">
		<rect id="box_21_" x="770.006" y="334.746" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_20_">
		<rect id="box_20_" x="770.006" y="404.777" class="st2" width="42.52" height="68.031"/>
	</g>
	<g id="BOX_22_">
		<rect id="box_22_" x="460.368" y="334.747" class="st4" width="82.632" height="138.062"/>
		<text transform="matrix(0.9412 0 0 1 481 414.8301)" class="st0 st1">E/V</text>
	</g>
	<g id="BOX_23_">
		<rect id="box_23_" x="56.693" y="511.777" class="st3" width="42.52" height="68.031"/>
		<text transform="matrix(1 0 0 1 67.3589 552.4199)" class="st0 st7">IN</text>
	</g>
	<g>
		<rect id="box_43_" x="668.211" y="56.652" class="st3" width="68.031" height="39.348"/>
		<text transform="matrix(1 0 0 1 687 83.2939)" class="st0 st6">out</text>
	</g>
	<g>
		<rect x="56.693" y="126.684" class="st5" width="42.52" height="68.031"/>
		<line class="st5" x1="99.212" y1="126.684" x2="56.693" y2="196.677"/>
		<line class="st5" x1="56.693" y1="126.684" x2="99.212" y2="194.715"/>
	</g>
</g>
</svg>
</body>
</html>