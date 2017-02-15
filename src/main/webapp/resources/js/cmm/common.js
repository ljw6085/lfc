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
		ajaxJson : function( url , data , callback, async ){
			
			var option = {
					url		 	: url
					,contentType :'application/json; charset=UTF-8'
					,dataType	: 'json'
					,method		: 'post'
					,success : callback
					,error: function(a,b,c){
						console.log( a, b, c );
					}
			}
			if ( async 		=== false ) option.async =  false
			if ( data ){
				var dt = {};
				if( ( frm = this.getForm( data )) ){
					// 추후에 FORM도 받아서 전송하도록 만들자
					var param = frm.serializeArray();
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
						if( !option.iconPosition &&  !option.notext) classes.push( 'ui-btn-icon-left');
					}
					if( (icon = _t.attr('data-icon')) ) {
						classes.push('ui-icon-'+icon);
					}
					_t.removeClass('ui-link');
					_t.addClass(classes.join(' '));
				}).trigger('refresh');
			}
		}
		,setControlGroup:function( target, isHorizontal ){
			var $target = $(target);	
			var attr = { 'data-role':'controlgroup' }
			if( isHorizontal ) attr['data-type'] = 'horizontal'
			$target.attr( attr );
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
				console.log( header );
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
				console.log( $target );
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
}
/** 메뉴 관련 객체 */
var MENU = {
		
		ID_BOX : {
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
		,createMenuButton : function( menuBtnId , icon ){
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
			//버튼append
			$( '#' + menuBtnId ).append( $menuBtn );
		}
		// 메뉴별 생성 - 메뉴속성을 만든다.
		,_createItem : function( o, item ){
			var $a = $("<a></a>")
							.text( o.menuNm )
							.attr('data-id',o.id);
			item.attr("data-id",o.id);
			item.attr("data-menu-nm",o.menuNm)
			item.append( $a );
			if( o.url ) $a.attr('data-url',o.url);
			if( o.icon ) $a.addClass('ui-icon-'+ o.icon);
			
			this._compareCurrentUrl( item, o.url );
			
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
			var tree = dataLib.treeData( data );

			// 트리데이터로 메뉴 생성
			var rootObj = tree.data.child;

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
