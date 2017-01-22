<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 화면상단 include ( 메뉴포함 ) -->
<%@ include file="/WEB-INF/jsp/cmm/inc/top.jsp" %>
<script>
	
	$(document).ready(function(){
			$m.setButton($('.btn'),{
				mini:true
				,inline:true
			});
			$m.setButton($('#searchBtn'),{
				mini:true
				,notext:true
			});
			$m.setControlGroup($("#buttonBox"),true);	

			var grid = $m.setTable($(".gridWrap"),{
				toggle:true,
				header:[
					{ colId:'no', colName:'No', priority:'2'  },
					{ colId:'groupCode', colName:'그룹코드', priority:'1'} ,
					{ colId:'divCode', colName:'분류코드', priority:'' },
					{ colId:'divCodeNm', colName:'코드명', priority:''},
					{ colId:'useAt', colName:'사용여부', priority:'3'  }
				],
				data : [
						{no:'1',groupCode:'GRP0001',divCode:'SYS_DIV_CD',divCodeNm:'시스템구분',useAt:'Y'}
						,{no:'2',groupCode:'GRP0001',divCode:'USE_AT',divCodeNm:'사용여부',useAt:'Y'}
						,{no:'3',groupCode:'GRP0002',divCode:'MN_KIND_CD',divCodeNm:'메뉴종류코드',useAt:'Y'}
						,{no:'4',groupCode:'GRP0002',divCode:'BRD_DIV_CD',divCodeNm:'게시판구분',useAt:'Y'}
						,{no:'5',groupCode:'GRP0003',divCode:'CAR_DIV_CD',divCodeNm:'차량구분코드',useAt:'Y'}
				],
				create:function(event, ui){
					console.log ( ui );
				}
			});
		
			console.log( grid );								

		
// 		$('div').on('test',{
// 			test1 : function(t){
// 				console.log( $(t.target).width() )
// 			}
// 		},function(e,val,val2){
// 			console.log( e.target, e.data.test1(e) , val,val2);
// 		});
		
		$(window).resize(function(e){
// 			$("div").trigger('test',['aa','aaaaaa']);
		});
	});
</script>
<style>
	.buttonBox { padding: 0 .5em; text-align: right;}
	#searchBox .ui-block-a { width: 19.5%}
	#searchBox .ui-block-b { width: 69.5%}
	#searchBox .ui-block-c { width: 9.5%}
	
	.gridWrap table{ border-collapse: collapse; border-spacing: 0px; }
	.gridWrap thead th { 
/* 		text-align: center; */
/* 		background-color: #e9e9e9 ; */
		font-size:0.8em;
		color: 	#333 ;
		text-shadow: 0 0 0 	#eee; 
		font-weight: bold;	
	}
	
	@media (max-width: 40em) {
		.gridWrap tbody th { margin-top:.5em; padding-top:.3em;padding-bottom:.3em;font-size:.8em;}
/* 		.gridWrap tbody tr { border-bottom: 3px solid #ddd;} */
		.gridWrap tbody td { padding-top:.3em;;padding-bottom:.3em; font-size: .8em;}
		.ui-table-cell-label { border-right: 1px solid #ddd; padding:0 !important; text-align: center;}
	}
}
</style>
<!-- form 단위로 이루어진 content -->
<form name='frm'>
	<!-- 실제 구성될 화면페이지  영역 -->
	<div class='main_content'>
	<div id='searchBox' class='ui-grid-a'>
		<div class='ui-block-a'>
			
		</div>
		<div class='ui-block-b'>
			<input type='search' id='srch' data-mini='true' placeholder="Search..">
		</div>
		<div class='ui-block-c' style='text-align: center;'>
			<a href='#' id='searchBtn' data-icon='search'></a>
		</div>
	</div>
	<div id='buttonBox' style='text-align: right;'>
		<a href='#' id='insertCode' class='btn' data-icon='plus'> 코드등록</a>
	</div>
	<div class='gridWrap' >
		<!-- <table id='codeList' >
	      <thead>
	        <tr>
	          <th data-priority="3">No</th>
	          <th data-priority="1">그룹코드</th>
	          <th >분류코드</th>
	          <th >코드명</th>
	          <th data-priority="2">사용여부</th>
	        </tr>
	      </thead>
	      <tbody>
	        <tr>
	          <th>1</th>
	          <td class='title'>GRP0001</td>
	          <td>CM0001</td>
	          <td>사용여부</td>
	          <td class='useYn'>Y</td>
	        </tr>
	        <tr>
	          <th>2</th>
	          <td class='title'>GRP0002</td>
	          <td>CM0002</td>
	          <td>메뉴구분</td>
	          <td class='useYn'>Y</td>
	        </tr>
	        <tr>
	          <th>3</th>
	          <td class='title'>GRP0002</td>
	          <td>CM0002</td>
	          <td>메뉴구분</td>
	          <td class='useYn'>Y</td>
	        </tr>
	        <tr>
	          <th>4</th>
	          <td class='title'>GRP0002</td>
	          <td>CM0002</td>
	          <td>메뉴구분</td>
	          <td class='useYn'>Y</td>
	        </tr>
	        <tr>
	          <th>5</th>
	          <td class='title'>GRP0002</td>
	          <td>CM0002</td>
	          <td>메뉴구분</td>
	          <td class='useYn'>Y</td>
	        </tr>
	      </tbody>
	    </table>
	       -->
	</div>
	<div id='test' style='width:100%;'>
		aaa
	</div>
	</div>
	<!--// main_content  -->
</form>
<!-- 화면 하단 include  -->
<%@ include file="/WEB-INF/jsp/cmm/inc/bottom.jsp" %>