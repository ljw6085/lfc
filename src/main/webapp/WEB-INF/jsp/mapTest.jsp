<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<%@ include file="./cmm/resources.jsp" %>
	<script>
		$(document).ready(function(){
			var $tble = $("<table></table>");//.css("width","1500px");
			$("#tableTest").append( $tble );
				for( var i = 0 ; i < 50; i++){
					var $tr = $("<tr></tr>");
					$tble.append( $tr );
					for( var k = 0; k < 50; k++){
						var $td = $("<td></td>");
						if( k ==0 ){
							$td.text( i );
						}else{
							$td.text( "test_"+i+"_"+k);
						}
						$tr.append( $td );
					}
				}
		});
	</script>
	<style>
		table { border-collapse:collapse;border:0; }
		td { border:1px solid; padding:10px;}
	</style>
</head>
<body >
<div id='tableTest' style='overflow-x:scroll;overflow-y:hidden;'>
</div>
</body>
</html>