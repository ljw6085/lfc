/**
 * Event 관련 Utiltiy<br/>
 * [출처 : 「프론트엔드 개발자를위한 자바스크립트 프록래밍 - 니콜라스자카스 저」]
 * @class [Class] 이벤트 관련 유틸리티 클래스
 */
var EventUtil = {
	listener :{},
	/**
	 * Event Handler 등록.
	 * @param {Object} element : Event 대상
	 * @param {String} type : Event 종류
	 * @param {Function} handler : 이벤트 함수
	 */
    addHandler: function(element, type, handler){
        if (element.addEventListener){
        	element.addEventListener(type, handler, false);
        } else if (element.attachEvent){
            element.attachEvent("on" + type, handler);
        } else {
            element["on" + type] = handler;
        }
    },
    /**
     * 이벤트에서 발생한 char(key) code 값을 반환.
     * @param {Object} event : 발생 이벤트 객체
     * @returns {Number} code : 코드값
     */
    getCharCode: function(event){
        if (typeof event.charCode == "number"){
            return event.charCode;
        } else {
            return event.keyCode;
        }
    },
    /**
     * 클립보드에 저장되어있는 텍스트를 가져옴. (ie)
     * @param {Object} event : 이벤트 객체
     * @returns {String} 
     */
    getClipboardText: function(event){
        var clipboardData =  (event.clipboardData || window.clipboardData);
        if(clipboardData && clipboardData.getData) return clipboardData.getData("text");
        else null;
    },
    /**
     * Event 객체를 가져옴.
     * @param {Object} event : 이벤트객체
     * @returns {Object} event
     */
    getEvent: function(event){
        return event ? event : window.event;
    },
    
    getRelatedTarget: function(event){
        if (event.relatedTarget){
            return event.relatedTarget;
        } else if (event.toElement){
            return event.toElement;
        } else if (event.fromElement){
            return event.fromElement;
        } else {
            return null;
        }
    
    },
    
    getTarget: function(event){
        return event.target || event.srcElement;
    },
    
    getWheelDelta: function(event){
        if (event.wheelDelta){
            return (client.engine.opera && client.engine.opera < 9.5 ? -event.wheelDelta : event.wheelDelta);
        } else {
            return -event.detail * 40;
        }
    },
    
    preventDefault: function(event){
        if (event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        }
    },

    removeHandler: function(element, type, handler){
        if (element.removeEventListener){
            element.removeEventListener(type, handler, false);
        } else if (element.detachEvent){
            element.detachEvent("on" + type, handler);
        } else {
            element["on" + type] = null;
        }
    },
    
    setClipboardText: function(event, value){
        if (event.clipboardData){
            event.clipboardData.setData("text/plain", value);
        } else if (window.clipboardData){
            window.clipboardData.setData("text", value);
        }
    },
    
    stopPropagation: function(event){
        if (event.stopPropagation){
            event.stopPropagation();
        } else {
            event.cancelBubble = true;
        }
    }

};
/**
 * @Description : form lib.
 * @Modification Information
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2016.05.09		이종욱          	최초 생성
 *  @namespace [Library] form 관련 라이브러리
 *  @author 유채널(주) 개발팀 이종욱
 *  @since 2016.05.09
 *  @version 1.0
 */
var formLib = {
		KEY_MAP : [
           "", // [0]
           "", // [1]
           "", // [2]
           "CANCEL", // [3]
           "", // [4]
           "", // [5]
           "HELP", // [6]
           "", // [7]
           "BACK_SPACE", // [8]
           "TAB", // [9]
           "", // [10]
           "", // [11]
           "CLEAR", // [12]
           "ENTER", // [13]
           "ENTER_SPECIAL", // [14]
           "", // [15]
           "SHIFT", // [16]
           "CONTROL", // [17]
           "ALT", // [18]
           "PAUSE", // [19]
           "CAPS_LOCK", // [20]
           "KANA", // [21]
           "EISU", // [22]
           "JUNJA", // [23]
           "FINAL", // [24]
           "HANJA", // [25]
           "", // [26]
           "ESCAPE", // [27]
           "CONVERT", // [28]
           "NONCONVERT", // [29]
           "ACCEPT", // [30]
           "MODECHANGE", // [31]
           "SPACE", // [32]
           "PAGE_UP", // [33]
           "PAGE_DOWN", // [34]
           "END", // [35]
           "HOME", // [36]
           "LEFT", // [37]
           "UP", // [38]
           "RIGHT", // [39]
           "DOWN", // [40]
           "SELECT", // [41]
           "PRINT", // [42]
           "EXECUTE", // [43]
           "PRINTSCREEN", // [44]
           "INSERT", // [45]
           "DELETE", // [46]
           "", // [47]
           "0", // [48]
           "1", // [49]
           "2", // [50]
           "3", // [51]
           "4", // [52]
           "5", // [53]
           "6", // [54]
           "7", // [55]
           "8", // [56]
           "9", // [57]
           "COLON", // [58]
           "SEMICOLON", // [59]
           "LESS_THAN", // [60]
           "EQUALS", // [61]
           "GREATER_THAN", // [62]
           "QUESTION_MARK", // [63]
           "AT", // [64]
           "A", // [65]
           "B", // [66]
           "C", // [67]
           "D", // [68]
           "E", // [69]
           "F", // [70]
           "G", // [71]
           "H", // [72]
           "I", // [73]
           "J", // [74]
           "K", // [75]
           "L", // [76]
           "M", // [77]
           "N", // [78]
           "O", // [79]
           "P", // [80]
           "Q", // [81]
           "R", // [82]
           "S", // [83]
           "T", // [84]
           "U", // [85]
           "V", // [86]
           "W", // [87]
           "X", // [88]
           "Y", // [89]
           "Z", // [90]
           "OS_KEY", // [91] Windows Key (Windows) or Command Key (Mac)
           "", // [92]
           "CONTEXT_MENU", // [93]
           "", // [94]
           "SLEEP", // [95]
           "NUMPAD0", // [96]
           "NUMPAD1", // [97]
           "NUMPAD2", // [98]
           "NUMPAD3", // [99]
           "NUMPAD4", // [100]
           "NUMPAD5", // [101]
           "NUMPAD6", // [102]
           "NUMPAD7", // [103]
           "NUMPAD8", // [104]
           "NUMPAD9", // [105]
           "MULTIPLY", // [106]
           "ADD", // [107]
           "SEPARATOR", // [108]
           "SUBTRACT", // [109]
           "DECIMAL", // [110]
           "DIVIDE", // [111]
           "F1", // [112]
           "F2", // [113]
           "F3", // [114]
           "F4", // [115]
           "F5", // [116]
           "F6", // [117]
           "F7", // [118]
           "F8", // [119]
           "F9", // [120]
           "F10", // [121]
           "F11", // [122]
           "F12", // [123]
           "F13", // [124]
           "F14", // [125]
           "F15", // [126]
           "F16", // [127]
           "F17", // [128]
           "F18", // [129]
           "F19", // [130]
           "F20", // [131]
           "F21", // [132]
           "F22", // [133]
           "F23", // [134]
           "F24", // [135]
           "", // [136]
           "", // [137]
           "", // [138]
           "", // [139]
           "", // [140]
           "", // [141]
           "", // [142]
           "", // [143]
           "NUM_LOCK", // [144]
           "SCROLL_LOCK", // [145]
           "WIN_OEM_FJ_JISHO", // [146]
           "WIN_OEM_FJ_MASSHOU", // [147]
           "WIN_OEM_FJ_TOUROKU", // [148]
           "WIN_OEM_FJ_LOYA", // [149]
           "WIN_OEM_FJ_ROYA", // [150]
           "", // [151]
           "", // [152]
           "", // [153]
           "", // [154]
           "", // [155]
           "", // [156]
           "", // [157]
           "", // [158]
           "", // [159]
           "CIRCUMFLEX", // [160]
           "EXCLAMATION", // [161]
           "DOUBLE_QUOTE", // [162]
           "HASH", // [163]
           "DOLLAR", // [164]
           "PERCENT", // [165]
           "AMPERSAND", // [166]
           "UNDERSCORE", // [167]
           "OPEN_PAREN", // [168]
           "CLOSE_PAREN", // [169]
           "ASTERISK", // [170]
           "PLUS", // [171]
           "PIPE", // [172]
           "HYPHEN_MINUS", // [173]
           "OPEN_CURLY_BRACKET", // [174]
           "CLOSE_CURLY_BRACKET", // [175]
           "TILDE", // [176]
           "", // [177]
           "", // [178]
           "", // [179]
           "", // [180]
           "VOLUME_MUTE", // [181]
           "VOLUME_DOWN", // [182]
           "VOLUME_UP", // [183]
           "", // [184]
           "", // [185]
           "SEMICOLON", // [186]
           "EQUALS", // [187]
           "COMMA", // [188]
           "MINUS", // [189]
           "PERIOD", // [190]
           "SLASH", // [191]
           "BACK_QUOTE", // [192]
           "", // [193]
           "", // [194]
           "", // [195]
           "", // [196]
           "", // [197]
           "", // [198]
           "", // [199]
           "", // [200]
           "", // [201]
           "", // [202]
           "", // [203]
           "", // [204]
           "", // [205]
           "", // [206]
           "", // [207]
           "", // [208]
           "", // [209]
           "", // [210]
           "", // [211]
           "", // [212]
           "", // [213]
           "", // [214]
           "", // [215]
           "", // [216]
           "", // [217]
           "", // [218]
           "OPEN_BRACKET", // [219]
           "BACK_SLASH", // [220]
           "CLOSE_BRACKET", // [221]
           "QUOTE", // [222]
           "", // [223]
           "META", // [224]
           "ALTGR", // [225]
           "", // [226]
           "WIN_ICO_HELP", // [227]
           "WIN_ICO_00", // [228]
           "", // [229]
           "WIN_ICO_CLEAR", // [230]
           "", // [231]
           "", // [232]
           "WIN_OEM_RESET", // [233]
           "WIN_OEM_JUMP", // [234]
           "WIN_OEM_PA1", // [235]
           "WIN_OEM_PA2", // [236]
           "WIN_OEM_PA3", // [237]
           "WIN_OEM_WSCTRL", // [238]
           "WIN_OEM_CUSEL", // [239]
           "WIN_OEM_ATTN", // [240]
           "WIN_OEM_FINISH", // [241]
           "WIN_OEM_COPY", // [242]
           "WIN_OEM_AUTO", // [243]
           "WIN_OEM_ENLW", // [244]
           "WIN_OEM_BACKTAB", // [245]
           "ATTN", // [246]
           "CRSEL", // [247]
           "EXSEL", // [248]
           "EREOF", // [249]
           "PLAY", // [250]
           "ZOOM", // [251]
           "", // [252]
           "PA1", // [253]
           "WIN_OEM_CLEAR", // [254]
           "" // [255]
        ],
        /**
         * id 또는 name 를 이용하여 form 객체를 찾아서 반환한다.<br/>
         * jQuery 객체 또한 native 객체로 반환한다.<br/>
         * 파라미터로 아무것도 넘기지 않으면 document의 가장 첫번째 form을 반환한다.
         * 
         * @param {String} formName - 폼 name 또는 id 또는 객체
         * @returns {Object} HTML FORM ELEMENT
         */
        getForm : function(form){
        	if( dataLib.isEmpty(form) ) return document.forms[0];
        	var _frm ;
			switch (dataLib.type( form )) {
				case 'string':
					_frm = !dataLib.isEmpty( document.getElementById( form ) )? document.getElementById( form )
							: !dataLib.isEmpty( document.forms[form] ) ? document.forms[form]
								: null;
					break;
					
				case 'object':
					_frm = dataLib.isEmpty( form.jquery ) ? form : $(form)[0];
					if( !_frm.tagName || _frm.tagName != 'FORM') _frm = null;
					break;
					
				case 'htmlformelement':
					_frm = form;
					break;
				default:
					_frm = null;
					break;
			}
			if( !_frm ) return null;
			return _frm;
        },
        _splitFilter : function( className ){
			var cn = strLib.collapseSpace( className ) , sIdx = cn.indexOf('filter:'), resultFilters=[];
			if(  sIdx > -1 ){
				// filter get
				var filter = "";
				for( var k=sIdx,klen=cn.length;k<klen;k++){
					var c = cn[k];
					if( c != " "){
						filter += c;
					}else{
						break;
					}
				}
				resultFilters = filter.split(":");
			}
			return resultFilters;
		},
		_validateInfo :{
			msgBox :{
				require : "'{0}'{1} 필수 항목입니다.",
				min : "'{0}'{2} 최소 {1} 글자여야 합니다.",
				max : "'{0}'{2} 최대 {1} 글자까지 입력 가능합니다.",
				byte: "'{0}'{2} 최대 {1} byte 까지 입력 가능합니다.(한글 2byte)"
			},
			'require':{
				isFailed : function( el ){
					return el.value == "";
				},
				msg : function( el ){
					var title = el.title || el.name || el.id || " ";
					
					// 종성여부에 따라 조사(은,는) 를 고른다.
					var josaIndex = strLib.hasJongsung( strLib.right(title, 1) ) 
					, josa = strLib.hanGeul.josa.unnun[ josaIndex ];
					
					return strLib.format( formLib._validateInfo.msgBox['require'] , [title, josa] );
				}
			},
			'min':{
				isFailed : function( el , len){
					return el.value.length < len;
				},
				msg : function( el , len ){
					var title = el.title || el.name || el.id || " ";
					
					// 종성여부에 따라 조사(은,는) 를 고른다.
					var josaIndex = strLib.hasJongsung( strLib.right(title, 1) ) 
					, josa = strLib.hanGeul.josa.unnun[ josaIndex ];
					
					return strLib.format( formLib._validateInfo.msgBox['min'] , [ title , len , josa] );
				}
			},
			'max':{
				isFailed : function( el , len){
					return el.value.length > len;
				},
				msg : function( el , len ){
					var title = el.title || el.name || el.id || " ";
					
					// 종성여부에 따라 조사(은,는) 를 고른다.
					var josaIndex = strLib.hasJongsung( strLib.right(title, 1) ) 
					, josa = strLib.hanGeul.josa.unnun[ josaIndex ];
					
					return strLib.format( formLib._validateInfo.msgBox['max'] , [ title , len , josa ] );
				}
			},
			'byte':{
				isFailed : function( el , len){
					return strLib.getBytes(el.value) >  len;
				},
				msg : function( el , len ){
					var title = el.title || el.name || el.id || " ";
					
					// 종성여부에 따라 조사(은,는) 를 고른다.
					var josaIndex = strLib.hasJongsung( strLib.right(title, 1) ) 
					, josa = strLib.hanGeul.josa.unnun[ josaIndex ];
					
					return strLib.format( formLib._validateInfo.msgBox['byte'] , [ title , len , josa  ] );
				}
			}
		},
		/**
		 * form의 elements 들에 대해 유효성 검사를 세팅, 실시 한다.<br/>
		 * Element의 class 속성에<br/>
		 * 'filter:' 로 시작하는 문자열을 추가하면 해당 필터에대해 세팅을한다.<br/>
		 * 'filter:filterName:filterName:...' 와 같이 `:` 로 구분한다.<br/>
		 * <br/>
		 * # filterName List #<br/>
		 *  - require : 필수항목 - 값이 "" 이면 필터에 걸림. title에있는 문자열로 안내 메시지가 나타남.<br/>
		 *  - max[N] : 최대문자열길이[N개] - 입력문자의 길이가 N보다 크면 안내메시지가 나타남.<br/>
		 *  - min[N] : 최소문자열길이[N개] - 입력문자의 길이가 N보다 작으면 안내메시지가 나타남.<br/>
		 *  - byte[N] : 최대Byte길이[ N byte ] - 입력문자의 Byte가 N보다 크면 안내메시지가 나타남.(한글2Byte)<br/>
		 *  - num : 숫자만 입력가능<br/>
		 *  - eng : 영어만 입력가능<br/>
		 *  - kor : 한글만 입력가능<br/>
		 *  - symbol : 특수기호만 입력가능<br/>
		 *  
		 * 
		 * @example
		 * &lt;input type='text' class='filter:require:num:eng' title='아이디' &gt;
		 * ==> 필수항목이면서 숫자와 영어만 입력가능.
		 * ==> 필수항목 필터에 걸릴 때 title 속성의 값으로 안내메시지가 나타남
		 *     ( ex - '아이디'는 필수항목 입니다. ) 
		 * @example
		 * &lt;input type='text' class='filter:require:max[5]' title='아이디' &gt;
		 * ==> 필수항목이면서 5글자 이상입력시 안내메시지 출력.
		 * ==> 필수항목 필터에 걸릴 때 title 속성의 값으로 안내메시지가 나타남
		 *     ( ex - '아이디'는 최대 5 글자까지 입력 가능합니다.) 
		 * 
		 * @param form
		 */
		setValidation:function( form ){
			var _frm = this.getForm( form );
			if(!_frm) return;
			var els = _frm.elements;
			if(typeof els == 'undefined' || els == null ) return;
			if( _frm._setted )return;
			_frm._setted = true;
			
			var that = this;
			
			for(var i=0,len=els.length;i<len;i++){
				var element = els[i] 
					, filters = this._splitFilter(  element.className  ) 
					, setAllows = [ element ];
				for( var j = 1,jlen = filters.length;j<jlen;j++){
					var fName = filters[j] , hasNum = fName.search(/\[-?[0-9]+\]/g) , numinfo = fName.match(/\[-?[0-9]+\]/g) , num ;
					fName = hasNum > -1? fName.substring(0,hasNum):fName;
					num = null == numinfo ? null : numinfo[0].match(/-?[0-9]+/g)[0];
					
					switch ( fName ){
						case 'num': case 'kor': case 'eng': case 'symbol':
							setAllows.push( filters[j] );
							break;
						case 'max':
							element.maxLength = num;
							break;
						case 'byte':
							var tNum = num;
							EventUtil.addHandler( element , 'blur', function(event){
								this.value = strLib.cutBytes(this.value, tNum);
							});
							break;
					}
				}
				// 허용 문자열 세팅
				if( setAllows.length > 1) this.keyEvent.setAllow.apply( this.keyEvent , setAllows );
				
			}
			EventUtil.addHandler( _frm , 'submit', function(event){
				if( !that.validation( _frm ) )EventUtil.preventDefault(event);
			});
		},
		/**
		 * form의 Element들의 유효성검사를 실시한다.<br/>
		 * 필터 속성에 대해 유효성검사를 실시한다.
		 * 
		 * @example
		 * - require : 필수항목
		 * - max[N] : 최대문자열길이[N개]
		 * - min[N] : 최소문자열길이[N개]
		 * - byte[N] : 최대Byte길이[ N byte ](한글 2byte) 
		 * 
		 * @param form
		 * @returns {Boolean}
		 */
		validation:function( form ){
			var _frm = this.getForm( form ) , els = _frm.elements;
			for(var i=0,len=els.length;i<len;i++){
				var element = els[i];
				var filters = this._splitFilter(  element.className  );
				for( var j = 1,jlen = filters.length;j<jlen;j++){
					var fName = filters[j]
						, hasNum = fName.search(/\[-?[0-9]+\]/g)
						, numinfo = fName.match(/\[-?[0-9]+\]/g)
						, num ;
					
					fName = hasNum > -1? fName.substring(0,hasNum):fName;
					num = null == numinfo ? null : numinfo[0].match(/-?[0-9]+/g)[0];
					
					var o = this._validateInfo[ fName ];
					if( typeof o == 'undefined' ) continue;
					if( o.isFailed( element , num ) ){
						
						Message.alert( o.msg ( element , num ) ,function(){
							if( element.select ){
								element.select();
							}else{
								element.focus();
							}
						});
						
						if( element.select ){
							element.select();
						}else{
							element.focus();
						}
						
						return false;
					}
				}
			}
			return true;
		},
		
		/**
		 *  키 입력 필터링 이벤트
		 *  @namespace
		 */
		keyEvent : {
			_createAllow_keydown : function( event ){
				
				allowCondition = this._allowCondition;
				
				var condition = typeof allowCondition == 'function'? allowCondition( event ) : allowCondition;
				if( !condition ) {
					switch ( formLib.KEY_MAP[event.keyCode] ) {
						// 추가 allow 키
						case 'SHIFT':case 'CONTROL':case 'LEFT':case 'RIGHT':case 'ENTER':case 'HOME':case 'END':
						case 'TAB':case 'CAPS_LOCK':case 'F5':case 'ESC':case 'BACK_SPACE':case 'DELETE':
							break;
						default:
							if( !event.ctrlKey) EventUtil.preventDefault(event);
							break;
					}
				}
			},
			_createAllow_keyup : function(event){
				var _regExp = new RegExp( this._regExp , "gm");
				if( _regExp.test( this.value )){
					var val= this.value.replace( _regExp , '');
					this.value = val;
				}
			},
			_createAllow : function ( element , regExp , eventType  ){
				this._removeEvents(element);
				if( element._allowCondition ) {
					EventUtil.addHandler(element, 'keydown', this._createAllow_keydown );
				}
				EventUtil.addHandler(element, 'keyup', this._createAllow_keyup);
				
			},
			/**
			 * 영문 한 타입만 입력 가능한 이벤트를 적용
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.onlyEng( input ); 
			 *  
			 * @param {HtmlElementObject} element
			 */
			onlyEng : function( element ){
				element._applyKeyEvent = "OnlyENG";
				element._allowCondition = function(event){ return event.keyCode >=65 && event.keyCode <= 90;};
				element._regExp = "[^a-zA-Z]";
				this._createAllow ( element );
				
			},
			/**
			 * 숫자 한 타입만 입력 가능한 이벤트를 적용
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.onlyNum( input ); 
			 *  
			 * @param {HtmlElementObject} element
			 */
			onlyNum : function( element ){
				element._applyKeyEvent = "OnlyNUM";
				element._allowCondition = function(event){var key = event.keyCode;return key >=48 && key <= 57 || key >= 96 && key <= 105;}
				element._regExp = "[^0-9]";
				this._createAllow ( element);
				
			},
			/**
			 * 한글 한 타입만 입력 가능한 이벤트를 적용
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.onlyKor( input ); 
			 *  
			 * @param {HtmlElementObject} element
			 */
			onlyKor : function( element ){
				element._applyKeyEvent = "OnlyKOR";
				element._allowCondition = function(event){ return formLib.KEY_MAP[event.keyCode] == "" ; }
				element._regExp = "[^ㄱ-힇]";
				this._createAllow ( element );
				
			},
			
			/**
			 * 여러가지 타입을 필터링 한다.<br/>
			 * 파라미터로 허용할 타입을 String으로 넘긴다.<br/>
			 * - parameter ex)<br/>
			 * 'kor', 'eng', 'num', 'symbol' 또는 '한글','영문','숫자','기호'
			 * 
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.setAllow( input , 'kor','num' ); // 한글과 숫자만 입력 가능. 
			 * formLib.keyEvent.setAllow( input , '영문','기호' ); // 영문과 기호만 입력 가능. 
			 *  
			 * @param {HtmlElementObject} element
			 * @param {String} allowType : 가변인자 사용.
			 */
			setAllow : function ( element ){
				element._applyKeyEvent = "Allow";
				var reg = "[^", isHan=false, funcEng, funcNum, funcSymb;
				for( var i=1,len=arguments.length;i<len;i++){
					var allowType = arguments[i].toLowerCase();
					switch ( true ) {
						case allowType.indexOf('kor') > -1  || allowType.indexOf('한') > -1:
							reg += "ㄱ-힇";
							isHan = true;
							element._applyKeyEvent += "KOR ";
							break;
						
						case allowType.indexOf('eng') > -1 || allowType.indexOf('영') > -1:
							reg += "a-zA-Z";
							element._applyKeyEvent += "ENG ";
							funcEng = function(event){
								var key = event.keyCode;
								return (key>=97&&key<=122) || (key>=65&&key<=90);
								
							}
							break;
						
						case allowType.indexOf('num') > -1 || allowType.indexOf('숫자') > -1:
							reg += "0-9";
							element._applyKeyEvent += "NUM ";
							funcNum = function(event){
								var isNum = parseInt( formLib.KEY_MAP[event.keyCode], 10);
								return (isNum > -1 && isNum < 10);
							}
							break;
						
						case allowType.indexOf('symb') > -1 || allowType.indexOf('특수') > -1 || allowType.indexOf('기호') > -1:
							element._applyKeyEvent += "SYMBOL ";
							reg += '~!@#$%^&*()_+\-=`\'";:\{\}\[\],.<>?/\\\|';
						
							funcSymb = function(event){
								var ch = String.fromCharCode(event.keyCode);
								switch(ch){
					    			case '|':case '\\':
					    			case '(':case ')': 
					    			case '[':case ']': 
					    			case '{':case '}': 
					    			case '+':case '*': 
					    			case '$':case '^': 
					    			case '/':case '?': 
					    			case '.':
					    				ch = '\\' + ch; 
					    				break;
					    		}
								var reg = new RegExp( ch , "gm");
								return reg.test( '~!@#$%^&*()`-_=+|\\{}[]\'",.<>/?;:' )
							}
							
							break;
					} 
				}
				reg += "]";
				
				var _reg = new RegExp( reg , "gm");
				
				this._removeEvents(element);
				//한글 제외여부 
				if( !isHan ) this.excludeKor(element);
				
				var id = this._exclude_func_list.length;
				element._exclude_keypress_id = id;
				var tmp = function(event){
					var isNum = typeof funcNum == 'function'? funcNum(event) : false 
							, isSymb = typeof funcSymb == 'function'? funcSymb(event) : false 
							, isEng = typeof funcEng == 'function'? funcEng(event) : false;
						if( !( isNum || isSymb || isEng ) ) EventUtil.preventDefault(event);
				};
				this._exclude_func_list.push( tmp );
				
				//영문 또는 숫자 또는 특수문자 허용 
				EventUtil.addHandler(element, 'keypress', this._exclude_func_list[id] );
				
				var id = this._exclude_func_list.length;
				element._exclude_setAllow_keyup_id = id;
				var _setAllow_keyup = function(event){
					if( _reg.test( element.value )){
						var val= element.value.replace( _reg , '');
						element.value = val;
					}
				};
				this._exclude_func_list.push( _setAllow_keyup );
				EventUtil.addHandler(element, 'keyup', this._exclude_func_list[id] );
				
			},
			_exclude_func_list : [],
			// 제외 event
			_createExclude : function( element , blockCondition, regExp , eventType ){
				
				this._removeEvents(element);
				
				if( blockCondition ){
					var id = this._exclude_func_list.length;
					element._exclude_keydown_id = id;
					var tmp = function(event){
						var condition = typeof blockCondition == 'function'? blockCondition( event ) : blockCondition;
						if( condition ) EventUtil.preventDefault(event);
					};
					this._exclude_func_list.push( tmp );
					EventUtil.addHandler(element, 'keydown', this._exclude_func_list[id]);
				}
				
				//keypress 는 대,소문자, 특수문자 를 필터링할때 필요
				var id = this._exclude_func_list.length;
				element._exclude_keyup_id = id;
				var tmp = function(event){
					var _regExp = new RegExp( regExp , "gm");
					if( _regExp.test( element.value )){
						var val= element.value.replace( _regExp , '');
						element.value = val;
					}
				};
				this._exclude_func_list.push( tmp );
				EventUtil.addHandler(element, 'keyup', this._exclude_func_list[id]);
			},
			/**
			 * 한글 만 입력 불가능하게 필터링한다.
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.excludeKor( input ); // 한글 입력 불가 
			 *  
			 * @param {HtmlElementObject} element
			 */
			excludeKor : function( element ){
				
				if( comLib.client.browser.ie ) element.style.imeMode = 'inactive';
				
				this._createExclude( element, function(event){
					return !formLib.KEY_MAP[event.keyCode] && !event.ctrlKey && !event.shiftKey;
				},"[ㄱ-힇]");
				
			},
			/**
			 * 영문 만 입력 불가능하게 필터링한다.
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.excludeEng( input ); // 영문 입력 불가 
			 *  
			 * @param {HtmlElementObject} element
			 */
			excludeEng : function( element ){
				
				if( comLib.client.browser.ie ) element.style.imeMode = 'active';
				
				this._createExclude( element, function(event){
					return event.keyCode >=65 && event.keyCode <= 90 && !event.ctrlKey && !event.shiftKey;
				},"[a-zA-Z]");
				
			},
			/**
			 * 숫자만 입력 불가능하게 필터링한다.
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.excludeNum( input ); // 숫자 입력 불가 
			 *  
			 * @param {HtmlElementObject} element
			 */
			excludeNum : function( element ){
				
				this._removeEvents(element);
				
				var id = this._exclude_func_list.length;
				element._exclude_keypress_id = id;
				var tmp = function(event){
					var isNum = parseInt( formLib.KEY_MAP[event.keyCode], 10);
					if( isNum > -1 && isNum < 10 ) EventUtil.preventDefault(event);
				};
				this._exclude_func_list.push( tmp );
				
				EventUtil.addHandler(element, 'keypress', this._exclude_func_list[id] );
			},
			/**
			 * 기호 만 입력 불가능하게 필터링한다.
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.excludeSymbol( input ); // 기호 입력 불가 
			 *  
			 * @param {HtmlElementObject} element
			 */
			excludeSymbol: function( element ){
				
				this._removeEvents(element);
				
				var id = this._exclude_func_list.length;
				element._exclude_keypress_id = id;
				var tmp = function(event){
					var ch = String.fromCharCode(event.keyCode);
					switch(ch){
		    			case '|':case '\\':
		    			case '(':case ')': 
		    			case '[':case ']': 
		    			case '{':case '}': 
		    			case '+':case '*': 
		    			case '$':case '^': 
		    			case '/':case '?': 
		    			case '.':
		    				ch = '\\' + ch; 
		    				break;
		    		}
					var reg = new RegExp( ch , "gm");
					if( reg.test( '~!@#$%^&*()`-_=+|\\{}[]\'",.<>/?;:' ) ) EventUtil.preventDefault(event);
				};
				this._exclude_func_list.push( tmp );
				EventUtil.addHandler(element, 'keypress', this._exclude_func_list[id]);
			},
			_removeEvents:function( element ){
				if( typeof element._exclude_keypress_id != 'undefined')
					EventUtil.removeHandler(element, 'keypress', this._exclude_func_list[element._exclude_keypress_id] );
				if( typeof element._exclude_keyup_id != 'undefined')
					EventUtil.removeHandler(element, 'keyup', this._exclude_func_list[element._exclude_keyup_id] );
				if( typeof element._exclude_setAllow_keyup_id != 'undefined')
					EventUtil.removeHandler(element, 'keyup', this._exclude_func_list[element._exclude_setAllow_keyup_id] );
				EventUtil.removeHandler(element, 'keyup', this._createAllow_keyup );
				if( typeof element._exclude_keydown_id != 'undefined')
					EventUtil.removeHandler(element, 'keydown', this._exclude_func_list[element._exclude_keydown_id] );
				EventUtil.removeHandler(element, 'keydown', this._createAllow_keydown );
			},
			/**
			 * 입력한 정규식에 대하여 입력 불가능하게 필터링한다.
			 * 
			 * @example
			 * var input = document.getElementById('input');
			 * formLib.keyEvent.excludeRegExp( input , "[0-9a-zA-Z]" ); // 영문, 숫자 입력불가
			 *  
			 * @param {HtmlElementObject} element
			 * @param {String} regExp 
			 */
			excludeRegExp: function( element, str ){
				
				this._createExclude( element, false , str );
				
				EventUtil.addHandler(element, 'keypress', function(event){
					var ch = String.fromCharCode(event.keyCode) 
						, reg = new RegExp( str , "gm");
					if( reg.test( ch )  ) EventUtil.preventDefault(event);
				});
			}
		}
};

