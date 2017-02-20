//############ 헤더 커스텀레이아웃 & 터치이벤트 잘안됨
// result.match(/#{[^}]+}/g)
jQuery(function($){
'use strict';
// 기본 옵션 항목
var _opt = {
		name :''
		,id:''
		,width:0
		,height:0
}
// 기본 프로퍼티 항목
var props = {
		name :''
		,scroll:false
		,type:'a' // 그리드 타입 A / B ( 리프레시(a) or 객체추가(b) )
		,id:''
		,width:0
		,height:150
		,headerHidden:false
		,columnToggle : false
		,data:[]
		,col:[]
		,colIds:[]
		,cutString:false
		,autoFit:true
		,record:-1
		,boxForDom :{
			$rows:[]
			,$cells:[]
			,$wrap 			: null
			,$tableWrap		: null
			,$bodyWrap		: null
			,$headWrap 		: null
			,$body	 		: null
			,$head	 		: null
			,$scroll_y_wrap	: null
			,$scroll_y 		: null
			,$scroll_x_wrap	: null
			,$scroll_x 		: null
		}
		,boxForCss:{
			cutString:{
				'true':'cutString'
				,'false':'default'
			}
			,rowClass:['zgrid-row']
		}
		,varForData:{
			startDataIdx:0
			,endDataIdx:0
			,range:0
		}
		,varForScroll:{
			y:{
				position:0
				,scrollClickOffset:0
				,mousedown:false
			},
			x:{
				position:0
				,scrollClickOffset:0
				,mousedown:false
			}
			,scrollBtnSize:20
		}
		,varForTouch:{
			direction : {H:0,V:1,CURRENT:-1}
			,touchStartPos:{x:0,y:0}
			,touchStartTarget : null
		}
}
$.fn.extend({
	grid : function( option ){
		if( ! option.id ) option.id = "rGrid_"+ new Date().getTime();
		if( ! option.type ) option.type = 'a';
		var grd;
		if( option.type == 'a'){
			//grid type 1.
			grd = new Grid( option );
		}else if( option.type == 'b'){
			//grid type 2.
			grd = new Grid2( option );
		}
		for(var i = 0 ;i < option.col.length;i++)
			grd.colIds.push( grd.col[i].colId );
		
		grd.init( this );
		
		
		return grd;
	}
});

function Grid(option){
	newGrid.call(this,option);
}
function Grid2(option){
//	if( option.record < 0 || !option.record ) option.record = option.data.length
	newGrid.call(this,option);
}

function newGrid( option ){
	var v = JSON.parse( JSON.stringify(props) );
	v = $.extend( v, option );
	$.extend( this , v );
}

var gridMethod = {
		//data setting....... test중
		initSetData:function(col , data){
			if( !data || data.length == 0 )data = this.data;
			if( !col || col.length == 0 )col = this.col;
			
			var colLen = col.length;
			var indexInfo = setInitColIndex( col );

			for(var i = 0 , len = data.length ; i<len; i++){
				data[i][indexInfo]
			}
			
			function setInitColIndex( col ){
				/*var returnColIndex = {};
				for ( var i = 0 , len = col.length ; i < len ; i++){
					returnColIndex[col[i].colId] = i;
				}*/
				var returnColIndex = [];
				for ( var i = 0 , len = col.length ; i < len ; i++){
					returnColIndex[i] = col[i].colId;
				}
				return returnColIndex;
			}
		}
		,bindEvent:function( grd ){
			//이벤트 따로
			var t = this;
			
			if( t.scroll ){
				grd.boxForDom.$tableWrap
					.unbind('wheel')
					.unbind('mouseup')
					.unbind('mousemove')
					.unbind('touchstart')
					.unbind('touchmove')
					.unbind('touchend');
				grd.boxForDom.$tableWrap.unbind('wheel');
				
				
				grd.boxForDom.$scroll_x.unbind('mousedown');
				grd.boxForDom.$scroll_y.unbind('mousedown');
				
				grd.boxForDom.$scroll_x.bind('mousedown',function(e){
					grd.eventBox.mousedown.call( grd, 'x', e );
				});
				grd.boxForDom.$scroll_y.bind('mousedown',function(e){
					grd.eventBox.mousedown.call( grd, 'y', e );
				});
				
				//scrollbtn 
				grd.boxForDom.$wrap.find(".g-scroll-btn").bind('mousedown',function(e){
					$(e.target).addClass('clicked');
				});
				
				grd.boxForDom.$tableWrap.bind('mouseup',function(e){
					grd.eventBox.mouseup.call( grd, 'x', e );
					grd.eventBox.mouseup.call( grd, 'y', e );
					
					$('.clicked').removeClass('clicked');
				});
				
				grd.boxForDom.$tableWrap.bind('mousemove',function(e){
					grd.eventBox.mousemove.y.call( grd, e );
					grd.eventBox.mousemove.x.call( grd, e );
				});
				
				grd.boxForDom.$tableWrap.bind('touchstart',function(e){
					grd.eventBox.touchstart.call( grd, e );
				});
				
				/*$(document).bind("DOMNodeRemoved", function(e){
				    console.log("Removed: " , e.target);
				});*/
				grd.boxForDom.$tableWrap.bind('touchend',function(e){
					grd.eventBox.touchend.call( grd, e );
				});
			}else{
				grd.boxForDom.$bodyWrap.bind('scroll',function(e){
					grd.boxForDom.$headWrap[0].scrollLeft = this.scrollLeft;
				});
			}
			
			if( t.height != 'auto'){
				if( t.scroll ){
					grd.boxForDom.$tableWrap.bind('wheel',function(e){
							if( e.altKey ){
								grd.eventBox.wheel.x.call( grd , e );
							}else{
								grd.eventBox.wheel.y.call( grd , e );
							}
					});
					grd.boxForDom.$tableWrap.bind('touchmove',function(e){
						grd.eventBox.touchmove.call( grd, e );
					});
				}
			}
			
			
			$(window).unbind('resize',_resize);
			$(window).bind('resize',_resize).trigger('resize');
			function _resize(e){
				if( grd.boxForDom.$wrap.width() >  0 ) grd.eventBox.resize.call( grd, e );
			}
			
		}
		,init:function( wrap ){
			this.boxForDom.$wrap = wrap;
			this.initCreateGridFrame();
			this.setGridHeight(this.height);
			this.makeGrid();
			this.bindEvent( this );
		}
		/**
		 *  그리드 기본 골격 생성
		 */
		,initCreateGridFrame: function(){
			var t = this;
			if( t.type == 'a') t.scroll = true;
			var dom = t.boxForDom;
			var _$wrap = dom.$wrap;
			_$wrap.html("");
			var $tableWrap = $("<div class='g-wrap'></div>");
				//scroll
				var _colgrp_html = "";
					_colgrp_html += "<div class='g-colgrp'><div class='g-col'></div>"
					if( t.scroll) _colgrp_html += "<div class='g-scroll-area g-col'></div>"
					_colgrp_html += "</div>";
				var $colGrp = $(_colgrp_html); 
				var $headRow = $("<div class='g-row'></div>");
					var $headWrap = $("<div class='g-head-wrap'></div>");//id='headerWrap'
						var $headTable = createTable('head');
						var $head = $headTable.find('thead');
						$headWrap.append( $headTable );
				
					if( t.scroll ) var $scrollBlankY = $("<div class='g-scroll-area g-scroll-btn-blank g-cell' style=''>&nbsp;</div>");
					
					$headRow
						.append( $headWrap );
						if( t.scroll )$headRow.append( $scrollBlankY );
					
				var $bodyRow = $("<div class='g-row'></div>");
					var $bodyWrap = $("<div class='g-body-wrap'></div>");//id='headerWrap'
						var $bodyTable = createTable('body');
						var $body = $bodyTable.find('tbody');
						$bodyWrap.append( $bodyTable );
					
					if( t.scroll ){
						var $scroll_y_wrap = $("<div class='g-scroll-area g-cell g-scroll-wrap'></div>"); //id='scroll-wrap'
							var $btnUp = $("<span class='up g-scroll-btn'></span>");
						var $scroll_y =$("<div class='g-scroll-y'></div>");//id='scroll'  
						var $btnDown = $("<span class='down g-scroll-btn'></span>");
						$scroll_y_wrap
							.append( $btnUp )
							.append( $scroll_y )
							.append( $btnDown );
					}
					
					$bodyRow.append( $bodyWrap );
					if( t.scroll )$bodyRow.append( $scroll_y_wrap );
				if( t.scroll ){
					
					var $xScrollRow = $("<div class='g-row g-scroll-x-row'></div>");
						var $scroll_x_wrap = $("<div class='g-cell g-scroll-wrap' style='height:"+this.varForScroll.scrollBtnSize+"px;'>"); //id='x-scroll-wrap' 
							var $btnLeft = $("<span class='left g-scroll-btn'></span>");
							var $scroll_x =$("<div class='g-scroll-x'></div>");//id='x-scroll'   
							var $btnRight = $("<span class='right g-scroll-btn'></span>");
							$scroll_x_wrap
								.append( $btnLeft )
								.append( $scroll_x )
								.append( $btnRight );
						var $scrollBlankX = $("<div class='g-scroll-area g-cell g-scroll-btn-blank' >&nbsp;</div>");
						$xScrollRow
							.append( $scroll_x_wrap )
							.append( $scrollBlankX );
				}	
			$tableWrap
				.append( $colGrp )
				.append( $headRow )
				.append( $bodyRow );
				if( t.scroll )$tableWrap.append( $xScrollRow );
			
			_$wrap.append( $tableWrap );
			
			//autoFit 세팅
			if( t.autoFit === false || t.width ){
				if( !t.width ) t.width = $body.width();
				$tableWrap.find('.g-table').width( t.width );
			}
			if( t.scroll ){
				$scroll_y[0].style.top = $btnUp[0].offsetHeight + 'px';
				$scroll_x[0].style.left = $btnLeft[0].offsetWidth + 'px';
				$scroll_x[0].style.height = this.varForScroll.scrollBtnSize + 'px';
				
				dom.$scroll_y_wrap 	= $scroll_y_wrap;
				dom.$scroll_y 		= $scroll_y;
				dom.$scroll_x_wrap 	= $scroll_x_wrap;
				dom.$scroll_x 		= $scroll_x;
			}
			
			dom.$tableWrap 		= $tableWrap;
			dom.$bodyWrap 		= $bodyWrap;
			dom.$headWrap 		= $headWrap;
			dom.$body 			= $body;
			dom.$head 			= $head;
			
			
			if( t.columnToggle && t.type == 'a'){
				dom.$headWrap.parent().hide();
				$bodyTable.append( $head );
//				$bodyTable.css('table-layout','auto');
			}
			
			function createTable( type ){
				var colInfo = t.col;
				var $table = $("<table class='g-table'></table>");
				var $colgrp = $("<colgroup></colgroup>");
				
				if (      (typeof t.customColumnLayout == 'function' && t.type == 'b') 
					  ||  (typeof t.customColumnLayout != 'function' && typeof t.customRowLayout == 'function')){
					if(typeof t.customColumnLayout == 'function'){
						$colgrp = t.customColumnLayout( colInfo );
					}else{
						var $col = $("<col/>");
						$colgrp.append($col);
					}
				}else{
					var $col = $("<col/>");
					for( var i = 0 ,len = colInfo.length; i< len ; i ++ ){
						var width = colInfo[i].width;
						var unit = (colInfo[i].widthUnit)? colInfo[i].widthUnit : 'px';
						width = ( width )? width :50  ;
						var _c = $col.clone().css('width', width + unit);
						if( t.columnToggle && colInfo[i].priority ) _c.addClass('g-col-priority-'+colInfo[i].priority);
						$colgrp.append(_c);
					}
				}
				
				var $content = $("<t"+type+" class='g-"+type+"'></t"+type+">");
				
				if( type == 'head' ){
					var $tr = $("<tr></tr>");
					if ( typeof t.customHeaderLayout == 'function' && t.type == 'b' ){
						$tr.append( t.customHeaderLayout( colInfo ) );
					}else{
						var $th = $("<th class='"+t.boxForCss.cutString[t.cutString]+"'></th>");
						for( var i = 0 ,len = colInfo.length; i< len ; i ++ ){
							var _c = $th.clone().text( colInfo[i].name );
							if( t.columnToggle && colInfo[i].priority ){
								_c.addClass('g-col-priority-'+colInfo[i].priority);
							}
							$tr.append(_c);
						}
					}
					$content.append( $tr );
				}
				
				if( !t.columnToggle )$table.append($colgrp);
				$table.append($content);
				
				return $table;
			}
		}
		,setGridHeight:function( height ){
			if( height == 'auto'){
				this.boxForDom.$bodyWrap.css('height','auto');
			}else{
				if( typeof height != 'undefined') this.height = height; 
				this.boxForDom.$bodyWrap.height( this.height );
			}
		}
		/**
		 * 그리드를 그린다.
		 */
		,makeGrid : function( param_data ){}
		/**
		 * 스크롤 높이 세팅
		 */
		,setScrollHeight : function(){}
		/** row를 생성하여 추가한다.
		 *	tbody : data table의 Tbody
		 *	dataIdx : 추가할 row의 데이터값 인덱스 
		 */
		, addRowData:function( tbody , dataIdx ){
			var col = this.col;
			var data = this.data;
			if( data.length < 1) {
				tbody.append(  this.addBlankRow() );
				return false;
			}else{
				
				var newTr = $("<tr class='"+this.boxForCss.rowClass.join(' ')+"'></tr>").clone();
				var td = $("<td class='"+this.boxForCss.cutString[this.cutString]+"'></td>");
				
				for(var k = 0,kLen=col.length;k<kLen;k++){
					newTr[0].id = dataIdx;
					var _td = this.setCellData( td.clone()[0], col[k], data[dataIdx] );
					newTr.append( _td );
				}
				tbody.append(newTr);
				
				return true;
			}
		}
		/**
		 *	column 정보를 이용하여 cell에 데이터를 세팅한다.		
		 */
		,setCellData:function( td , col, data ){
			var value = data[col.colId];
			//formatter
			if( typeof col.formatter == 'function') value = col.formatter(value);
			td.title = value;
			td.textContent = value ;
			
			if( this.columnToggle && col.priority ) $(td).addClass('g-col-priority-'+col.priority);
			
			return td;
		}
		/**
		 *  data영역에 넘치는지 아닌지 체크
		 */
		,getOverWrap:function(){
			var bdyWrap = this.boxForDom.$bodyWrap[0];
			return bdyWrap.scrollHeight - bdyWrap.offsetHeight;
		}
		// index값을 받아와서, 실질적으로 데이터를 적용시킨다.
		,setRowData:function( rangeValue ){
			var t = this;
			var startIdx = rangeValue.startIdx
				,endIdx 	 = rangeValue.endIdx
				,trIdx 	 = 0;
			var trs = t.boxForDom.$rows;
			var col = t.col;
			var data = t.data;
			for(var i = startIdx ; i < endIdx ; i++ ){
			 var tr = trs[trIdx++]; // TRS 전역변수
				 if( tr ){
					 tr.id = i;
					 var tds = tr.childNodes;
					 for(var k = 0 ; k < col.length ; k++){ // COL 전역변수
						 this.setCellData( tds[k] , col[k] , data[i] );
					 }
				}
			}
			// 데이터가 모자르게 생성된경우 데이터 tr을 추가로 append해준다.
			if( t.record < 0 && t.getOverWrap() == 0  ){
				if( data[ endIdx + 1 ] ){ //함수정리필요
					var tbody = t.boxForDom.$body;
					t.addRowData( tbody , endIdx+1 );
					t.varForData.range 	= tbody.find('tr').length;
					t.boxForDom.$rows	= tbody.find('tr');
					t.setRowData( rangeValue );
					return;
				}
			}
			t.varForData.startDataIdx = startIdx;
		}
		//------------------------------------------------------------------------------!!!
		// 시작 index를 받아서 끝 index를 함께 계산 후 반환한다.
		,getDataRangeIdx:function( param ){
			var t = this;
			var startIdx 	= param.startIdx
				,isLimit 	= param.isLimit
				,scrollPos 	= param.scrollPos;
			var range = t.varForData.range;
			var data = t.data;
			var endIdx = startIdx + range;
			if( isLimit === true || endIdx > data.length) {
				endIdx 	 = data.length;
				startIdx = endIdx - range;
				
				var bottomArea = t.getOverWrap(); // data가 over된경우;
				if( bottomArea > 0 ) t.boxForDom.$bodyWrap.scrollTop( bottomArea );
				
			}else{
				if( scrollPos && scrollPos < 3) startIdx = 0;
				if( t.columnToggle ) t.boxForDom.$bodyWrap.scrollTop(0);
			}
					
			return {
				startIdx 	: startIdx
				,endIdx 	: endIdx
			}
		}
		,eventBox :{
			resize: function(e){
				var doms 		= this.boxForDom;
				if( this.scroll ){
						varbtnSize	= this.varForScroll.scrollBtnSize
						,btnSizeX2 	= btnSize * 2 
						,scrollYwidth = doms.$scroll_y_wrap[0].offsetWidth
					 	,$scrollx 	= doms.$scroll_x
					 	,$scrollXParent = doms.$scroll_x_wrap 
				 	
				 	var total = doms.$wrap[0].offsetWidth - scrollYwidth;
				 	doms.$headWrap[0].style.width = total +'px';
				 	doms.$bodyWrap[0].style.width = total +'px';
			 		
			 		//x 스크롤 너비 세팅
			 		var scrollWidth = ( doms.$bodyWrap[0].offsetWidth * ( $scrollXParent[0].offsetWidth - btnSizeX2 ) )/ doms.$body[0].offsetWidth;
		 			if( doms.$body[0].offsetWidth <= total) {
			 			$scrollx.hide();
			 			doms.$wrap.find(".g-scroll-x-row").hide();
			 			$scrollXParent.find(".g-scroll-btn").addClass('off');
			 		}else{
			 			$scrollx.show();
			 			doms.$wrap.find(".g-scroll-x-row").show();
			 			$scrollXParent.find(".g-scroll-btn").addClass('on');
			 		}
			 		
			 		$scrollx[0].style.width = scrollWidth + 'px';
			 		$scrollx[0].style.left = btnSize + 'px';
				}else{
					if( doms.$body.height() > doms.$bodyWrap.height() ){
						doms.$headWrap.css('overflow-y','scroll');
					}
					var total = doms.$wrap[0].offsetWidth;
				 	doms.$headWrap[0].style.width = total +'px';
				 	doms.$bodyWrap[0].style.width = total +'px';
				}
			}
			,wheel : {
				y : function(e){
					e.preventDefault();
					var movement = getWheelDelta(  getEventOject(e)  );
					this.wheelMovingY(  movement  );
				}
				,x:function(e){
					e.preventDefault();
					var movement = getWheelDelta(  getEventOject(e)  );
					this.wheelMovingX( movement );
				}
			}
			, mousedown : function( type, e ){
				var offset;
				switch (type) {
					case 'x':
						offset = e.offsetX; 
						break;
					case 'y':
						offset = e.offsetY; 
						break;
				}
				
				this.varForScroll[type].mousedown = true;
				this.varForScroll[type].scrollClickOffset = offset ;
			}
			, mouseup : function( type, e ){
				this.varForScroll[type].mousedown = false;
				this.varForScroll[type].scrollClickOffset = 0 ;
			}
			,mousemove :{
				x:function(e){
					if( this.varForScroll.x.mousedown ){
						this.scrollMovingX( e.pageX );
					}
				}
				,y:function(e){
					if( this.varForScroll.y.mousedown ){
						this.scrollMovingY( e.pageY );
					}
				}// eventBox.mousemove.y
			}// eventBox.mousemove
			,touchstart:function(e){
				var t = this;
				t.varForTouch.touchStartPos.x = t.getTouchPosition( e, 'x' );
				t.varForTouch.touchStartPos.y = t.getTouchPosition( e, 'y' );
				var target = e.target; 
				switch (true) {
					case target == t.boxForDom.$scroll_y[0] :
						t.varForTouch.touchStartTarget = 'y'					
						break;
					case target == t.boxForDom.$scroll_x[0] :
						t.varForTouch.touchStartTarget = 'x';
						break;
					default:
						t.varForTouch.touchStartTarget = null;
						break;
				}
//				t.callPreventDefault( e );
				
			}// eventBox.touchstart
			,touchmove:function(e){
				var t = this;
				e.preventDefault();
//				t.callPreventDefault( e );
				var touchedPos = t.varForTouch.touchStartPos;
				var x = t.getTouchPosition( e, 'x' );
				var y = t.getTouchPosition( e, 'y' );
				
				if( null != t.varForTouch.touchStartTarget){
					switch (t.varForTouch.touchStartTarget) {
						case 'x':
							t.scrollMovingX( x );
							break;
						case 'y':
							t.scrollMovingY( y );
							break;
					}
				}else{
					// 사용자 터치이동 방향
					var direction = t.getTouchType( x , y , touchedPos.x , touchedPos.y );
					if( t.varForTouch.direction.CURRENT < 0 ) t.varForTouch.direction.CURRENT = direction; 
					var currentDir = t.varForTouch.direction.CURRENT
						,H  = t.varForTouch.direction.H
						,V  = t.varForTouch.direction.V;
					
					switch (true) {
						case direction == H && currentDir == H : // 수평제스쳐
							// 움직인 거리
							var movement =  ( x - touchedPos.x ) * -1;
							t.wheelMovingX( movement );
							t.varForTouch.touchStartPos.x = x;
							t.varForTouch.direction.CURRENT = t.varForTouch.direction.H;
							
							break;
						case direction == V && currentDir == V : // 수직제스쳐
							// 움직인 거리
							var movement = ( y - touchedPos.y ) * -1;
							t.wheelMovingY ( movement );
							t.varForTouch.touchStartPos.y = y;
							t.varForTouch.direction.CURRENT = t.varForTouch.direction.V;
							break;
					}
				}
			}// eventBox.touchmove
			,touchend:function(){
				this.varForTouch.direction.CURRENT = -1;
				this.varForTouch.touchStartTarget = null;
			}// eventBox.touchend
		}//eventBox
		
		,wheelMovingY : function( movement ){}
		,scrollMovingY : function( pageY ){}
		
		,wheelMovingX : function( movement ){
			var t 			= this
				,dataInfo 	= t.varForData
				,domBox 	= t.boxForDom
				,btnSize	= t.varForScroll.scrollBtnSize
				,btnSizeX2  = btnSize * 2 
				,validScrollArea = domBox.$scroll_x_wrap[0].offsetWidth - btnSizeX2;
			
			domBox.$bodyWrap[0].scrollLeft += movement; //delta check
			domBox.$headWrap[0].scrollLeft += movement;
			
			var top 	= domBox.$bodyWrap[0].scrollLeft
				,max 	= domBox.$bodyWrap[0].scrollWidth
				,per 	= ( top/max ) * 100
				,scrollMax = domBox.$scroll_x_wrap[0].offsetWidth - domBox.$scroll_x[0].offsetWdith - btnSizeX2
				,maxPer = ( scrollMax / validScrollArea ) * 100;
	
			if( per > maxPer ) per = maxPer;
			
			var topOfscroll = ( per / 100 ) * validScrollArea;
			domBox.$scroll_x[0].style.left = (topOfscroll + btnSize)+'px';
		}
		,scrollMovingX : function( pageX ){
			var domBox 			= this.boxForDom
				,scrollParent 	= domBox.$scroll_x_wrap[0]
				,scroll 		= domBox.$scroll_x[0]
				,bodyWrap		= domBox.$bodyWrap[0]
				,headWrap		= domBox.$headWrap[0]
				,btnSize 		= this.varForScroll.scrollBtnSize
				,btnSizeX2 		= btnSize * 2 
				,validScrollArea = scrollParent.offsetWidth - btnSizeX2;
			
			if( ! this.varForScroll.x.scrollClickOffset ) 
					this.varForScroll.x.scrollClickOffset = scroll.offsetWidth/2;
			
			var scrollMax 		= scrollParent.offsetWidth - scroll.offsetWidth - btnSizeX2
				,scrollPos 		= pageX  - scrollParent.offsetLeft - this.varForScroll.x.scrollClickOffset - btnSize
				,scrollMaxTop 	= ( scrollMax / validScrollArea ) * 100;
			
			if		( scrollPos < 0 		) scrollPos = 0;
			else if ( scrollPos > scrollMax ) scrollPos = scrollMax;
			
			var maxPer = ( scrollPos / scrollMax ) * 100;
			if( maxPer > scrollMaxTop ) maxPer = scrollMaxTop;
			
			scroll.style.left = ( scrollPos + btnSize ) + 'px';
	
			var bodyScrollLeft = ( scrollPos / validScrollArea ) * bodyWrap.scrollWidth ;
			bodyWrap.scrollLeft = bodyScrollLeft ;
			headWrap.scrollLeft = bodyScrollLeft ;
		}
		
		//-- touch event 관련
		,getTouchPosition : function( e, type, idx ){
			if ( typeof idx == 'undefined' ) idx = 0;
			return getEventOject(e).targetTouches[idx]['page'+type.toUpperCase()];
		}
		// 터치방향의 타입을 정한다 ( 수평 : 0 / 수직: 1 ) 
		,getTouchType : function( afterX , afterY , beforeX, beforeY ){
			var moveType = -1;
			var newX = Math.abs(beforeX - afterX);
			var newY = Math.abs(beforeY - afterY);
			var range = newX + newY;
	
			// 일정범위 이하로 움직이면 무시함
			if( range  < 25 ) return moveType;
			//화면 기울기			
			var hSlope = ((window.innerHeight/2) / window.innerWidth).toFixed(2)*1;
	
			//사용자의 터치 기울기
			var slope = parseFloat((newY/newX).toFixed(2),10);
	
			if( slope > hSlope){//수직이동
				moveType = this.varForTouch.direction.V;	
			}else{// 수평이동
				moveType = this.varForTouch.direction.H ;	
			}
			return moveType;
		}
		,toggleHeader : function( flag ){
			if( typeof flag == 'undefined'){
				if( this.boxForDom.$headWrap.parent().css('display') == 'none' ){
					this.boxForDom.$headWrap.parent().show();
				}else{
					this.boxForDom.$headWrap.parent().hide();
				}
			}else{
				if( flag == 'hide' ) this.boxForDom.$headWrap.parent().hide();
				else if( flag == 'show' ) this.boxForDom.$headWrap.parent().show();
			}
			/*,height:'auto'
				,headerHidden:true*/
		}
		,reload:function( data ){
			this.makeGrid( data );
		}
		,addBlankRow :function(){
			var colCnt = this.boxForDom.$headWrap.find("col").length;
			var blank = $("<td colspan='"+colCnt+"' style='text-align:center;'> No Data </td>");
			return blank;
		}
}
var _grid1={}
var _grid2={}

var grid1 = {
		/**
		 * 그리드를 그린다.
		 */
		makeGrid : function( param_data ){
			var t = this;
			if( typeof param_data != 'undefined') t.data = param_data;
			var data = t.data;
			var tbody = t.boxForDom.$body.html("");
			var i = 0;
			// 스크롤이생길때까지 tr생성
			while( true ){
				if( t.record < 0 && ( t.getOverWrap() > 0  || i == data.length ) )  break;
				else if( t.record > 0 && i == t.record ) break;
				
				if( !t.addRowData( tbody , i++ ) ) break;
			}
			
			t.varForData.range 	= tbody.find('tr').length;
			t.boxForDom.$rows = tbody.find('tr');
			t.boxForDom.$cells = tbody.find('td');
//			COL_INDEX 	= setInitColIndex( COL ) ;
			
			
//			tbody.find('tr:odd').addClass('g-row-odd-background');
//			tbody.find('tr:even').addClass('g-row-even-background');
			if( t.headerHidden ){
				t.toggleHeader('hide');
			}
			if( t.scroll ) t.setScrollHeight();
			t.initSetData();
		}
		/**
		 * 스크롤 높이 세팅
		 */
		,setScrollHeight : function(){
			var t = this;
			if( !t.data )t.data = [];
			
			var bodywrap = t.boxForDom.$bodyWrap[0];
			var scroll = t.boxForDom.$scroll_y[0];
			var body = t.boxForDom.$body[0];
			var data = t.data;
			var range = t.varForData.range;
			var scrollBtnSize = t.varForScroll.scrollBtnSize;
			var scrollBtnSizeX2 = scrollBtnSize *2;
			
			var totalScrollHeight = ( $(body).find('tr')[0].offsetHeight * data.length );
			var movingHeight = scroll.parentNode.offsetHeight - scrollBtnSizeX2;
			var scrollHeight = ( bodywrap.offsetHeight * movingHeight ) / totalScrollHeight ;
			
			// ----------------new
			if( scrollHeight < 10 )  {
				scrollHeight = 10;
			}else if ( scrollHeight > movingHeight || (data.length == range && t.getOverWrap() > 0) ) {
				//스크롤높이가 넘치는경우와
				//생성된 TR개수가 datalength와 같은경우 ( 원래는 스크롤이 안생기는경우 )인데, 예외적으로 스크롤이 생긴경우에는
				// 스크롤커서의 높이를 getOverWrap() 만큼 빼준다.
				scrollHeight = movingHeight - t.getOverWrap();
			}
			
			var bottomArea = t.getOverWrap();
			if( bottomArea == 0 ){
				$(scroll).hide();
				t.boxForDom.$wrap.find(".g-scroll-area").hide();
				$(scroll).parent().find('.g-scroll-btn').addClass('off');
			}else{
				$(scroll).show();
				t.boxForDom.$wrap.find(".g-scroll-area").show();
				$(scroll).parent().find('.g-scroll-btn').addClass('on');
				scroll.style.height = scrollHeight+'px';
				scroll.style.top = scrollBtnSize + 'px';
			}
			// ----------------new
		}
		// ## grid1
		,wheelMovingY : function( movement ){
			var t = this
				,dataInfo 	= t.varForData
				,domBox 	= t.boxForDom
				,scroll 	= domBox.$scroll_y[0]
				,scrollParent = domBox.$scroll_y_wrap[0]
				,scrollDelta = movement ;// e.originalEvent.deltaY; // !!!!!!!!!!!! delta 크로스브라우징  
	
			if( scrollDelta > 0) dataInfo.startDataIdx += 5;
			else				 dataInfo.startDataIdx -= 5;
	
			// ------------ data setting
			if( dataInfo.startDataIdx < 0 ) dataInfo.startDataIdx = 0;
			var param			 = { startIdx : dataInfo.startDataIdx  }
				, returnValue	 = t.getDataRangeIdx(  param  );
			t.setRowData( returnValue );
			
			var btnSize 	= t.varForScroll.scrollBtnSize
				,btnSizeX2 	= btnSize * 2 
				// 스크롤 위치 세팅
				,top 		= dataInfo.startDataIdx + 1
				,max 		= t.data.length
				,per 		= ( top / max ) * 100
				,scrollMax 	=  scrollParent.offsetHeight - scroll.offsetHeight - btnSizeX2
				,topOfscroll= ( per/100 ) * ( scrollParent.offsetHeight - btnSizeX2 );
			
			 if( returnValue.endIdx == t.data.length  || dataInfo.startDataIdx == 0 ){
				 domBox.$bodyWrap[0].scrollTop += scrollDelta
				if (dataInfo.startDataIdx == 0) topOfscroll = 0; 
				else 							topOfscroll = scrollMax; 
			 }
			 if( topOfscroll > scrollMax ) topOfscroll = scrollMax ;
			 scroll.style.top = ( topOfscroll + btnSize ) + 'px';
		}
		//## grid1
		,scrollMovingY : function( pageY ){
			var domBox = this.boxForDom
				,scrollParent = domBox.$scroll_y_wrap[0]
				,scroll = domBox.$scroll_y[0]
				,btnSize = this.varForScroll.scrollBtnSize
				,btnSizeX2 = btnSize * 2; 
			
			if( !this.varForScroll.y.scrollClickOffset )
					this.varForScroll.y.scrollClickOffset = scroll.offsetHeight/2;
	
			var scrollPosMax  	= scrollParent.offsetHeight - scroll.offsetHeight - btnSizeX2
				,scrollPos 		= pageY  - scrollParent.offsetTop - this.varForScroll.y.scrollClickOffset - btnSize ;
			
			if		( scrollPos < 0 			) scrollPos = 0;
			else if ( scrollPos > scrollPosMax  ) scrollPos = scrollPosMax;
			
			scroll.style.top = ( scrollPos + btnSize ) + 'px';
			
			var param = {
					startIdx : Math.round( ( scrollPos / (scrollParent.offsetHeight - btnSizeX2) ) * this.data.length )
					,isLimit : (scrollPos == scrollPosMax)
					,scrollPos : scrollPos
			}
			
			var rangeValue = this.getDataRangeIdx( param );
			this.setRowData( rangeValue  );
		}
}// ## grid1

// 그리드 타입 2 
var grid2 = {
		/**
		 * 그리드를 그린다.
		 */
		makeGrid : function( param_data ){
			var t = this;
			if( typeof param_data != 'undefined') t.data = param_data;
			var data = t.data;
			t.record = data.length;
			var tbody = t.boxForDom.$body.html("");
			var i = 0;
			
			var addrowdata;
			if ( typeof t.customRowLayout == 'function' ){
				addrowdata = t.customAddRowData
			}else{
				addrowdata = t.addRowData
			}
			
			// 스크롤이생길때까지 tr생성
			while( true ){
				if( t.record > 0 && i == t.record ) break;
				if( !addrowdata.call(t, tbody , i++ )) break;
			}
			
			t.varForData.range 	= tbody.find('tr').length;
			t.boxForDom.$rows = tbody.find('tr');
			if( t.headerHidden ){
				t.toggleHeader('hide');
			}
//			tbody.find('tr:odd').addClass('g-row-odd-background');
//			tbody.find('tr:even').addClass('g-row-even-background');
			
			if( t.scroll ) {
				t.setScrollHeight();
			}else{
				t.boxForDom.$bodyWrap.css('overflow','auto');
			}
			
		}
		,customAddRowData:function( tbody , idx ){
			if( !this.data[idx] ) {
				tbody.append(  this.addBlankRow() );
				return false;
			}else{
				var row = this.customRowLayout( idx  ,this.data[idx] );
				var newTr = $("<tr></tr>").clone();
				newTr.attr('id',idx);
				if( $(row).children()[0].tagName != 'TD' ) row = "<td>"+row+"</td>";
				row = this.customMatchedReplace( row , this.data[idx] );
				newTr.append( $(row) );
				tbody.append(newTr);
				return true;
			}
		}
		,_matchedRegExp:/#[^#]+#/g
		,_replaceRegExp:/#/g
		,customMatchedReplace:function(str, data){
			var t = this;
			var matched = str.match(t._matchedRegExp);
			for(var i = 0 ,len=matched.length;i<len;i++){
				var key = matched[i].replace(t._replaceRegExp,'');
				str = str.replace(matched[i],data[key]);
			}
			return str;
		}
		/**
		 * 스크롤 높이 세팅
		 */
		,setScrollHeight : function(){
			var t = this;
			if( !t.data )t.data = [];
			
			var bodywrap = t.boxForDom.$bodyWrap[0];
			var scroll = t.boxForDom.$scroll_y[0];
			var body = t.boxForDom.$body[0];
			var data = t.data;
			var range = t.varForData.range;
			var scrollBtnSize = t.varForScroll.scrollBtnSize;
			var scrollBtnSizeX2 = scrollBtnSize *2;
			
			var totalScrollHeight = ( $(body).find('tr')[0].offsetHeight * data.length );
			var movingHeight = scroll.parentNode.offsetHeight - scrollBtnSizeX2;
			
			var scrollHeight = ( bodywrap.offsetHeight * movingHeight ) / body.offsetHeight;
			
			// ----------------new
			if( scrollHeight < 10 )  {
				scrollHeight = 10;
			}else if ( scrollHeight > movingHeight ) {
				scrollHeight = movingHeight;
			}
			
			var bottomArea = t.getOverWrap();
			if( scrollHeight == movingHeight){
				$(scroll).hide();
				t.boxForDom.$wrap.find(".g-scroll-area").hide();
				$(scroll).parent().find('.g-scroll-btn').addClass('off');
			}else{
				$(scroll).show();
				t.boxForDom.$wrap.find(".g-scroll-area").show();
				$(scroll).parent().find('.g-scroll-btn').addClass('on');
				scroll.style.height = scrollHeight+'px';
				scroll.style.top = scrollBtnSize + 'px';
			}
			// ----------------new
		}
		// ## grid2
		,wheelMovingY : function( movement ){
			var t 			= this
				,domBox 	= t.boxForDom
				,btnSize	= t.varForScroll.scrollBtnSize
				,btnSizeX2  = btnSize * 2 
				,validScrollArea = domBox.$scroll_y_wrap[0].offsetHeight - btnSizeX2;
			
			domBox.$bodyWrap[0].scrollTop += movement; //delta check
			
			var top 	= domBox.$bodyWrap[0].scrollTop
				,max 	= domBox.$bodyWrap[0].scrollHeight
				,per 	= ( top/max ) * 100
				,scrollMax = domBox.$scroll_y_wrap[0].offsetHeight - domBox.$scroll_y[0].offsetHeight - btnSizeX2
				,maxPer = ( scrollMax / validScrollArea ) * 100;
	
			if( per > maxPer ) per = maxPer;
			
			var topOfscroll = ( per / 100 ) * validScrollArea;
			domBox.$scroll_y[0].style.top = (topOfscroll + btnSize)+'px';
		}
		// ## grid2
		,scrollMovingY : function( pageY ){
			//error !! -- touch move 시 스크롤로 이동할때 맨 top 에서 안맞음;
			var domBox 			= this.boxForDom
				,scrollParent 	= domBox.$scroll_y_wrap[0]
				,scroll 		= domBox.$scroll_y[0]
				,bodyWrap		= domBox.$bodyWrap[0]
				,btnSize 		= this.varForScroll.scrollBtnSize
				,btnSizeX2 		= btnSize * 2 
				,validScrollArea = scrollParent.offsetHeight - btnSizeX2;
			
			if( ! this.varForScroll.y.scrollClickOffset ) 
					this.varForScroll.y.scrollClickOffset = scroll.offsetHeight/2;
			
			var scrollMax 		= scrollParent.offsetHeight - scroll.offsetHeight - btnSizeX2
				,scrollPos 		= pageY  - scrollParent.offsetTop - this.varForScroll.y.scrollClickOffset - btnSize
				,scrollMaxTop 	= ( scrollMax / validScrollArea ) * 100;
			
			if		( scrollPos < 0 		) scrollPos = 0;
			else if ( scrollPos > scrollMax ) scrollPos = scrollMax;
			
			var maxPer = ( scrollPos / scrollMax ) * 100;
			if( maxPer > scrollMaxTop ) maxPer = scrollMaxTop;
			
			var scrollTop = ( scrollPos + btnSize ) ;
			scroll.style.top = scrollTop + 'px';
	
			if( scrollPos < 10 ) scrollTop = scrollPos;
			var bodyScrollTop = ( scrollTop  / validScrollArea ) * bodyWrap.scrollHeight  ;
			bodyWrap.scrollTop = bodyScrollTop ;
			
		}
		
}// ## grid2

_grid1 = $.extend(_grid1,gridMethod,grid1);
_grid2 = $.extend(_grid2,gridMethod,grid2);

Grid.prototype = _grid1;
Grid2.prototype = _grid2;

function getEventOject( e ){
	if( e.originalEvent ){
		return e.originalEvent
	}else{
		return e
	}
}
function getWheelDelta (event){
    if (event.deltaY){
    	return event.deltaY;	
    } else if (event.wheelDelta){
        return  -1 * event.wheelDelta;
    } else {
        return -1 * ( event.detail * 40);
    }
}
});