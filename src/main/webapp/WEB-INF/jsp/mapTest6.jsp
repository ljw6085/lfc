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
		/**
			[1]단계
			svg 파일을 불러와 rect마다 매핑 ID를 부여하는 작업.
			현재는 ID 부여 후, 엘리먼트를 append하고
			직접 소스를 복사하고, svg파일에 직접 오버라이트한다.
		*/
// 		var svgFileUrl = "http://localhost:8080/lfc/resources/svg/top1f.svg";
		var svgFileUrl = "http://localhost:8080/lfc/resources/svg/b2f.svg";

		/*
		 	현재 load된 svg 파일 정보라고 가정 - 추후에 DB에서 읽어옴
		*/
		var parkingArea = {
				prkplceCode : "P0001"
				, prkplceNm :"테스트주차장"
// 				, prkplceFlrCode:"T1F"
				, prkplceFlrCode:"B2F"
// 				, prkplceFlrNm:"옥탑1층"
				, prkplceFlrNm:"지하2층"
				, drwPath:svgFileUrl
		}
		
		var boxArray = [];
		
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
		
		$(document).ready(function(){
			d3.request(svgFileUrl)
		    .mimeType("application/xml")
		    .response(function(xhr) { return xhr.responseXML; })
		    .get(function( xml ){
		    		var yGroupByObj = {}
		    		svg = d3.select( xml )
		    		,rects = svg.selectAll( 'rect ');
			    	
		    		/* rects.each(function(){
			    		//[1] y - row 정렬
			    		var y = this.getAttribute('y')
			    			, yGroup = yGroupByObj[y];
			    		if( typeof yGroup == 'undefined' ) yGroup = yGroupByObj[y] = [];
			    		yGroup.push( this );
			    	});
			    	
			    	var yValues = dataLib.keys( yGroupByObj );
			    	var sorting = dataLib.sorting( yValues , { 
			   		  sorttype : 'number'
			   		});
			    	
			    	// [2]  x - col 정렬
			    	for( var i = 0 ,len = sorting.length ; i < len; i++){
			    		var key = sorting[i]
			    			,rows = yGroupByObj[key]
			    			,xValues = {};
				    	
			    		for( var j = 0 , jLen = rows.length; j<jLen;j++){
				    		xValues [ rows[j].getAttribute('x') ]  = rows[j];
				    	}
			    		
			    		var _xValues = dataLib.keys( xValues );
				    	var xSorting = dataLib.sorting( _xValues , { 
				   		  sorttype : 'number'
				   		});
				    	for( var k = 0, kLen = xSorting.length; k<kLen;k++){
				    		xValues[xSorting[k]].setAttribute("id","box"+i+"_"+k);
				    	}
			    	} */
			    	
			     $("#svgWrap").append( xml.documentElement );
		    	
				var svg = d3.select("#wrap_svg").attr('width','100%');
				$(window).trigger('resize');
				
				g = svg.select("#wrap_g"); // 실질적으로 zoom 될 객체인 g 에  객체할당
				svg.call( zoom ); // svg객체에 대해 zoom 설정
		    });
			
			
			
			$("#makeJson").bind("click",function(){
				boxArray = [];
				g.selectAll("rect")
					.each(function(o, i){
						var type = 2;
						if ( i % 10 == 0 )type = 1;
						var t = $(this)
						,	o = {
								 x : t.attr("x")
								,y : t.attr('y')
								,width:t.attr('width')
								,height: t.attr('height')
								,cellMapngId: t.attr('id')
								,styleCls: t.attr('class')
								,cellType:getTypeByClass( t.attr('class') )
							}
						
						$.extend( o , parkingArea );
						
						boxArray.push( o );
					});
			});
			
			$("#sendJson").bind("click",function(){
				var url = "/lfc/prk/insertPrkData.do"
					, data = boxArray;
				console.log( data );
				Common.ajax(url, data, function(res){
					console.log( res );
				});
				
			});
			
		});
		var classMappingType = {
				"default":'0',
				"own" : "1",
				"others" : "2",
				"elv" : "3",
				"etc" : "4",
				"target" : "9",
		}
		function getTypeByClass( className ){
			return classMappingType[ className ]
		}
	</script>
	<style type="text/css">
	</style>
</head>
<body>
<div>
	<div class="ui-grid-a" 	style='padding-left:10px;padding-right:10px;'>
		<div class="ui-block-a">
			<input type='button' id='makeJson' value='현재상태 JSON으로 생성'/>
		</div>
		<div class="ui-block-b">
			<input type='button' id='sendJson' value='생성된 JSON DB로 전송'/>
		</div>
	</div>
	<div id="svgWrap"></div>
</div>
</body>
</html>