<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
	/* 메뉴관련 스타일 지정 - 추후에 css로 뺀다  */
	#menuPanel {
		background: #fff;
	}
	li {
		padding : 0 !important;
	}
	ul.depth0 a{
		padding-left: 3 em !important;
		font-size: 0.8em !important;
	}
	ul.depth1 a{
		padding-left: 5 em !important;
		font-size: 0.7em !important;
	}
	a.topMenu {
		background: #eee !important;
	}
</style>	
<!-- 메뉴 판넬 -->
<div id="menuPanel"></div>
<script>
	$( function() {
		// 메뉴 데이터 DB에서 가져왔다고 가정
		var temp_menu_data = [
			{ parent:null, id:"M0000", url:"/index.do", menuNm:"MAIN" },
			{ parent:null, id:"M0001", url:"", menuNm:"정보조회" },
			{ parent:null, id:"M0002", url:"", menuNm:"정보관리" },
			{ parent:null, id:"M0003", url:"", menuNm:"게시판"},
			{ parent:null, id:"M0004", url:"", menuNm:"운영관리"},
			{ parent:"M0001", id:"M0011", url:"", menuNm:"차량조회"},
			{ parent:"M0001", id:"M0012", url:"", menuNm:"주차조회"},
			{ parent:"M0002", id:"M0021", url:"", menuNm:"차량정보관리"},
			{ parent:"M0002", id:"M0022", url:"", menuNm:"주차정보관리"},
			{ parent:"M0003", id:"M0031", url:"", menuNm:"공지사항"},
			{ parent:"M0003", id:"M0032", url:"", menuNm:"문의사항"},
			{ parent:"M0004", id:"M0041", url:"", menuNm:"사용자관리"},
			{ parent:"M0004", id:"M0042", url:"", menuNm:"메뉴관리"},
			{ parent:"M0004", id:"M0043", url:"", menuNm:"코드관리"},
			{ parent:"M0043", id:"M0431", url:"/mgr/cdm/codeList.do", menuNm:"공통코드관리"},
			{ parent:"M0043", id:"M0432", url:"", menuNm:"차량코드관리"}
		];
		// 메뉴를 생성한다. 추후에는 ajax로 데이터 로드 후, 콜백함수에서 아래 함수 호출. - common.js
		MENU.createMenu( temp_menu_data );

	});
</script>