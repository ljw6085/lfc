<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 메뉴 판넬 -->
<div id="menuPanel" data-role='panel' data-position='left' data-display='push' data-position-fixed="true" >
<!-- <div id='menuNavigator'></div> -->
</div>
<script>
	$(document).ready(function(){
		// 메뉴 데이터 DB에서 가져왔다고 가정
		var temp_menu_data = [
			{ parent:null, id:"M0000", url:"/index.do", menuNm:"MAIN" ,icon:'home',sort:1 },
			{ parent:null, id:"M0001", url:"", menuNm:"정보조회", sort:2 },
			{ parent:null, id:"M0002", url:"", menuNm:"정보관리" ,sort:3 },
			{ parent:null, id:"M0003", url:"", menuNm:"게시판" ,sort:4 },
			{ parent:null, id:"M0004", url:"", menuNm:"운영관리", sort:5 },
			{ parent:"M0001", id:"M0011", url:"", menuNm:"차량조회"},
			{ parent:"M0001", id:"M0012", url:"", menuNm:"주차조회"},
			{ parent:"M0002", id:"M0021", url:"", menuNm:"차량정보관리"},
			{ parent:"M0002", id:"M0022", url:"", menuNm:"주차정보관리"},
			{ parent:"M0003", id:"M0031", url:"", menuNm:"공지사항"},
			{ parent:"M0003", id:"M0032", url:"", menuNm:"문의사항"},
			{ parent:"M0004", id:"M0041", url:"", menuNm:"사용자관리"},
			{ parent:"M0004", id:"M0042", url:"/mgr/mgr0001/menuList.do", menuNm:"메뉴관리"},
			{ parent:"M0004", id:"M0043", url:"", menuNm:"코드관리"},
			{ parent:"M0043", id:"M0431", url:"/mgr/mgr0002/codeList.do", menuNm:"공통코드관리" , icon :'carat-r'},
			{ parent:"M0043", id:"M0432", url:"", menuNm:"차량코드관리"}
		];
		// 메뉴를 생성한다. 추후에는 ajax로 데이터 로드 후, 콜백함수에서 아래 함수 호출. - common.js
		MENU.createMenu( temp_menu_data );
	});
</script>
<div role='main' class='ui-content'>