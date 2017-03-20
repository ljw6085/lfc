/**
 * @Description : common js.
 * @Modification Information
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2017.01.08		이종욱          	최초 생성
 *  @namespace 
 *  @author 이종욱
 *  @since 2017.01.08
 *  @version 1.0
 */
$(function(){
	$.mobile.page.prototype.initSelector = "div.main_content";	
});
/**
 * 공통 namespace
 */
var Common = {
		/**
		 * 파라미터로 넘어온 값의 type을 반환한다.
		 */
		type : function( o ){
			//출처 : http://youmightnotneedjquery.com/
			return Object.prototype.toString.call( o ).replace(/^\[object (.+)\]$/, '$1').toLowerCase();
		},
		/**
		 * Form 객체를 찾아서 반환한다. 실패시 NULL 반환
		 * @param frm - form 객체 또는 ID 또는 NAME 값
		 */
		getForm : function( frm ){
			var _frm;
			switch ( this.type( frm ) ) {
				case 'string':
					if( document.getElementsByName( frm ).length > 0 ){
						_frm = document.getElementsByName( frm )[0];
					}else if ( document.getElementById( frm ) ){
						_frm = document.getElementById( frm );
					}else{
						return null;
					}
					
					break;
				case 'htmlcollection':
					if( frm.tagName == 'FORM' ) _frm = frm;
					break;
					
				case 'object':
					if ( frm.jquery && frm.is('form') ) _frm = frm;
					else return null;
					break;
	
				default:
					return null;
					break;
			}
			return $(_frm);
		},
		/**
		 * jquery ajax이용 - json용
		 * @param url - ajax 호출 URL
		 * @param data - 파라미터로넘길Data 또는 form(객체 or id or name)
		 * @param callback - 콜백함수
		 * @param async - 비동기/동기
		 */
		ajaxJson : function( url , data , callback, method, async ){
			// controller 단에서 VO 형태로 파라미터를 받을경우, @requestbody로 받아야함.
			// 또한 ajax 전송시 stringify로 파싱하여 전송
			var option = {
					url		 	: url
					,contentType :'application/json; charset=UTF-8'
					,dataType	: 'json'
					,method		: 'post'
					,success : callback
					,async:true
					,error: function(a,b,c){
						console.log( a, b, c );
					}
			}
			
			if( method ) option.method = method;
			if ( async 		=== false ) option.async =  false
			if ( data ){
				var dt = {};
				if( ( frm = formLib.getForm( data )) ){
					// 추후에 FORM도 받아서 전송하도록 만들자
					var param = $(frm).serializeArray();
					for ( var i =0 ,len=param.length;i<len;i++ ) {
						var o = param[i];
						dt[o.name]=o.value;
					}
				}else{
					dt = data;
				}
				option.data = JSON.stringify( dt );
			}
			$.ajax( option );
		}
		
		,loadedCodeList : {}
		/**
		 * 공통코드를 조회하여반환한다.
		 */
		,getCommonCode:function( parentCode ){
			var result,t = this;
			if( !this.loadedCodeList[parentCode] ){
				Common.ajaxJson(CONTEXT_PATH+"/getCommonCode.do",{ parentCode:parentCode },function(data){
					t.loadedCodeList[parentCode] = data;
		    	},'post',false);
			}
			result = this.loadedCodeList[parentCode] ; 
			return result;
		}
		
		,_matchedRegExp:/%{[^}]+}/g
		,_replaceRegExp:/[%{}]/g
		/**
		 *  _matchedRexExp ( #...# ) 형식에 맞는 문자열을 치환시킨다.
		 */
		,matchedReplace:function(str, data){
			var t = this;
			var matched = str.match(t._matchedRegExp);
			for(var i = 0 ,len=matched.length;i<len;i++){
				var key = matched[i].replace(t._replaceRegExp,'');
				var replaceVal = data[key];
				if( typeof replaceVal == 'undefined' || null == replaceVal ) replaceVal = '';
				str = str.replace(matched[i],replaceVal);
			}
			return str;
		}
		
		/**
		 *  target 에있는 객체들의 값을 obejct로 반환한다.
		 *  ( input , textarea )
		 */
		,getDataFromDoms:function( $target ){
			var result = {};
			$target.find('input,select').each(function(){
				var name = this.name;
				var value;
				if( this.tagName == 'SELECT'){
					value = $(this).find("option:selected").val();
				}else{
					switch (this.type) {
					case 'radio':
					case 'checkbox':
						if( this.checked ) value = this.value;
						break;
						
					default:
						value = this.value;
						break;
					}
				}
				if( typeof value != 'undefined' ) result[name] = value;
			});
			return result;
		}
};

/**
 * Jquery Mobile관련 객체
 */
var $m = {
		/** 버튼을 생성한다. 추후에 option을 더 추가시켜서 사용. */
		createIconButton : function( option, click){
			
			var btnDefaultClassBox = [
				'ui-btn'
				,'ui-shadow'
				,'ui-corner-all'
				,'ui-btn-icon-notext'
				,'ui-btn-inline'
			];
			if ( option.header ) btnDefaultClassBox.push( 'ui-btn-'+option.header);
			var $button = $("<a></a>")
				,icon = ( typeof option.icon == 'undefined' )? "": option.icon
				,href = ( typeof option.url == 'undefined' )? "#": option.url;
			
			var _opt = {
					"class": btnDefaultClassBox.join(' ') +" ui-icon-"+icon ,
					"href": href
			}
			
			
			
			$.extend(_opt, option);
			$button.attr(_opt);
			if( typeof option.text  == 'undefined') $button.text( option.text );
			if( typeof click == 'function' ) $button.bind('click',click);
			
			return $button;
		}
		/**
		 * button을 세팅한다. option을 넘겨 원하는 버튼을 생성할 수 있다.
		 * @param target : 버튼이 생성될 a, button 객체
		 * @param option : 버튼생성옵션
		 * { icon:'delete'
			 ,iconPosition:'left'
			 ,mini:true
			 ,inline:true
			 ,notext:true
			 ,corner:true
			 ,shadow:true }
		 */
		,setButton:function( target, option ){
			var $t = $(target);
			if( $t.is('a') || $t.is('button') ){
				$t.each(function(){
					var _t = $(this);
					if( _t.attr('data-is-apply') != 'true' ){
						var classes = ['ui-btn'];
						for( var attr in option ){
							var value = option[attr];
							switch (attr) {
							case 'mini':
								if(value === true) classes.push( 'ui-mini' );
								break;
							case 'inline':
								if(value === true) classes.push( 'ui-btn-inline' );
								break;
							case 'icon':
								classes.push( 'ui-icon-'+value );
								break;
							case 'iconPosition':
								classes.push( 'ui-btn-icon-'+value );
								break;
							case 'notext':
								if(value === true) classes.push( 'ui-btn-icon-notext');
								break;
							case 'header':
								classes.push( 'ui-btn-'+value);
								break;
							}
						}
						if( option ){
							if( option.corner !== false ) classes.push('ui-corner-all');
							if( option.shadow !== false ) classes.push('ui-shadow');
							if( !option.iconPosition &&  !option.notext && _t.attr('data-icon')) classes.push( 'ui-btn-icon-left');
						}
						
						if( (icon = _t.attr('data-icon')) ) {
							classes.push('ui-icon-'+icon);
						}
						if( (color = _t.attr('data-color')) ) {
							classes.push('ui-btn-color-'+color);
						}
						var cls = classes.join(' ');
						if( _t.attr('data-full') ) cls = cls.replace('ui-btn-inline','');
						_t.removeClass('ui-link');
						_t.addClass(cls);
						_t.attr("data-is-apply",true);
					}
				}).trigger('refresh');
			}
		}
		,setControlGroup:function( target, isHorizontal ){
			var $target = $(target);
			$target.each(function(){
				var _t = $(this);
				if( _t.attr('data-is-apply') != 'true' ){
					var attr = { 'data-role':'controlgroup' ,'data-mini':'true'}
					if( isHorizontal ) attr['data-type'] = 'horizontal'
					_t.attr( attr );
					_t.attr("data-is-apply",true);
				}
			});
		}
		,setIcon:function(target , option){
			var $target = $(target);
			$target.each(function(){
				var _t = $(this);
				if( _t.attr('data-is-apply') != 'true' ){
					var btnDefaultClassBox = [
						'ui-btn'
						,'ui-mini'
						,'ui-shadow'
						,'ui-corner-all'
						,'ui-btn-icon-notext'
						,'ui-btn-inline'
					];
					if( (icon = _t.attr('data-icon')) ) {
						btnDefaultClassBox.push('ui-icon-'+icon);
					}
					if( (color = _t.attr('data-color')) ) {
						btnDefaultClassBox.push('ui-btn-color-'+color);
					}
					_t.addClass( btnDefaultClassBox.join(' ') );
					_t.attr("data-is-apply",true);
				}
			});
		}
		,table:{
			createHeader:function( headData ){
				var head = $("<thead></thead>");
				for( var i =0, len = headData.length; i < len ; i++){
					var $th = $("<th></th>");
					var o = headData[i];
					for ( var attr in o ){
						var val = o[attr];
						var attrKey='';
						switch ( attr ) {
							case 'colId':
								attrKey='data-col-id';
								break;
							case 'colName':
								attrKey='data-col-name';
								$th.append($('<div>'+val+'</div>'));
								$th.text( val );
								break;
							case 'priority':
								if( val ){
									attrKey='data-priority';
									$th.addClass('ui-table-priority-'+val);
								}
								break;
						}
						if( attrKey ) $th.attr(attrKey,val);
					}
					$th.attr('data-colstart',(i+1));
					//data-priority data-colstart ui-table-priority-2
					head.append( $th );
				}
				
				return head;
			}
			,createBody :function( header, data ){
				var tbody = $("<tbody></tbody>");
				for( var i=0, len=data.length;i<len;i++){
					var $tr = $("<tr></tr>");
					var o = data[i];
					for( var k=0,kLen=header.length;k<kLen;k++){
						var $td = $("<td></td>");
						var h = header[k];
						var colId = h.colId;
						var value = o[h.colId];
						if( h.priority ){
							$td.addClass('ui-table-priority-'+h.priority);
						}
						$td.attr('data-col-id', colId );
//						$td.append('<b class="ui-table-cell-label">'+h.colName+'</b>');
						$td.append("<b>"+value+"</b>");
						$tr.append($td);
					}
					tbody.append($tr);
				}
				return tbody;
			}
		}
		,setTable : function ( wrapTarget , option ){
			var $wrap= $(wrapTarget);
			var $target;
			option = option || {};
			if( $wrap.find('table')[0] ){
				$target = $wrap.find('table');
			}else{
				var $target=$('<table></table>');
				var header = this.table.createHeader( option.header );
				var body = this.table.createBody( option.header , option.data );
				$target.append( header ).append( body );
				$wrap.append( $target );
			}

			var classes =['table-stripe', 'ui-responsive', 'table-stroke'];
			var _option = {
					'data-role':'table'
					,'data-mode':'reflow'
					,'data-column-btn-text':'컬럼선택'
			}
			if ( option.toggle ) _option['data-mode'] = 'columntoggle'; 

			$target.addClass( classes.join(' '));
			$target.attr(_option);
			
			$target.table({
				create:function(event,ui){
					$(".ui-table-columntoggle-btn").hide();	
					if( typeof option.create == 'function') option.create( event, ui );
				}
			});

			return $target;
		}
		
		/**
		 * => 방향으로swipe 시 메뉴(헤더버튼) 클릭
		 */
		,openMenuFromSwipe :function( $uiPage ){
			$uiPage.on('swiperight',function(e){
				$(this).find('.header').find('a').trigger('click');
			});
		}
		,callPopup:function( option ){
		}
}
/** 메뉴 관련 객체 */
var MENU = {
		LIST:[]
		,DATA:[]
		,TREE:null
		,ID_BOX : {
			menuPanelId : "menuPanel"
			,menuRootUlId : "menuList"
		}
		,DOM_BOX:{
			$menuPanel:null
			,$menuUlRoot:null
		}
		,init : function(){
			this.DOM_BOX.$menuPanel = $( "#" + this.ID_BOX.menuPanelId );  
			this.DOM_BOX.$menuUlRoot = $( "#" + this.ID_BOX.menuRootUlId );  
		}
		,get$:function(object){
        	var _result ;
			switch (dataLib.type( object )) {
				case 'string':
					if( $("#"+object)[0] ){
						_result = $("#"+object);
					}else if( $("." + object)[0] ){
						_result = $("."+object);
					}else{
						_result = null;
					}
					break;
					
				case 'object':
					_result = dataLib.isEmpty( object.jquery ) ? $(object) : object;
					break;
				
				default:
					_result = null;
					break;
			}
			if( !_result ) return null;
			return _result;
		}
		,createHeaderBackButton:function( wrapper ){
			MENU.createHeaderButton({
				wrapper : wrapper
				,attr:{
					rel:"back"
				}
				,icon:'carat-l'
			});
		}
		/**
		 * 헤더에 아이콘을 생성/append
		 */
		,createHeaderButton : function( option ){
			var t = this;
			var target = option.wrapper;
			var position = ( option.position )?option.position:'left';
			var icon = (option.icon )? option.icon : 'bars';
			var click = (typeof option.click == 'function')? option.click : (function(){});
			var attr = (option.attr)?option.attr:{};
			//버튼생성
			var $menuBtn = $m.createIconButton({
				icon : icon
				,header : position
			},click);	
			for( var nm in attr ) $menuBtn.attr('data-'+nm,attr[nm]);
			$menuBtn.addClass('menu-header-btn');//.removeClass('ui-shadow');
			target = this.get$(target);
			//버튼append
			target.append( $menuBtn );
			
		},createMenuButton : function( menuBtnId , icon ){
			var t = this;
			icon = (typeof icon == 'string')?icon:'bars';
			//버튼생성
			var $menuBtn = $m.createIconButton({
				icon : icon
				,header:'left'
			},function(){
				$("#" + t.ID_BOX.menuPanelId).panel("open");
			});	
			$menuBtn.addClass('menu-header-btn');//.removeClass('ui-shadow');
			
			var target = this.get$(menuBtnId);
			//버튼append
			target.append( $menuBtn );
		}
		// 메뉴별 생성 - 메뉴속성을 만든다.
		,_createItem : function( o, item ){
			var $a = $("<a></a>")
							.text( o.menuNm )
							.attr('data-id',o.menuId);
			item.attr("data-id",o.menuId);
			item.attr("data-menu-nm",o.menuNm)
			item.append( $a );
			if( o.menuUrl ) $a.attr('data-url',o.menuUrl);
			if( o.menuIcon ) $a.addClass('ui-icon-'+ o.menuIcon);
			
			this._compareCurrentUrl( item, o.menuUrl );
			
			// depth 
			$a.prepend( this._createTab( o.depth ));
		}
		,_compareCurrentUrl:function( item, url ){
			
			if( this._getPageId(CONTEXT_PATH + url) ==  this._getPageId(location.pathname)){
				item.addClass('currentMenu');
			}
		}
		,_getPageId:function(url){
			return url.substring(0, url.lastIndexOf("/"));
		}
		,_createTab : function ( depth ){
			var blank = $("<div></div>").css({
				display:'inline-block',
				width: (depth * 10) 
			});
			return blank;
		}
		// 하위메뉴 트리 생성
		,_createChild : function( p , $ul ){
			var _t = this;
			for( var i =0 ; i < p.length; i++){
				var item = $("<li></li>")//.attr('data-icon','none')
					, o = p[i];
				
				_t._createItem( o , item );
				$ul.append( item );
				if( o.child.length > 0){ // 자식들이 존재하면
					// 서브메뉴설정
					var subMenu = $("<ul></ul>")
									.attr('data-role','listeview')
									.addClass("depth"+o.depth);
					item.append( subMenu );
					item.attr('data-icon','carat-d');
					//재귀호출-컨텍스트 유지
					arguments.callee.call( _t , o.child , subMenu );
				}
			}
		}
		,createMenu : function ( data ){
			var _t = this;
			// 트리데이터 생성
			var tree = dataLib.treeData( data ,{parentId:'menuPid',id:'menuId'});
			// 트리데이터로 메뉴 생성
			var rootObj = tree.data.child;
			this.LIST = data; 
			this.DATA = rootObj; 
			this.TREE = tree;
			//root Menu 생성
			var menu = $("<ul></ul>")
							.attr("data-role","listview")
							.attr('id', _t.ID_BOX.menuRootUlId );
			
			_t._createChild( rootObj, menu );
			
			// 메뉴 append
			_t.DOM_BOX.$menuPanel
				.append(menu) // ul append
					.panel() // panel 생성
						.find('ul').listview(); // listview 생성 
						
			//최초 숨김
			menu.find('ul').hide();
			
			//현재메뉴 선택
			var pr = menu.find(".currentMenu");
			var menuNavi = "";
			while( pr[0] ){
				if( pr[0].tagName == 'UL' ){ pr.show(); }
				else if( pr.attr('data-menu-nm') ){
					menuNavi = menuNavi +"&gt;" + pr.attr('data-menu-nm') 
				}
				pr = pr.parent();
			}
			$("#menuNavigator").html( "Home"+menuNavi);
			//트리설정(뎁스별) - 추후에 정리
			$('ul.depth0').siblings("a").addClass('topMenu');
			
			// 클릭이벤트바인드
			menu.bind('click', _t.menuClickCallback ); 

		}
		,menuClickCallback : function ( event ){
			var $target = $(event.target);
			
			var $child = $target.next('ul');
			if( $child[0] ) $child.slideToggle('fast');
			
			//기타 클릭이벤트 - url 이동 등  - 테스트중 - get/post/ajax 추가해야함
			if( $target.attr("data-url")){
				$.mobile.loading('show');
				setTimeout(function(){
					location.href = CONTEXT_PATH+$target.attr("data-url");
				}, 300);
			}
		}
}
var $j = {
		
		$page : function(){
			return $( ":mobile-pagecontainer" );
		}
		,refreshPage : function( $form ){
			$m.setIcon($('.btnIcon'));
			$m.setButton($('.btn'),{
				mini:true
				,inline:true
			});
			$m.setControlGroup($(".buttonBox"),true);
			
			this.$page().trigger('create');
			
			if( $form ) formLib.setValidation( $form );
		}
		,documents :[]
		,initDocument : function(){
			for( var i = 0 ,len = this.documents.length; i < len ;i ++){
				this.documents[i].call(document);
			}
			this.documents = [];
		}
		,documentReady : function(form , callback){
			$(document).ready(function(){
				var frm = formLib.getForm(form);
				var uiPage = $(frm).closest("[data-role='page']");
				callback($(frm),uiPage);
			});
		}
		,isMobile:function(){
			var filter = "win16|win32|win64|mac";
			if(navigator.platform){
				if(0 > filter.indexOf(navigator.platform.toLowerCase())){
					return true;
				}else{
					return false;
				}
			}

		}
		,pageMove:function( url , params ){
			var option = {
					transition: "slide"
			};
			if( params ) {
				option.params = {}
				$.extend(option.params, params);
			}
//			this.$page().jqmData("params",params);
			this.$page().pagecontainer( "change", url , option);
		}
		,pageMoveCallback :function( callback ){
			var t = this;
			if( typeof callback == 'function' ){
//				this.$page().on('pagebeforeshow',function(event,ui){
//					callback( t.$page().jqmData('params') );
//				});
				this.$page().pagecontainer({
//					 page change 콜백함수.
					change:function(event,ui){
						callback(ui.options.params);
					}
				});// page move
			}
		}
}
var COMPONENT ={
		
		_radio_check:function(  type , option ,$form ){
			var name 	 = option.name;
			var cmmnCode = option.cmmnCode;
			var appendTo = option.appendTo;
			var target 	 = option.target;
			var classes  = option.classes;
			var defaultVal = option.defaultVal;
			
			var controllgroup = $("<div data-role='controlgroup' data-type='horizontal' data-mini='true'></div>");
			if( appendTo ){
				target[appendTo](controllgroup)
			}else{
				target.append( controllgroup );
			}
			
			controllgroup.controlgroup();
			
			var codeMap;
			if( typeof cmmnCode == 'string' ){
				codeMap = Common.getCommonCode( cmmnCode );
			}else{
				codeMap = cmmnCode;
			}
			
			var i=0;
			for( var code in codeMap ){
				var value = codeMap[code];
				var id = name+"_"+code;
				$el = $( "<label for='"+id+"'>" + value + "</label><input type='"+  type  +"' name='"+ name +"' id='"+id+"' value='"+code+"'></input>" );
				
				if( (typeof defaultVal != 'undefined' && code == defaultVal) || (typeof defaultVal == 'undefined' && i++ == 0 ) ) {
					$el[1].checked = true;
				}
				
				if( classes ) $($el[1]).addClass( classes );
				
				controllgroup.controlgroup( "container" ).append( $el );
				$( $el[ 1 ] ).checkboxradio();
			}
			$j.refreshPage( $form );
			return controllgroup;
		}
		/**
		 * http://demos.jquerymobile.com/1.4.5/controlgroup-dynamic/ -- 생성정보 참조
		 * radio 버튼을 생성해준다.
		 *  {
		 *  name : input태그 name
			cmmnCode : 생성할 공통코드
			target  : 생성된 태그를 append할 타겟
			classes : 생성된 태그에 적용시킬 클래스
			}
		 */
		,radio:function( option ,$form ){
			return this._radio_check(  'radio' , option  , $form);
		},
		select:function(option){
			var name 	 = option.name;
			var appendTo = option.appendTo;
			var cmmnCode = option.cmmnCode;
			var target 	 = option.target;
			var classes  = option.classes;
			var defaultVal = option.defaultVal;
			var codeMap;
			if( typeof cmmnCode == 'string' ){
				codeMap = Common.getCommonCode( cmmnCode );
			}else{
				codeMap = cmmnCode;
			}
			var select = $("<select name='"+name+"' data-native-menu='false' data-iconpos='left' data-mini='true'></select>");
			if( appendTo ){
				target[appendTo](select)
			}else{
				target.append( select );
			}
			
			var i=0;
			for( var code in codeMap ){
				var value = codeMap[code];
				var $el = $( "<option value='"+  code  +"'>"+value+"</option>" );
				
				if( (typeof defaultVal != 'undefined' && code == defaultVal) || (typeof defaultVal == 'undefined' && i++ == 0 ) ) {
					$el[0].selected = true;
				}
				
				if( classes ) $($el).addClass( classes );
				
				select.append( $el );
			}
			select.selectmenu();
			$j.refreshPage();
		},
		/**
		 * checkbox 버튼을 생성해준다.
		 *  {
		 *  name : input태그 name
			cmmnCode : 생성할 공통코드
			target  : 생성된 태그를 append할 타겟
			classes : 생성된 태그에 적용시킬 클래스
			}
		 */
		checkbox:function( option , $form ){
			return this._radio_check(  'checkbox' ,option   ,$form);
		},
		flipSwtich:function(option){
			
		}
}
$.fn.setAttr = function(key , value){
	if( typeof key == 'string' && typeof value != 'undefined'){
		$(this).attr(key, value);
		if( key.indexOf('data-') == 0){
			var dataKey = strLib.toCamelCase(key.substring(5));
			$(this).data(dataKey,value);
		}
	}
}
$.fn.toggleCls = function( cls1 , cls2  ){
	var $t = $(this);
	if( $t.hasClass( cls1 ) ){
		
		$t.removeClass( cls1 );
		if( cls2 ) $t.addClass( cls2 );
		
	}else{
		
		if( cls2 && $t.hasClass( cls2 ) ) $t.removeClass( cls2 );
		$t.addClass( cls1 );
	}
	return $t;
}