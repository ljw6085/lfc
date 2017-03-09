<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="<%=request.getContextPath()%>/resources/js/d3.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/prk/parking-manager.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/parking-css.css">
<script>
/** 
	화면이동이 필요할때, jsp를 따로 관리하고자 하면
	$j.documents 에 초기화 함수를 push 해야한다. 
*/
$j.documents.push(function(){
	/** Form 단위로 스크립팅 한다. */
	$j.documentReady('parkingMgrDetailForm', function($form,$uiPage){
		var frm = $form[0];
		MENU.createHeaderBackButton( $form.find('.header') );
		var backBtn = $form.find('.header').find('a');
		
		var svg = d3.select('#drawableArea');
		$j.pageMoveCallback(function(params){
			if( params ){
				$(window).trigger('resize');
				
				initLoadMap( params );
			}
		});
		
		$(window).bind('resize',function(){
			var body = $('body').height();
			var header = $('.header').outerHeight();
			var diff =  body - header ;
			var width = $('#svgArea').width();
			
			d3.select( $("#drawableArea")[0] )
					.attr('height', diff- 100 )
					.attr('width', width);
			
		}).trigger('resize');
		
		var draw;
		function initLoadMap( param ){
			svg.select('.viewWrap').remove();
			var url = "<c:url value='/prk/selectPrkData.do'/>";
			Common.ajaxJson( url , param ,function(res){
				var sizeInfo = res.sizeInfo;
				draw = new LoadParkingMap({
					svg:svg
					,viewSize:{
						width:sizeInfo.drwSizeWidth
						,height:sizeInfo.drwSizeHeight
					}
				});
				var target = d3.select('#drawableArea > .viewWrap');
				
				var data = res.list;
				var targetObject;
				for( var i =0, len = data.length; i < len ; i ++ ){
					var d  = data[i]  , applied = { readonly:true }
					for( var k in d ){
						switch (k) {
						case 'height':
						case 'width':
						case 'transform':
						case 'cellType':
							applied[k] = d[k];
							break;
						case 'styleCls':
							applied['class'] = d[k];
							break;
						case 'cellMapngId':
							applied['id'] = d[k];
							break;
						default:
							break;
						}
					}
					// target인경우 마지막에 append 하자
					if( applied.cellType == 'P3' ){
						targetObject = applied;
					}else{
						svgUtils.createShapeByType( target , applied );
					}
				}
				//마지막에 target create;
				svgUtils.createShapeByType( target , targetObject );
				
				targetAnimation();
				focusedCurrent();
			});
			
		}
		
		function focusedCurrent(){
			var w = d3.select('svg').attr('width')
					,h = d3.select('svg').attr('height')
					,curTrans = svgUtils.getTranslate( draw.viewGroup.attr('transform') )
					,scale = curTrans[2]
					,targetTrans = svgUtils.getTranslate(d3.select(".box.P3").attr('transform') )
					,tW = targetTrans[0] * scale
					,tH = targetTrans[1] * scale
					,resultW = w / 2 - tW
					,resultH = h / 2 - tH;
				
				var z = d3.zoomIdentity.translate(resultW, resultH).scale( scale );
				draw.svg
				        .transition()
						.duration(500)
						.ease(d3.easeLinear)
						.call(draw.zoom.transform , z );
		}
		
		function targetAnimation(){
			var target = d3.select(".box.P3");
			var loopCount = 0;
			var order = [1, -1];
			var range = 20;
			var delay = 500;
			// original transform setting
			$( target.node() ).data('originalTransform', target.attr('transform') );
			setInterval(function(){
				var w = +target.attr('width') 
					, h = +target.attr('height')
					, tr = svgUtils.getTranslate( target.attr('transform') ) 
					, num = ( order[ loopCount++%2 ] )
					, newW = w + ( num * range )
					, newH = h + ( num * range )
				target.transition()
				        .duration(delay)
				        .ease(d3.easeLinear)
				        .attr('width', newW )
				        .attr('height', newH )
				        .attr('transform','translate('+(tr[0] + (-num *(range/2)))+','+(tr[1] + (-num *(range/2))) +')' )
			}, delay+5 );
		}
	});
});
</script> 
<div data-role="page" id='parkingMgrDetail'><!-- second page start -->
	<form name='parkingMgrDetailForm'>
		<div class='header' data-role='header'><h1>주차장상세조회</h1></div>
		<div role='main' class='ui-content'>
			<div style='width:100%;text-align: center;margin:10px auto;' id='svgArea'>
				<svg id='drawableArea' class='parkplaceSVG'></svg>
			</div>
		</div>
	</form>
</div>