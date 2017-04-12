/**
 * @Description : v-scroll. 버추얼 스크롤 그리드
 * @Modification Information
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2017.04.12		이종욱          	최초 생성
 *  @namespace 
 *  @author 이종욱
 *  @since 2017.04.12
 *  @version 1.0
 */
var vScroll;
/*
 	example )))
 	 
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
	<script>
		var row = "<tr><td>%{col1}</td><td>%{col2}</td><td>%{col3}</td><td>%{col4}</td><td>%{col5}</td></tr>";
		var col =  [
		        	{colId:'col1', formatter:function(index, data, datas){
		        		if( index > 10 ){
			        		return "HI! "+data+" !!";
		        		}else{
		        			return data;
		        		}
		        	}}
		        	,{colId:'col2'}
		        	,{colId:'col3'}
		        	,{colId:'col4'}
		        	,{colId:'col5'}
		];
		var data = [];
			for( var k = 0 , kLen = 200; k< kLen; k++){
				data.push({
					col1:'col_1_'+k
					,col2:'col_2_'+k
					,col3:'col_3_'+k
					,col4:'col_4_'+k
					,col5:'col_5_'+k
				});
		}
		var option = {
				scrollClass:'scroll'
					,col:col
					,data:data
					,row:row
		}
		g = $("#gridWrap").vgrid(option);
	</script>
*/
(function($){
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
			 _matchedRegExp: /%{[^}]+}/g
			,_replaceRegExp: /[%{}]/g
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
			,_setCol : function( col ){
				if( col ) this.col = col;
			}
			,_setData : function( data ){
				var t = this;
				if( data )  this.data = data;
				var c = t.col 
					, d = t.data;
				for( var k =0;k<c.length;k++){
					var _c = c[k] 
						, fmt = _c.formatter 
						, colId = _c.colId;
					if( typeof fmt == 'function' ){
						for( var i =0  , len = d.length;i < len ; i ++){
							var _d = d[i][colId];
							d[i][colId] = fmt( i , _d , d );
						}
					}
				}
			}
			,_setRow : function(row){
				if( row )  this.row = row;
			}
			,init: function( option ){
				var t = this;
				var grid = option.gridSelector ? option.gridSelector : "tbody";
				t.dWrap = option.wrap;
				t.dGrid = $( t.dWrap ).find( grid )[0]; // grid == tbody
				t.dScroll = $(t.dWrap).find("."+ option.scrollClass)[0] // scroll == div;
				
				t._setCol( option.col );
				t._setData( option.data );
				t._setRow( option.row );
				
				/* event */
				$(t.dWrap)
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
				})
				.css("position","relative");
				
				$(t.dScroll).on('mousedown',function(e){
					t.mousedownEvent.call(t,e);
				})
				.on('mouseup',function(e){
					t.mouseupEvent.call(t,e);					
				})
				.on('selectstart',function(e){
					return false;
				})
				.css("position","absolute")
				.css("right","0px");
				
				$('body').on('keydown',function(e){
					t.keydownEvent.call(t,e);
				});
				
				t.setRowData( { startIdx : 0 } );
				
				return t ;
			}
			/* ,setCellData :function( td , col, data ){
				var value = data[col.colId];
				//formatter
				if( typeof col.formatter == 'function') value = col.formatter(value);
				td.title = value;
				td.textContent = value ;
				return td;
			} */
			,reload:function( data ){
				this._setData(data);
				this.setRowData( { startIdx : 0 } );
			}
			,setRowData:function( rangeValue ){
				var t = this;
				
				var $g = $(t.dGrid) 
					, startIdx = i = rangeValue.startIdx 
					, _row = t.row 
					, _dt = t.data;
				
				$g.html("");
				while( true ){
					if(  t.getOverWrap() >= 0   || i > t.data.length )  break;
					var d = _dt[i++];
					var _r = t.matchedReplace( _row , d );
					$g.append(_r);
				}
				t.rows 	= $g.find('tr');
				t.range = t.rows.length;
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
//					,scrollPos 		= e.pageY  - _wrap.getBoundingClientRect().top - g.__mousedownoffset;// + g.getOverWrap();
					,scrollPos 		= e.clientY  - _wrap.getBoundingClientRect().top - g.__mousedownoffset;// + g.getOverWrap();
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
					if( dt[i][col] == str  ){
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
		return _v.init( option );
	}
	
	vScroll = {
			create : function( option ){
				var _v = new vgrid();
				return _v.init( option );
			}
		};
}($));