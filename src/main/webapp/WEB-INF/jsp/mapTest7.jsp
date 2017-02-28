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
	
	
// 		var svgFileUrl = "http://localhost:8080/lfc/resources/svg/top1f.svg";
		var svgFileUrl = "http://localhost:8080/lfc/resources/svg/b2f.svg";
		var areaCode = "P0001";
// 		var floorCode = "T1F";
		var floorCode = "B2F";
		
		var targetId = "box15_32";
		
		var ZOOM_MIN = 0.2 ,ZOOM_MAX = 5;
		var g;
		var zoom = d3.zoom()
					.scaleExtent([ZOOM_MIN, ZOOM_MAX])	// x0.2 ~ x2  ZOOM 범위 설정 
					.on("zoom", function(){
						//zoom 이벤트 콜백함수
					  	g.attr("transform", d3.event.transform );
					}); 	// zoom 이벤트 바인드
					
					
		$(window).resize(function(){
			var $svg = $("svg");
			$svg.css('height', ($svg.width()/1.6));
		});
		
		var svg;
		$(document).ready(function(){
			var $svg = $("svg").css('width','100%');
			$(window).trigger('resize');

			// *******************************  전역변수 세팅
			// 박스 타입 설정 추후에DB로 관리
			var blockType = {
					DEFAULT	: '0',
					OWN 	: '1',
					OTHERS 	: '2',
					ELV 	: '3',
					ETC 	: '4',
					TARGET	: '9'
			}
			
			d3.request(svgFileUrl)
		    .mimeType("application/xml")
		    .response(function(xhr) { return xhr.responseXML; })
		    .get(function( xml ){
		    		var yGroupByObj = {}
		    		svg = d3.select( xml )
		    		,rects = svg.selectAll( 'rect ');
			    	
			     $("#svgWrap").append( xml.documentElement );
		    	
				var svg = d3.select("#wrap_svg").attr('width','100%');
				$(window).trigger('resize');
				
				g = svg.select("#wrap_g").attr('transform','translate(0,0) scale(1)'); // 실질적으로 zoom 될 객체인 g 에  객체할당
				svg.call( zoom ); // svg객체에 대해 zoom 설정
				
				// test --- BOX_21_ 를 NULL 박스로 생성하는 테스트기
				new Minimap( svg, g ).render();
				loadData( areaCode,floorCode );
// 				makeNullBox(d3.select( "#box1_33" ));
				
		    });
			
			var svgUtils = {
				getTranslate:function( transform ){
					var trns= [0.0,0.0,1];
					if( /translate\(\s*0\s*\)/g.test(transform)){
						var tmp=[0,0];
						trns = transform.match(/[-]?[0-9.]+/g);
						if( typeof trns[1] != 'undefined') {
							tmp.push( trns[1] );
						}
						trns = tmp;
					}else if( transform ) {
						trns = transform.match(/[-]?[0-9.]+/g);
					}
					trns[0] = +trns[0]; 
					trns[1] = +trns[1];
					trns[2] = +trns[2];
					return trns;
				}
			}
			
			
			function Minimap( svg , target ){
				
				var t = this;
				t.svg 	= svg;
				t.target 	= target;
				
				t.minimapScale    = 0.15;
				t.scale           = 1;
				t.width           = 500; // view 의 rect 과 크기가 같아야함 ( 아니면 svg wrap 크기)
				t.height          = 500; // view 의 rect 과 크기가 같아야함(아니면 svg wrap 크기)
				t.x               = 0;
				t.y               = 0;
				t.frameX          = 0;
				t.frameY          = 0;
				
				
				var content = t.target.node().cloneNode(true);
				t.container = t.svg.append('g').attr("class", "minimap")
//											.call(parkingManager.zoom);
				
				zoom.on("zoom.minimap", function() {
					t.scale = d3.event.transform.k;
			    });
				
				t.container.node().appendChild( content );
				
				t.frame = t.container
								.append("g")
								.attr("class", "frame")
						
				t.frame.append("rect")
				    .attr("class", "background")
				    .attr("width", t.width)
				    .attr("height", t.height)
//				    .attr("filter", "url(#minimapDropShadow_qwpyza)");
				
				t.drag = d3.drag()
			        .on("start.minimap", function() {
			            var frameTranslate = svgUtils.getTranslate( t.frame.attr("transform") );
			            t.frameX = frameTranslate[0];
			            t.frameY = frameTranslate[1];
			        })
			        .on("drag.minimap", function() {
			            d3.event.sourceEvent.stopImmediatePropagation();
			            t.frameX += d3.event.dx;
			            t.frameY += d3.event.dy;
			            t.frame.attr("transform", "translate(" + t.frameX + "," + t.frameY + ")");
			            var translate =  [(-t.frameX*t.scale),(-t.frameY*t.scale)];
			            t.target.attr("transform", "translate(" + translate + ")scale(" + t.scale + ")");
			            var z = d3.zoomIdentity.translate(translate[0], translate[1]).scale(t.scale);
			            t.svg.call(zoom.transform , z );
			        });

				t.frame.call(t.drag);
				return this;
			}
			Minimap.prototype.render = function( isInit ){
				var t = this;
				var targetTransform = svgUtils.getTranslate( t.target.attr("transform"));
				console.log( targetTransform );
				t.scale = targetTransform[2];
				t.container.attr("transform", "translate(" + t.x + "," + t.y + ")scale(" + t.minimapScale + ")");
//			    if ( isInit ){
				    var node = t.target.node().cloneNode(true);
				    t.container.select('#wrap_g').remove();
				    t.container.node().appendChild( node );
				    t.container.select('#wrap_g').attr("transform", "translate(1,1)");
//			    }
			
			console.log( t.width ,t.height, t.scale );
			    t.frame.attr("transform", "translate(" + (-targetTransform[0]/t.scale) + "," + (-targetTransform[1]/t.scale) + ")")
			        .select(".background")
			        .attr("width", t.width / t.scale)
			        .attr("height", t.width / t.scale);
			    
			    t.frame.node().parentNode.appendChild( t.frame.node());
			    d3.select(node).attr("transform", "translate(1,1)");
			    return t;
			}
			Minimap.prototype.setScale = function(value) {
			    if (!arguments.length) { return this.scale; }
			    this.scale = value;
			    return this;
			};			
			
			
			
			
			
			
			
			
			
			
			
			
			function loadData( areaCode, floorCode ){
				var url = "/lfc/prk/selectPrkData.do";
				var data = {
						prkplceCode : areaCode,
						prkplceFlrCode : floorCode
				}
				
				Common.ajax( url, data , function(res){
					var result = res.result;
					for ( var i =0, len = result.length; i < len ;i ++){
						var target = result[i]; 
						if( target.cellMapngId == targetId )  target.cellType = blockType.TARGET;
						switch (target.cellType) {
						case blockType.DEFAULT:
							d3.select("#"+target.cellMapngId).attr('class',"default");
							break;
						case blockType.OTHERS:
							d3.select("#"+target.cellMapngId).attr('class',"others");
							makeNullBox(d3.select( "#" + target.cellMapngId ));
							break;
						case blockType.OWN:
							d3.select("#"+target.cellMapngId).attr('class',"own");
							break;
						case blockType.TARGET:
							d3.select("#"+target.cellMapngId).attr('class',"target");
							break;
						case blockType.ETC:
							d3.select("#"+target.cellMapngId).attr('class',"etc");
							break;
						case blockType.ELV:
							d3.select("#"+target.cellMapngId).attr('class',"elv");
							break;
						default:
							break;
						} 
					}
				},false);
			}
			
			
			
			//-------------------------------------- Null box 생성하기 
			function makeNullBox( targetGroup ){
				targetGroup.attr('class','nullBox');
				makeLineX( targetGroup , 'left');
				makeLineX( targetGroup , 'right');
			}
			
			function makeLineX( targetGrp , type ){
				var target = targetGrp //.select("rect")
					,attr = makeLineXAttr(target, type );
				targetGrp.select(function(){
					return this.parentNode;
				}).append("line")
							.attr("class",'nullLine')
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
		.default{fill:#8E8E8E;}
		.others{fill:#505050;}
		.elv{fill:#F49F3A;}
		.target{fill:green;}
		.own{fill:#cddc39;}
		.nullBox{
			fill:none !important;
			stroke-width:1;
			stroke:black;
		}
		.nullLine {
			stroke-dasharray:3;
			stroke-width:1;
			stroke:black;
		}
	</style>
</head>
<body>
<div id="svgWrap"></div>
</body>
</html>