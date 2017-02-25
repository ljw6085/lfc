/**
 * 주차장 관리관련 스크립트
 */
var snapResolution =10
	,snapGridWidth=0
	,snapGridHeight=0
	,svgUtils = {
		chageTranslate : function( target , posArray ){
			  d3.select( target ).attr('transform','translate('+posArray[0]+','+posArray[1]+')');
			  $(target).data('trans',posArray);
		}
		,createRect : function( pGroup , $option ){
			var option = {
					'class':'box2'
					,'width':30	
					,'height':50
					,'transform':'translate(0,0)'
			}
			if( typeof $option == 'object') $.extend( option , $option );
		
			var newG = pGroup.append('g');
			var rect = newG.append('rect');
		
			for( var k in option){ rect.attr(k,option[k]); }
			rect.call(d3.drag().on("start", snapStart).on("drag", snapDrag));
		
			var trns = [ 0.0, 0.0 ];
			if( $option.trans ){ trns = $option.trans ; }
			$(rect._groups[0][0]).data({ trans: trns  });
			return rect;
		}
		,round:function(p, n) {
			  return p % n < n / 2 ? p - (p % n) : p + n - (p % n);
		}
		,snapTarget:null
		,snapTargetList:$([])
		/*
		 target을 기준으로 rect를 생성한다.	
		*/	
		,withTargetCreate:function( target ){
			var transform = $(target).attr('transform');
			var trns = this.getTranslate( transform );
			trns = [ trns[0] + snapResolution , trns[1] + snapResolution ];
			return this.createRect( d3.select('.viewWrap') ,{
				transform:'translate('+(trns[0])+','+(trns[1])+')'
				,trans : trns
			});
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
			var trns= [0.0,0.0];
			if( transform ) trns = transform.match(/[0-9.]+/g);
			trns[0] = +trns[0]; 
			trns[1] = +trns[1];
			return trns;
		}
}

function snapStart(){
	svgUtils.snapTarget = d3.event.sourceEvent.target;
	if( !$(svgUtils.snapTarget).hasClass('ui-selected') ){
		$(svgUtils.snapTarget).addClass('ui-selected');
	}else{
		if(d3.event.sourceEvent.ctrlKey){
			$(svgUtils.snapTarget).removeClass('ui-selected');
		}
	}	
	svgUtils.snapTargetList = $('.ui-selected');
}

function snapDrag() {
	 var gp = snapResolution/2
		, evt = d3.event , _t = this , t = $(_t)
		,x = evt.x , y = evt.y
		,w = +t.attr('width')
		,h = +t.attr('height')
		,gridX = svgUtils.round(Math.min(snapGridWidth, x), gp) - (w/2)
		,gridY = svgUtils.round(Math.min(snapGridHeight, y), gp) - (h/2) ;

	  	gridX = Math.round( gridX /gp ) * gp ;
	  	gridY = Math.round( gridY /gp) * gp ;
	
	  	//--------------------------------------------
	  	if( 0 > gridX ) gridX = 0;
	  	if( 0 > gridY) gridY = 0;
	  	if( snapGridWidth - w < gridX )	gridX = snapGridWidth-w;
	  	if( snapGridHeight - h < gridY )gridY = snapGridHeight-h;
	  	//-----------------------------------------------
	  	
	  	var tempTranslate =d3.select(this).attr('transform'); 
	  	var tempTrans = svgUtils.getTranslate( tempTranslate );
	  	var newTrans = [gridX,gridY];
	  	svgUtils.chageTranslate(_t, newTrans );
		var diffTrans = [newTrans[0]-tempTrans[0], newTrans[1]-tempTrans[1]];
		svgUtils.snapTargetList.not(_t).each(function(){
		  	var translate = d3.select(this).attr('transform'); 
			var tr = svgUtils.getTranslate( translate );
		  	tr[0] += diffTrans[0];
		  	tr[1] += diffTrans[1];
		  	svgUtils.chageTranslate( this, tr );
	  });
}
function getTouchType ( afterX , afterY , beforeX, beforeY ){
	var moveType = -1;
	var newX = Math.abs(beforeX - afterX);
	var newY = Math.abs(beforeY - afterY);
	var range = newX + newY;

	// 일정범위 이하로 움직이면 무시함
	if( range  < 25 ) return moveType;
	//화면 기울기			
	var hSlope = ((window.innerHeight/2) / window.innerWidth).toFixed(2)*2;

	//사용자의 터치 기울기
	var slope = parseFloat((newY/newX).toFixed(2),10);

	if( slope > hSlope ){//수직이동
		moveType = 1;	
	}else{// 수평이동
		moveType = 0;	
	}
	return moveType;
}


function ParkingManager( svg ){
	var t = this;
	t.svg = svg;
	t.$svg = svgUtils.convertToJquery(svg);
	t.$wrap = t.$svg.parent();
	t.width = +t.svg.attr('width');
	t.height = +t.svg.attr('height');
	
	snapGridWidth = t.width;
	snapGridHeight = t.height;
	
	t.zoom = d3.zoom()
				.scaleExtent([0.5, 2])
//				.translateExtent([[0, 0], [t.width, t.height]])
				.on("zoom", zoomed)
				.on('start',function(e){
					if( !d3.event.sourceEvent ) return;
					t.svgVar.isZoom = !d3.event.sourceEvent.ctrlKey 
					if( !t.svgVar.isZoom ){
						t.selectingDragStart();
						t.orgTransform = d3.event.transform
					}else{
						$(".box2.ui-selected").removeClass('ui-selected');
					}
				})
				.on("end", function(){
					t.svgVar.currentZoom = d3.event.transform.k;
					t.selectingDragEnd();
				});
	
	t.x = d3.scaleLinear()
			.domain([-1, t.width + 1])
			.range([-1, t.width + 1]);

	t.y = d3.scaleLinear()
			.domain([-1, t.height + 1])
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
					.attr('class','viewWrap');
	
	t.view = t.viewGroup.append("rect")
						.attr("class", "view")
						.attr('transform','translate(0,0)')
						.attr("x", 0.5)
						.attr("y", 0.5)
						.attr("width", t.width - 1)
						.attr("height", t.height - 1);

	
	
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
			,resolution : 20
			,currentZoom : 1
	}
	
	t.orgTransForm = null;
	function zoomed() {
		if( t.svgVar.isZoom ){
			if( t.orgTransform ){
				t.svg.transition().duration(0).call(t.zoom.transform, t.orgTransform);
				t.orgTransform = null
			}else{
				var transform = d3.event.transform;
				t.viewGroup.attr("transform", transform);
				t.gX.call( t.xAxis.scale(transform.rescaleX( t.x )));
				t.gY.call( t.yAxis.scale(transform.rescaleY( t.y )));
			}
		}else{
			t.selectingDragging();
		}
	}
	return t;
}

ParkingManager.prototype.selectingDragStart = function(){
	var t = this;
	var event = d3.event.sourceEvent;
	var target = event.target;
	if(event && !event.ctrlKey ){
		$(".box2.ui-selected").removeClass('ui-selected');
		return;
	}
	$(".box2.ui-selected").removeClass('ui-selected');
	
	t.svgSelectable.clicked = true;
	
	t.svgSelectable.opos[0] = event.pageX - t.$svg.offset().left 
	t.svgSelectable.opos[1] = event.pageY - t.$svg.offset().top
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
	var selectableItem = t.$svg.find(".box2");
	for(var i = 0 ; i<selectableItem.length;i++){
		var $item 	= $( selectableItem[i] ) ,item = d3.select($item[0]);
		var  curTrns = $item.data('trans');
		
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
			$item.data('selected',true);
		}else{
			if ( $item.data('selected') ) {
				$item.removeClass("ui-selected");
				$item.data('selected', false);
			}
		}
	}
}

ParkingManager.prototype.selectingDragEnd = function(){
	var t = this;
	if( t.svgSelectable.dragging && t.svgSelectable.clicked ) t.svgSelectable.$helper.hide();
	t.svgSelectable.dragging = t.svgSelectable.clicked = false;
}
