<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ include file="/jsp/co/commonHEAD.jsp"%>
<script language="javascript">
//Util 객체
	var utils = {
		_matchedRegExp : /%{[^}]+}/g
		,_replaceRegExp:/[%{}]/g
		/**
		* _matchedRexExp ( %{}... ) 형식에 맞는 문자열을 치환시킨다.
		*/
		,matchedReplace:function(str, data){
			var t = this , matched = str.match(t._matchedRegExp);
			for(var i = 0 ,len=matched.length;i<len;i++){
				var key = matched[i].replace(t._replaceRegExp,'') 
					, replaceVal = data[key];
				if( typeof replaceVal == 'undefined' || null == replaceVal ) replaceVal = '';
				str = str.replace(matched[i],replaceVal);
			}
			return str;
		}
	}
	function vgrid(){
		var v = this;
		v.col = [];
		v.col = [];
		v.data = [];
		v.dWrap = null;
		v.dGrid = null;
		v.dScroll = null;
		v.row = "";
		v.rows=null;
		v.range=0;
		v.startDataIdx = 0;
		v.__mousedown=false;
		v.__mousedownoffset=0;
	}
	vgrid.prototype = {
			__c : function( col ){
				if( col ) this.col = col;
			}
			,__d : function( data ){
				if( data )  this.data = data;
			}
			,__r : function(row){
				if( row )  this.row = row;
			}
			,init: function( option ){
				var t = this;
				t.dWrap = option.wrap;
				t.dGrid = $( t.dWrap ).find("tbody")[0]; // grid == tbody
				t.dScroll = $(t.dWrap).find("."+ option.scrollClass)[0] // scroll == div;
				t.__c(option.col);
				t.__d(option.data);
				t.__r(option.row);
				
				/* event */
				$(t.dGrid)
				.on('wheel',function(e){
					t.wheelEvent.call(t,e);
				})
				.on('mousemove',function(e){
					t.mousemoveEvent.call(t,e);
				})
				.on('mouseup',function(e){
					t.mouseupEvent.call(t,e);					
				})
				.on('selectstart',function(e){
					return false;
				});
				
				$(t.dScroll).on('mousedown',function(e){
					console.log( e.offsetY );
					t.mousedownEvent.call(t,e);
				})
				.on('mouseup',function(e){
					t.mouseupEvent.call(t,e);					
				})
				.on('selectstart',function(e){
					return false;
				});
				
				$('body').on('keydown',function(e){
					t.keydownEvent.call(t,e);
				});
				
				var $g = $(t.dGrid) , i = 0 ;
				while( true ){
					if(  t.getOverWrap() >= 0   || i > t.data.length )  break;
					var _r = utils.matchedReplace( t.row , t.data[i++] );
					$g.append(_r);
				}
				t.rows = $g.find('tr');
				t.range = t.rows.length;
				return t ;
			}
			,setCellData :function( td , col, data ){
				var value = data[col.colId];
				//formatter
				if( typeof col.formatter == 'function') value = col.formatter(value);
				td.title = value;
				td.textContent = value ;
				return td;
			}
			,setRowData:function( rangeValue ){
				var t = this;
				var startIdx = rangeValue.startIdx
					,endIdx 	 = rangeValue.endIdx
					,trIdx 	 = 0;
				var trs = t.rows;
				var col = t.col;
				var data = t.data;
				
				var $g = $(t.dGrid) , i = startIdx ;
				var html = "";
				$g.html("");
				while( true ){
					if(  t.getOverWrap() >= 0   || i > t.data.length )  break;
					var _r = utils.matchedReplace( t.row , t.data[i++] );
					$g.append(_r);
				}
				t.rows = $g.find('tr');
				t.range = t.rows.length;
				/* for(var i = startIdx ; i < endIdx ; i++ ){
				 var tr = trs[trIdx++]; // TRS 전역변수
					 if( tr ){
						 tr.id = i;
						 var tds = tr.childNodes;
						 for(var k = 0 ; k < col.length ; k++){ // COL 전역변수
							 this.setCellData( tds[k] , col[k] , data[i] );
						 }
					}
				} */
				t.startDataIdx = startIdx;
			}
			,getDataRangeIdx:function( param ){
				var t = this;
				var startIdx 	= param.startIdx
					,isLimit 	= param.isLimit
					,scrollPos 	= param.scrollPos;
				var range = t.range 
					, data = t.data 
					, endIdx = startIdx + range;
				if( endIdx > data.length || isLimit === true) {
					endIdx 	 = data.length;
					startIdx = endIdx - range;
				}
						
				return {
					startIdx 	: startIdx
					,endIdx 	: endIdx
				}
			}
			,getOverWrap:function (){
				var t = this;
				var bdH = t.dGrid.scrollHeight 
					, wpH = t.dWrap.offsetHeight;
				return bdH - wpH ;
			}
			,getEventOject:function ( e ){
				if( e.originalEvent ){
					return e.originalEvent
				}else{
					return e
				}
			}
			,getWheelDelta :function (event){
			    if (event.deltaY){
			    	return event.deltaY;	
			    } else if (event.wheelDelta){
			        return  -1 * event.wheelDelta;
			    } else {
			        return -1 * ( event.detail * 40);
			    }
			}
			,refreshGrid:function( dataIdx , isFind ){
				var g = this;
				g.startDataIdx +=dataIdx;
				if( isFind ) g.startDataIdx = dataIdx;
				
				if( g.startDataIdx < 0 ) g.startDataIdx = 0;
				var param = {startIdx : g.startDataIdx};
				var returnValue = g.getDataRangeIdx(param);
				g.setRowData( returnValue );
				g.refreshScroll( returnValue.endIdx );
			}
			,refreshScroll: function( endIdx ){
				var g = this;
				if( !endIdx ){
					endIdx = g.getDataRangeIdx({
									startIdx : g.startDataIdx
								}).endIdx;
				}
				var top 		= g.startDataIdx + 1
					,max 		= g.data.length
					,per 		= ( top / max ) * 100
					,scrollMax 	=  g.dWrap.offsetHeight - g.dScroll.offsetHeight
					,topOfscroll= ( per/100 ) *  ( g.dWrap.offsetHeight - g.dScroll.offsetHeight) ;
				
				 if( endIdx == g.data.length  || g.startDataIdx == 0 ){
					 var dt = g.getOverWrap();
					 if( !g.startDataIdx ) dt *= -1;
					 g.dWrap.scrollTop += dt;
					if (g.startDataIdx == 0) {
						topOfscroll = 0; 
					}else {
						topOfscroll = scrollMax;
					}
				 }
				 if( topOfscroll > scrollMax )  topOfscroll = scrollMax ;
				 if( g.dWrap.scrollTop > 0 ) topOfscroll += g.dWrap.scrollTop;
				 g.dScroll.style.top = topOfscroll  + 'px';
			}
			,wheelEvent: function(e){
				var g = this;
				var dt = g.getWheelDelta ( g.getEventOject( e ) );
				var addIdx = 5;
				if( dt < 0 ) addIdx *= -1;
				g.refreshGrid( addIdx );
			}
			,keydownEvent : function(e){
				var g = this 
				, k = e.keyCode;
				if( k == 33 || k == 34 || k == 38 || k == 40 || k == 35 || k == 36){
					var addIdx = 0;
					switch(k){
						case 38: case 40:
							addIdx = 5;
						break;
						case 33: case 34:
							addIdx = g.range;
						break;
						case 35: case 36:
							addIdx = g.data.length;
						break;
					}
					if( k == 38 || k == 33 || k == 36) addIdx *= -1;
					g.refreshGrid( addIdx );
					
					if( k == 36 ){ //HOME키는 무조건 최상위로 가자 
						g.dScroll.style.top = '0px';
						g.dWrap.scrollTop = 0;
					}
				}
			}
			,mousemoveEvent:function(e){
				var g = this 
				if( !g.__mousedown ) return;
				
				var _wrap = g.dWrap , _sc = g.dScroll;
				if( !g.__mousedownoffset ) g.__mousedownoffset = _sc.offsetHeight/2;
		
				var scrollPosMax  	= _wrap.offsetHeight - _sc.offsetHeight
					,scrollPos 		= e.pageY  - _wrap.getBoundingClientRect().top - g.__mousedownoffset;// + g.getOverWrap();
				if		( scrollPos < 0 			) scrollPos = 0;
				else if ( scrollPos > scrollPosMax  ) scrollPos = scrollPosMax;
				
				_sc.style.top = ( scrollPos ) + 'px';
				
				var param = {
						startIdx : Math.round( ( scrollPos / _wrap.offsetHeight  ) * g.data.length )
						,isLimit : (scrollPos == scrollPosMax)
						,scrollPos : scrollPos
				}
				
				var rangeValue = g.getDataRangeIdx( param );
				g.setRowData( rangeValue  );
			}
			,mousedownEvent:function(e){
				this.__mousedown = true;
				this.__mousedownoffset = e.offsetY;
			}
			,mouseupEvent:function(e){
				this.__mousedown = false;
			}
			/** 데이터 검색  */
			,searchData:function( col , str ){
				var g = this, dt = g.data;
				var result = [];
				for(var i = 0, len = dt.length;i<len;i ++ ){
					if( dt[i][col] == str ){
						result.push( i );
					}
				}
				return result;
			}
			/** idx번째 데이터로 이동  */
			,goToIdx:function(idx){
				var g = this;
				g.refreshGrid( idx , true);
			}
	}
	
	/** vgrid 생성함수( jquery ) : wrap(div) 에 적용됨. */
	$.fn.vgrid = function( option ){
		var wrp = $(this);
		option.wrap = wrp[0];
		var _v = new vgrid();
		return _v.init(option);
	}
	
	var g;
	$(document).ready(function(){
		$("#call").on('click',function(e){
			e.preventDefault();
			var param = {}
			var url = "<s:url value='/co/CO1002$ListAction.do'/>";
			$.ajax({
				url : url
				,data : param
				,dataType:'json'
				,success:function(data){
					console.log( data );
				}
			});
		});
		
		/* 
			<!-- grid wrap -->
			<div id='gridWrap' style='width:400px;height:400px;overflow-y:hidden;overflow-x:hidden;position: relative;'>
				<!-- v scroll -->
				<div class='scroll'></div>
          		<table style='width:100%;'>
          			<colgroup>
          				<col width='20%' />
          				<col width='20%' />
          				<col width='20%' />
          				<col width='20%' />
          				<col  width='20%'/>
          			</colgroup>
          			
          			<!-- grid -->
          			<tbody></tbody>
          		</table>
         	</div>
		*/
		var row = "<tr><td>%{col1}</td><td>%{col2}</td><td>%{col3}</td><td>%{col4}</td><td>%{col5}</td></tr>";
		var col =  [
		        	{colId:'col1'}
		        	,{colId:'col2'}
		        	,{colId:'col3'}
		        	,{colId:'col4'}
		        	,{colId:'col5'}
		];
		var data = [];
			for( var k = 0 , kLen = 100000; k< kLen; k++){
				data.push({
					col1:'col_1_'+k
					,col2:'col_2_'+k
					,col3:'col_3_'+k
					,col4:'col_4_'+k
					,col5:'col_5_'+k
				});
			}
		g = $("#gridWrap").vgrid({
			scrollClass:'scroll'
			,col:col
			,data:data
			,row:row
		});
	});
	
</script>
<style>
	table {  border-collapse: collapse;}
	table th { background: #eee; text-align: center;}
	td, th { border: 1px solid; word-break:break-all;}
	.scroll {position: absolute;right:0;height:20px;width:15px;background: rgba(0, 0, 0, 0.3);cursor:pointer;}
	.scroll:hover {background: rgba(0, 0, 0, 0.6);}
</style>
<div class="container-fluid">
       	<!-- page navigator -->
       	<div class='page-navigator not-contain-height'>
       		<span class="glyphicon glyphicon-home nav-home"></span> 
       		<span class='home'>HOME</span> 
       		<span class="glyphicon glyphicon-menu-right"></span>
       		<span class='mid-menu'>TESTER</span>
       	</div>
       	<!-- page header -->
           <h1 class="page-header not-contain-height">
           	<span class='glyphicon glyphicon-asterisk title-icon'></span> <span class='header-title'>TESTER</span>
           </h1>
		<!-- page content-->
		<div class='page-content'>
           	<form name='frm'>
           		<div id='header' style='width:400px;overflow-y:hidden;overflow-x: hidden'>
           			<table style='width:100%;'>
	           			<colgroup>
	           				<col width='20%' />
	           				<col width='20%' />
	           				<col width='20%' />
	           				<col width='20%' />
	           				<col  width='20%'/>
	           			</colgroup>
	           			<thead>
	           				<tr>
	           					<th>col1</th>
	           					<th>col2</th>
	           					<th>col3</th>
	           					<th>col4</th>
	           					<th>col5</th>
	           				</tr>
	           			</thead>
	           		</table>
           		</div>
           		<div id='gridWrap' style='width:400px;height:400px;overflow-y:hidden;overflow-x:hidden;position: relative;'>
	           		<div class='scroll'></div>
	           		<table style='width:100%;'>
	           			<colgroup>
	           				<col width='20%' />
	           				<col width='20%' />
	           				<col width='20%' />
	           				<col width='20%' />
	           				<col  width='20%'/>
	           			</colgroup>
	           			<tbody id='testgrid'>
	           			</tbody>
	           		</table>
           		</div>
           		<button type='button' id='call'>a</button>
           	</form>
		</div>
		<!-- /#page-wrapper -->
</div>
<%@ include file="/jsp/co/commonTAIL.jsp"%>