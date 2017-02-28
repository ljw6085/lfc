/**
 * 주차장 관리관련 스크립트
 */
var svgUtils = {
		
		loadedSvgObjectInfo :{}
		,getSvgObjectInfo : function( cellType ){
			var t = this;
			if( t.loadedSvgObjectInfo[cellType] )  return t.loadedSvgObjectInfo[cellType];
			
			Common.ajaxJson(CONTEXT_PATH+"/prk/prk0002/selectSvgObjectInfo.do",{ cellType : cellType },function(data){
				t.loadedSvgObjectInfo[cellType] = data;
	    	},'post',false);
			
			return t.loadedSvgObjectInfo[cellType];
		}
		,chageTranslate : function( target , posArray ){
			  d3.select( target ).attr('transform','translate('+posArray[0]+','+posArray[1]+')');
			  $(target).data('trans',posArray);
		}
		,createShapeByType:function( pGroup, $option ){
			var t = this;
			switch ($option.cellType) {
				case 'P0':case 'P1':case 'P2':case 'P3':
					var option = t.getSvgObjectInfo( $option.cellType );
					$.extend(option, $option);
					return t.createRect( pGroup, option );
				case 'P4': // 나중에 엘레베이터는 t.createRect 를 따로 콜할수도 있으므로,,
					var option = t.getSvgObjectInfo( $option.cellType );
					$.extend(option, $option);
					return t.createRect( pGroup, option );
					break;
	
				default:
					break;
			}
		}
		,createRect : function( pGroup , $option ){
			var t = this;
			var option = {
					'class':'box'
					,'width':20
					,'height':30
					,'transform':'translate(0,0)'
			}
			if( typeof $option == 'object') $.extend( option , $option );
			var newG = pGroup.append('g') , rect = newG.append('rect');
			for( var k in option){ 
				rect.attr( k , option[k] ); 
				t.convertToJquery(rect).data(k,option[k]);
			}
			rect.call(
				d3.drag()
					.on("start", function(){
						t.snapStart( pGroup );
					})
					.on("drag", function(){
						t.snapDrag( this );
					})
			);
		
			return rect;
		}
		,round:function(p, n) {
			  return p % n < n / 2 ? p - (p % n) : p + n - (p % n);
		}
		/*
		 target을 기준으로 rect를 생성한다.	
		*/	
		,withTargetCreate:function( target , cellType ){
			var transform = $(target).attr('transform');
			var trns = this.getTranslate( transform );
			trns = [ trns[0] + this.snapResolution , trns[1] + this.snapResolution ];
			
			var option = {
					transform:'translate('+(trns[0])+','+(trns[1])+')'
			}
			if( cellType ){
				option.cellType = cellType;
				return this.createShapeByType( d3.select('.viewWrap') , option );
			}else{
				return this.createRect( d3.select('.viewWrap') , option );
			}
			
			
		}	
		/* d3 객체를 jquery 객체로 변환한다*/
		,convertToJquery:function ( d3Object ){
			return $(d3Object._groups[0][0])
		}	
		/* jquery 객체를 d3객체로 변환한다 */
		,convertToD3:function( jqueryObejct ){
			return d3.select( $(jqueryObject)[0] );
		}
		,getTranslate:function( transform ){
			var trns= [0.0,0.0,1];
			if( /translate\(\s*0\s*\)/g.test(transform)){ // ie 
				var tmp=[0,0];
				trns = transform.match(/[-]?[0-9.]+/g);
				if( typeof trns[1] != 'undefined') tmp.push( trns[1] );
				trns = tmp;
			}else if( transform ) {
				trns = transform.match(/[-]?[0-9.]+/g);
			}
			for( var i in trns) trns[i] = +trns[i];
			return trns;
		}
		,snapTarget		:	null
		,snapTargetList	:	$([])
		,snapResolution	:	10
		,snapGridWidth	:	0
		,snapGridHeight	:	0
		,snapStart:function( pGroup ){
			var utils = this,
				e = d3.event.sourceEvent,
				pressedCtrl = e.ctrlKey,
				$target = $(e.target);
			
			if( $target.hasClass('ui-selected') && pressedCtrl ){
				$target.removeClass('ui-selected');
			}else{
				$target.addClass('ui-selected');
			}

			utils.snapTarget = $target[0];
			utils.snapTargetList = utils.convertToJquery( pGroup ).find('.ui-selected');
		}
		,snapDrag: function ( target ) {
			var utils = this;
			if( !$(target).hasClass('ui-selected') ) return;
			var gp = utils.snapResolution / 2
				, evt = d3.event 
				, _t = target , t = $(_t)
				,x = evt.x , y = evt.y
				,w = +t.attr('width')
				,h = +t.attr('height')
				,gridX = utils.round(Math.min(utils.snapGridWidth, x), gp) - ( w / 2 )
				,gridY = utils.round(Math.min(utils.snapGridHeight, y), gp) - ( h / 2) ;

			  	gridX = Math.round( gridX / gp ) * gp ;
			  	gridY = Math.round( gridY / gp) * gp ;
			
			  	var tempTranslate 	= d3.select( target ).attr('transform') 
			  		,tempTrans 		= utils.getTranslate( tempTranslate )
			  		,newTrans 		= [ gridX , gridY ];
			  	utils.chageTranslate( target , newTrans );
				
			  	var diffTrans = [ newTrans[0] - tempTrans[0] , newTrans[1] - tempTrans[1] ];
				
			  	utils.snapTargetList.not( _t ).each(function(){
				  	var translate = d3.select( this ).attr('transform'); 
					var tr = utils.getTranslate( translate );
				  	tr[0] += diffTrans[0];
				  	tr[1] += diffTrans[1];
				  	utils.chageTranslate( this, tr );
			  });
		}
}

function ParkingManager( svg ){
	var t = this;
	t.svg = svg;
	t.$svg = svgUtils.convertToJquery(svg);
	t.$wrap = t.$svg.parent();
	
	t.width = +t.svg.attr('width');
	t.height = +t.svg.attr('height');
	
	
	svgUtils.snapGridWidth = t.width;
	svgUtils.snapGridHeight = t.height;
	t.zoomMin = 0.5
	t.zoomMax = 1;
	
	t.tempTransform = null;
	t.zoom = d3.zoom()
				.scaleExtent([t.zoomMin, t.zoomMax])
//				.translateExtent([[-50, -50], [t.width+50, t.height+50]])
				.on("zoom", function(){
					t.zoomed();
				})
				.on('start',function(){
					if( !d3.event.sourceEvent ) return;
//					d3.event.sourceEvent.stopPropagation();
					t.svgVar.isZoom = !d3.event.sourceEvent.ctrlKey 
					if( !t.svgVar.isZoom ){
						t.selectingDragStart();
						
						//zoom 이 아닐땐 현재위치를 기준으로 transform 세팅
						t.orgTransform = d3.event.transform;
						var trf = t.viewGroup.attr('transform');
						if( trf ){ 
							transform = trf.match(/[-]?[0-9.]+/g);
							t.orgTransform.x = transform[0]; 
							t.orgTransform.y = transform[1];
							t.orgTransform.k = transform[2];
						}
						
					}else{
						t.$viewGroup.find(".box.ui-selected").removeClass('ui-selected');
					}
				})
				.on("end", function(){
					t.svgVar.currentZoom = d3.event.transform.k;
					t.selectingDragEnd();
				});
	
	t.x = d3.scaleLinear()
//			.domain([-1, t.width + 1])
			.range([-1, t.width + 1]);

	t.y = d3.scaleLinear()
//			.domain([-1, t.height + 1])
			.range([-1, t.height + 1]);

	var tickCnt = 50;
	t.xAxis = d3.axisBottom(t.x)
				.ticks((t.width + 2) / (t.height + 2) * tickCnt)
				.tickSize(t.height)
//	 			.tickPadding(8 - t.height);

	t.yAxis = d3.axisRight(t.y)
				.ticks(tickCnt)
				.tickSize(t.width)
//	 			.tickPadding(8 - t.width);
	
	t.gX = t.svg.append("g")
			.attr("class", "axis axis--x")
			.call(t.xAxis);

	t.gY = t.svg.append("g")
			.attr("class", "axis axis--y")
			.call(t.yAxis);

	t.viewGroup = t.svg.append('g')
					.attr('class','viewWrap')
					.attr('transform','translate(0,0) scale(1)');
	
	t.viewSize = {width:1800, height:500}
	t.view = t.viewGroup.append("rect")
						.attr("class", "view")
						.attr('transform','translate(0,0)')
						.attr("x", 0.5)
						.attr("y", 0.5)
						.attr("width", t.viewSize.width )
						.attr("height", t.viewSize.height );
//	.attr("width", t.width - 1)
//	.attr("height", t.height - 1);

	
	
	t.svg.call(t.zoom);
	t.helper = t.svg.append('rect')
					.attr('class','selectHelper')
					.attr('transform',"translate(0,0)");
	$(t.helper._groups[0][0]).data({trans:[0.0,0.0]});
	
	t.$view = svgUtils.convertToJquery(t.view);
	t.$viewGroup = svgUtils.convertToJquery(t.viewGroup);
	
	t.svgSelectable={
			opos : []
			,helper: null
			,$helper:null
			,clicked : false
			,dragging : false
	}
	t.svgVar = {
			isZoom : false
			,ZOOM_MIN : 0.2
			,ZOOM_MAX : 10
			,curEvent:null
			,resolution : 10
			,currentZoom : 1
	}
	
	t.orgTransForm = null;
	
	t.minimap = new Minimap( t ).render( true );
	
	return t;
}

var MIN = {x: -900, y: -6},     //top-left corner
		MAX = {x: 0, y: 0};   //bottom-right corner
ParkingManager.prototype.zoomed = function( newScale ){
	var t = this;
	if( t.svgVar.isZoom ){
		if( t.orgTransform ){
			t.svg.transition().duration(0).call(t.zoom.transform, t.orgTransform);
			t.orgTransform = null
		}else{
			var transform = d3.event.transform;
			
			if (d3.event) {
                scale = d3.event.transform.k;
            } else {
                scale = newScale;
            }
			/*var widthGap = t.svg.attr('width') - t.$view[0].getBoundingClientRect().width;
			var heightGap = t.svg.attr('height') - t.$view[0].getBoundingClientRect().height;
			MIN.x = widthGap;
			MIN.y = heightGap;
			  transform.x = d3.max([transform.x, MIN.x]);
	          transform.y = d3.max([transform.y, MIN.y]);
	          transform.x = d3.min([transform.x, MAX.x]);
	          transform.y = d3.min([transform.y, MAX.y]);*/
	          
			t.viewGroup.attr("transform", transform); //real
			t.minimap.setScale( scale ).render();
//			t.gX.call( t.xAxis.scale(transform.rescaleX( t.x )));
//			t.gY.call( t.yAxis.scale(transform.rescaleY( t.y )));
		}
	}else{
		t.selectingDragging();
	}
}
ParkingManager.prototype.selectingDragStart = function(){
	var t = this;
	var event = d3.event.sourceEvent;
	var target = event.target;
	if(event && !event.ctrlKey ){
		t.$viewGroup.find(".box.ui-selected").removeClass('ui-selected');
		return;
	}
	if(!event.ctrlKey && !event.shiftKey) t.$viewGroup.find(".box.ui-selected").removeClass('ui-selected');
	
	t.svgSelectable.clicked = true;
	
	t.svgSelectable.opos[0] = event.pageX - t.$svg.offset().left;
	t.svgSelectable.opos[1] = event.pageY - t.$svg.offset().top;
	if( !t.svgSelectable.helper ){
		t.svgSelectable.helper = d3.select(".selectHelper");
		t.svgSelectable.$helper = $(".selectHelper");
	}
	var trn = t.svgSelectable.$helper.data('trans');
	trn[0] = t.svgSelectable.opos[0];
	trn[1] = t.svgSelectable.opos[1];
	var trns = "translate(" + trn[0]+","+trn[1] + ")";
	t.svgSelectable.helper.attr('transform',trns);
	t.svgSelectable.$helper.data('trans',trn);
	t.svg.style('cursor','crosshair');
}
ParkingManager.prototype.selectingDragging = function(){
	var t = this;
	var event = d3.event.sourceEvent;
	var target = t.$svg;
	if(event&& !event.ctrlKey ){
		t.svgSelectable.$helper.hide();
		t.svgSelectable.dragging = t.svgSelectable.clicked = false;
		return;
	}
	if (!t.svgSelectable.clicked ) return;
	
	var dragable  = event.ctrlKey && event.shiftKey;
	
	var scale = t.viewGroup.attr('transform');
	if( scale ){
		scale = scale.match(/scale(.+)/g)[0];
		scale = +scale.substring(6,scale.length-1);
	}else{
		scale = 1;
	}
	t.svgSelectable.dragging = true;
	var tmp,
		offset = target.offset(),
		x1 = t.svgSelectable.opos[0],
		y1 = t.svgSelectable.opos[1],
		x2 = event.pageX - offset.left,
		y2 = event.pageY - offset.top;
	
	if (x1 > x2) { tmp = x2; x2 = x1; x1 = tmp; }
	if (y1 > y2) { tmp = y2; y2 = y1; y1 = tmp; }
	var curTrns = t.svgSelectable.$helper.data('trans');
	curTrns[0] = x1;
	curTrns[1] = y1;
	var newTrns = "translate(" + curTrns[0] +','+curTrns[1]+ ")";
	t.svgSelectable.helper
		.attr('transform',newTrns)
		.attr('width', x2 - x1 )
		.attr('height', y2 - y1 );
	t.svgSelectable.$helper.data('trans',curTrns);
	t.svgSelectable.$helper.show();
	var selectableItem = t.$viewGroup.find(".box");
	for(var i = 0 ; i<selectableItem.length;i++){
		var $item 	= $( selectableItem[i] ) ,item = d3.select($item[0]);
		
		var	left 	= $( selectableItem[i] ).offset().left - t.$svg.offset().left//+curTrns[0] 
			,top 	= $( selectableItem[i] ).offset().top - t.$svg.offset().top//+curTrns[1] 
			,width 	= +item.attr('width') * scale
			,height = +item.attr('height') *scale
			,right 	= left + width 
			,bottom = top + height;
		//------ left,right,top,bottom --> 부모(g)태그의 scale을 곱해야함.
		var hit = ( !( left > x2 || right < x1 || top > y2 || bottom < y1) );
		
		if( hit ) {
			$item.addClass('ui-selected');
		}else{
			if( !dragable && $item.hasClass('ui-selected') ) $item.removeClass("ui-selected");
		}
	}
}

ParkingManager.prototype.selectingDragEnd = function(){
	var t = this;
	if( t.svgSelectable.dragging && t.svgSelectable.clicked ) t.svgSelectable.$helper.hide();
	t.svgSelectable.dragging = t.svgSelectable.clicked = false;
	t.svg.style('cursor','move');
}

//###################################################  새로운 svg에 append 하거나 다른 방법을 찾아보자.
function Minimap( parkingManager ){
	
	var t = this;
	t.svg 	= parkingManager.svg;
	t.target 	= parkingManager.viewGroup;
	
	t.minimapScale    = 0.15;
	t.scale           = 1;
	t.width           = parkingManager.width; // view 의 rect 과 크기가 같아야함 ( 아니면 svg wrap 크기)
	t.height          = parkingManager.height; // view 의 rect 과 크기가 같아야함(아니면 svg wrap 크기)
	t.x               = 0;
	t.y               = 0;
	t.frameX          = 0;
	t.frameY          = 0;
	
	
	var content = t.target.node().cloneNode(true);
	t.container = t.svg.append('g').attr("class", "minimap")
//								.call(parkingManager.zoom);
	
	parkingManager.zoom.on("zoom.minimap", function() {
		t.scale = d3.event.transform.k;
    });
	
	t.container.node().appendChild( content );
	
	t.frame = t.container
					.append("g")
					.attr("class", "frame")
			
	t.frame.append("rect")
	    .attr("class", "background")
	    .attr("width", t.width)
	    .attr("height", t.height)
//	    .attr("filter", "url(#minimapDropShadow_qwpyza)");
	
	t.drag = d3.drag()
        .on("start.minimap", function() {
            var frameTranslate = svgUtils.getTranslate( t.frame.attr("transform") );
            t.frameX = frameTranslate[0];
            t.frameY = frameTranslate[1];
        })
        .on("drag.minimap", function() {
            d3.event.sourceEvent.stopImmediatePropagation();
            t.frameX += d3.event.dx;
            t.frameY += d3.event.dy;
            t.frame.attr("transform", "translate(" + t.frameX + "," + t.frameY + ")");
            var translate =  [(-t.frameX*t.scale),(-t.frameY*t.scale)];
            t.target.attr("transform", "translate(" + translate + ")scale(" + t.scale + ")");
            var z = d3.zoomIdentity.translate(translate[0], translate[1]).scale(t.scale);
            t.svg.call(parkingManager.zoom.transform , z );
        });

	t.frame.call(t.drag);
	return this;
}
Minimap.prototype.render = function( isInit ){
	var t = this;
	var targetTransform = svgUtils.getTranslate( t.target.attr("transform"));
	
	t.scale = targetTransform[2];
	t.container.attr("transform", "translate(" + t.x + "," + t.y + ")scale(" + t.minimapScale + ")");
//    if ( isInit ){
	    var node = t.target.node().cloneNode(true);
	    t.container.select('.viewWrap').remove();
	    t.container.node().appendChild( node );
	    t.container.select('.viewWrap').attr("transform", "translate(1,1)");
//    }
    t.frame.attr("transform", "translate(" + (-targetTransform[0]/t.scale) + "," + (-targetTransform[1]/t.scale) + ")")
        .select(".background")
        .attr("width", t.width/t.scale)
        .attr("height", t.height/t.scale);
    
    t.frame.node().parentNode.appendChild( t.frame.node());
    d3.select(node).attr("transform", "translate(1,1)");
    return t;
}
Minimap.prototype.setScale = function(value) {
    if (!arguments.length) { return this.scale; }
    this.scale = value;
    return this;
};