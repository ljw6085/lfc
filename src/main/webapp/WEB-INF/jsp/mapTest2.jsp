<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<%@ include file="./cmm/resources.jsp" %>
	<script src="<%=request.getContextPath() %>/resources/js/d3.min.js"></script>
	<script>
	
		var data = [];
		
		var col = 40;
		var row = 10;
		var unit_width = 30;
		var unit_height = 50;
		var width = unit_width*col;
		var height = unit_height*row;
		
		for( var i = 0 ; i < row ; i++){
			for( var k = 0 ; k < col ; k++){
				data.push({x:i,y:k});
			}
		}
		
		$(document).ready(function(){
			
			var wrap = d3.select("#tableTest");
			var svg = wrap.append("svg")
					.attr("width",width)
					.attr("height",height);
			var g = svg.append("g");
			var rects = g.selectAll( "rect" )
				.data( data )
				.enter()
				.append("rect");
			var rectAttrs = rects
								.attr("x", function(d){ return d.y * unit_width } )
								.attr("y", function(d){ return d.x * unit_height })
								.attr("width", unit_width)
								.attr("height", unit_height)
								.attr("stroke","#ddd")
								.attr("stroke-width","1")
								.attr("fill", function(d) { 
									var t = $(this);
									if ( d.x == 2 && d.y == 3 ){
										t.addClass("here");
									}else{
										t.addClass("box")
									}
									return d.x == 2 && d.y == 3 ? "red":"#eee"; 
								});
			$(".here")
			.bind("click",function(e){
				var t = $(this);
				if( t.hasClass("clicked") ){
					t.removeClass("clicked");
					$(this).attr("fill","red");
				}else{
					t.addClass("clicked");
					$(this).attr("fill","pink");
				}
			});
			
			$(".box")
			.bind("click",function(){
				var t = $(this);
				if( t.hasClass("clicked") ){
					t.removeClass("clicked");
					$(this).attr("fill","#eee");
				}else{
					t.addClass("clicked");
					$(this).attr("fill","#ddd");
				}
			});
		});
	</script>
	<style>
		table { border-collapse:collapse;border:0; }
		td { border:1px solid; padding:10px;}
	</style>
</head>
<body >
<div id='tableTest' style='width:500px;'>
</div>
</body>
</html>