<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 메뉴 판넬 -->
<div id="menuPanel" data-role='panel' data-position='left' data-display='overlay' data-position-fixed="true" >
<!-- <div id='menuNavigator'></div> -->
</div>
<script>
	$(document).ready(function(){
		// 메뉴를 생성한다. 
		var url = "<c:url value='/mgr/mgr0001/menuList.do'/>"
		Common.ajaxJson( url , {useAt:'Y'},function(res){
			MENU.createMenu( res );
		},'post',false);
	});
</script>
<div role='main' class='ui-content'>