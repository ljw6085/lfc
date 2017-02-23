<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="<%=request.getContextPath() %>/resources/js/d3.min.js"></script>
<script>
/** 
	화면이동이 필요할때, jsp를 따로 관리하고자 하면
	$j.documents 에 초기화 함수를 push 해야한다. 
*/
$j.documents.push(function(){
/** Form 단위로 스크립팅 한다. */
$j.documentReady('prkManagerFrm', function($form,$uiPage){
		var frm = $form[0];
		MENU.createHeaderBackButton( $form.find('.header') );
		var backBtn = $form.find('.header').find('a');
		var initParams;
		$j.pageMoveCallback(function(params){
			initParams = params;
			console.log( initParams );
		});

// 		var svgFileUrl = "http://localhost:8080/lfc/resources/svg/top1f.svg";
		var svgFileUrl = "<c:url value='/resources/svg/b2f.svg'/>";//"http://localhost:8080/lfc/resources/svg/b2f.svg";
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
// 			$svg.css('height', ($svg.width()/1.6));
			$svg.css('height', '400px');
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
				
				g = svg.select("#wrap_g"); // 실질적으로 zoom 될 객체인 g 에  객체할당
				svg.call( zoom ); // svg객체에 대해 zoom 설정
				
				// test --- BOX_21_ 를 NULL 박스로 생성하는 테스트기
				
				loadData( areaCode,floorCode );
// 				makeNullBox(d3.select( "#box1_33" ));
				
		    });
			
			function loadData( areaCode, floorCode ){
				var url = "/lfc/prk/selectPrkData.do";
				var data = {
						prkplceCode : areaCode,
						prkplceFlrCode : floorCode
				}
				
				Common.ajaxJson( url, data , function(res){
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
				},'get',false);
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
		
		
		
});
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
<div data-role="page" id='parkingManager'><!-- second page start -->
	<form name='prkManagerFrm'>
		<div class='header' data-role='header'><h1>주차장정보 등록/수정</h1></div>
		<div role='main' class='ui-content' >
		<div id="svgWrap"></div>
		</div>
	</form>
</div>