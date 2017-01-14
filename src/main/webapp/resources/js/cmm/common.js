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
		createButton : function(option){
			
			var btnDefaultClassBox = [
				'ui-btn'
				,'ui-shadow'
				,'ui-corner-all'
				,'ui-btn-icon-notext'
				,'ui-btn-inline'
			];
			
			var $button = $("<a></a>")
				,icon = ( typeof option.icon == 'undefined' )? "": option.icon
				,href = ( typeof option.url == 'undefined' )? "#": option.url;
			
			var _opt = {
					"class": btnDefaultClassBox.join(' ') +" ui-icon-"+icon ,
					"href": href
			}
			$.extend(_opt, option);
			$button.attr(_opt);
			if( typeof option.text  == 'undefined'){
				$button.text( option.text );
			}
			return $button;
		}
}

/** 메뉴 관련 객체 */
var MENU = {
		
		ID_BOX : {
			menuPanelId : "menuPanel"
			,menuRootUlId : "menuList"
		}
		,createMenuButton : function( menuBtnId ){
			var _panId = this.ID_BOX.menuPanelId;
			//버튼생성
			var $menuBtn = $m.createButton({
				icon : "bars"
			});	
			//이벤트바인드
			$menuBtn.bind('click',function(){
				$( "#" + _panId ).panel("open");
			});
			//버튼append
			$( '#' + menuBtnId ).append( $menuBtn );
		}
		// 메뉴별 생성 - 메뉴속성을 만든다.
		,_createItem : function( o, item ){
			var $a = $("<a></a>")
							.text( o.menuNm )
							.attr('data-id',o.id);
			item.attr("data-id",o.id);
			item.append( $a );
			if( o.url ) $a.attr('data-url',o.url);
		}
		// 하위메뉴 트리 생성
		,_createChild : function( p , $ul ){
			var _t = this;
			for( var i =0 ; i < p.length; i++){
				var item = $("<li></li>").attr('data-icon','none')
					, o = p[i];
				
				_t._createItem( o , item );
				
				$ul.append( item );
				if( o.child.length > 0){
					item.attr("data-icon",'plus');
					// 서브메뉴설정
					var subMenu = $("<ul></ul>")
									.attr('data-role','listeview')
									.addClass("depth"+o.depth);
					item.append( subMenu );
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
							.attr('id', _t.ID_BOX.menuRootUlId )
							.addClass('ui-nodisc-icon ui-alt-icon');
			
			_t._createChild( rootObj, menu );
			
			// 메뉴 판넬 속성지정은 여기서한다. - jquery mobile 속성 적용
			$("#" + _t.ID_BOX.menuPanelId )
				.attr("data-role", "panel")
				.attr("data-position", "left")
				.attr("data-display", "overlay")
				.append(menu);
			
			// listview 적용
			$('ul').listview();
			
			//최초 숨김
			$('#'+ _t.ID_BOX.menuRootUlId + ' ul').css('display','none');

			//트리설정(뎁스별) - 추후에 정리
			$('ul.depth0').siblings("a").addClass('topMenu');
			$('ul.depth0 a').css('padding-left','2em');
			$('ul.depth1 a').css('padding-left','4em');
			
			// 클릭이벤트바인드
			$("#" + _t.ID_BOX.menuRootUlId ).bind('click', _t.menuClickCallback ); 
			// 메뉴판생성
			$("#" + _t.ID_BOX.menuPanelId ).panel(); // 메뉴판 생성
		}
		,menuClickCallback : function ( event ){
			var $target = $(event.target);
			
			$target
				.closest("li")
					.find("ul:eq(0)")
					.slideToggle('fast');

			if( !$target.hasClass("ui-icon-none") ){
				$target
					.toggleClass('ui-icon-minus',  !$target.hasClass('ui-icon-minus') )
					.toggleClass('ui-icon-plus',  !$target.hasClass('ui-icon-plus') );
			}
			//기타 클릭이벤트 - url 이동 등  - 테스트중 - get/post/ajax 추가해야함
			if( $target.attr("data-url"))
				location.href='/lfc' + $target.attr("data-url");
		}
}
