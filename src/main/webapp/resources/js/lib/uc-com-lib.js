/**
 * @Description : 공통 라이브러리
 * @Modification Information
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2016.05.09		이종욱          	최초 생성
 *  @namespace [Library] 공통 라이브러리 
 *  @author 유채널(주) 개발팀 이종욱
 *  @since 2016.05.09
 *  @version 1.0
 */
var comLib = {
		/**
		 * Object, Array 등 객체 데이터를 HTML태그로 변환
		 * @ignore
		 */
		_Converter : {
				keys:function( o ){
					var a = [];
					for( var k in o ) a.push(k);
					return a;
				},
				// Function => String
				convFunctionToString  : function( f , funcName ){
					// 함수 가이드
					/* var funcParam = this.funcGuide;
					if( typeof funcParam[funcName] == 'undefined' ) return f.toString().replace(/\"/g,'').replace(/\n/g,'');
					else return "function( "+funcParam[funcName]+" ){ ... }"; */
					return "function( ... ){ ... }";
				},
				// Object => String
				convObjectToString : function( o , isCol, pKeys , step){
					if( typeof step == 'undefined' ) step = 1;
					var keys = isCol ? pKeys : this.keys( o ), tmp='' , tab = '&nbsp;', enter = '<br/>';
					
					for( var i=0,len=step;i<len;i++){ tab += tab; }
					
					var curStep = step+1;
					if( curStep == 2) tmp += tab + '{' + enter;
					else tmp += '{' + enter;
					
					for(var j=0,jLen=keys.length;j<jLen;j++){
						var k = keys[j], v = o[keys[j]];
						v = typeof v == 'number' || typeof v == 'boolean'? 'blue">'+ v 
								: typeof v == 'undefined' || v == null ? '">""' 
										: Array.isArray( v ) ? '">'+this.convArrayToString(v , curStep) 
												: typeof v == 'object'? '">'+this.convObjectToString(v , false, [] , curStep )
														: typeof v == 'function' ? 'blue">' + this.convFunctionToString(v , k)
															: 'red">"'+v+'"';
						tmp += tab + tab + '<span class="key">"' + k + '"</span>:<span class="'+ v +'</span>';
						tmp += j < jLen-1 ? ','+enter : '';
					}
					tmp += i < len-1 ? enter + tab +'},'+enter : enter + tab + '}';
					return tmp;
				},
				// Array => String
				convArrayToString : function ( a , step ){
					if( typeof step == 'undefined' ) step = 1;
					var tab = '&nbsp;', enter = '<br/>';
					for( var i=0,len=step + 1;i<len;i++){
						tab += tab;
					}
					var tmp = '[' + enter;
					for( var i = 0, len=a.length;i<len;i++){
						var val = a[i],  type = typeof val, spanTag = '<span class="', spanTagE = "</span>";
						
						tmp += tab;
						
						switch (type) {
							case 'string':
								tmp += spanTag+'red">"' + val + '"'+spanTagE;
								break;
							case 'function':
								tmp += this.convFunctionToString(val);
								break;
							case 'number':
							case 'boolean':
								tmp += spanTag+'blue">' + val + '"'+spanTagE;
								break;
							case 'object':
								if( a[i] instanceof Array ){
									tmp += this.convArrayToString( val , step);
								}else{
									tmp += this.convObjectToString( val , false, [] , step );
								}
								break;
							default:
								break;
						}
						tmp += i < len-1 ? ',' : ''
						
						tmp += enter;
					}
					tmp += tab.replace('&nbsp;','').replace('&nbsp;','') + ']';
					return tmp;
				}
		},
		/**
		 * Object, Array, Function 데이터를 HTML 태그로 바꿔준다.<br/>
		 * key, value에 &lt;span&gt; 태그가 걸려있으므로 클래스에 대한 스타일이 들어간다.<br/>
		 * <br/>
		 * <b>- 아래는 클래스 별 색상 정보이다.</b><br/>
		 * .key {color:#871990} ( object의 key )<br/>
		 * .blue {color:#1c00cf} ( number, boolean 타입 )<br/>
		 * .red {color:#cc3c38}  ( string 타입 )<br/>
		 * .comment{color:#3f7f5f} ( 주석 )<br/>
		 * .func {color:#7f0055;font-weight: bold;} ( function 타입 )<br/> 
		 * 
		 * @example
		 * var test = {
		 * 	string: 'value',
		 * 	boolean: true,
		 * 	number: 100,
		 * 	function: function(){}
		 * }
		 * comLib.convToHtml(test);
		 * 
		 * ### 결과
		 * &nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"string"</span>:<span class="red">"value"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"boolean"</span>:<span class="blue">true</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"number"</span>:<span class="blue">100</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"function"</span>:<span class="blue">function( ... ){ ... }</span><br/>&nbsp;&nbsp;}
		 * 
		 * @param target : Object, Array, Function 형태의 데이터
		 * @returns {String} : HTML태그 문자열
		 */
		convToHtml : function( target ){
			
			if( typeof target == 'object'){
				if( Array.isArray( target )){
					return this._Converter.convArrayToString( target  );
				}else{
					return this._Converter.convObjectToString( target );
				}
			}else if( typeof target == 'function'){
				return this._Converter.convFunctionToString( target );
			}else{
				return target;
			}
		},
		/**
		 * 비동기로 반복문을 실행한다.<br/>
		 * 순차적으로 반복문이 실행됨.( i = 0; i < length ; i++ )
		 * 
		 * @example
		 * comLib.asyncLoop( [1,2,3,4,5] , function(i, item){
		 * 	console.log( '현재 인덱스 : ' + i );
		 * 	console.log( '현재 데이터 : ' + item );
		 * },function(){
		 * 	console.log(' The End ! callback! ');
		 * });
		 * 
		 * @param {Array} array : 반복문을 실행할 배열
		 * @param {Function} fn (i, item) : 반복하며 실행할 함수, 현재의 index와 index에해당하는 데이터를 넘겨준다.
		 * @param {Function} callback : 반복문이 끝나면 실행될 콜백함수
		 * @param {Object} context : 반복문이 실행될 함수의 컨텍스트
		 */
		asyncLoop : function(array, fn, callback, context ){
			var a = array.concat() , i = 0;
			fn = (typeof fn == 'function')? fn: function(){};
			setTimeout(function(){
				var item = a.shift();
				fn.call(context, i++, item);
				if( a.length > 0){
					setTimeout(arguments.callee, 0);
				}else{
					if( typeof callback == 'function' ){
						callback();
					}
				}
			}, 0)
		},
		/**
		 * 비동기로 반복문을 실행한다.<br/>
		 * 거꾸로 반복문이 실행됨.( i = length-1; i >=0 ; i-- )
		 * 
		 * @example
		 * comLib.asyncLoop( [1,2,3,4,5] , function(i, item){
		 * 	console.log( '현재 인덱스 : ' + i );
		 * 	console.log( '현재 데이터 : ' + item );
		 * },function(){
		 * 	console.log(' The End ! callback! ');
		 * });
		 * @param {Array} array : 반복문을 실행할 배열
		 * @param {Function} fn (i, item) : 반복하며 실행할 함수, 현재의 index와 index에해당하는 데이터를 넘겨준다.
		 * @param {Function} callback : 반복문이 끝나면 실행될 콜백함수
		 * @param {Object} context : 반복문이 실행될 함수의 컨텍스트
		 */
		asyncLoopReverse : function(array, fn, callback, context){
			var a = array.concat() , i = 0;
			fn = (typeof fn == 'function')? fn: function(){};
			setTimeout(function(){
				var item = a.pop();
				fn.call(context, i++, item);
				if( a.length > 0){
					setTimeout(arguments.callee, 0);
				}else{
					if( typeof callback == 'function' ){
						callback();
					}
				}
			}, 0);
		},
		/**
		 * 함수 감속 패턴을 사용한다.<br/>
		 * 코드를 주기적으로 실행해야 하지만 호출 자체를 제어 할 수 없을때 사용한다.<br/>
		 * 특히 resize 이벤트와 같이, <br/>
		 * 반복적인 행위(수치계산)가 필요이상으로 날 떄<br/>
		 * 이전의 resize이벤트는 무시하고 마지막 행위에 대해서만 계산할 수 있다.<br/>
		 * <br/>
		 * <b>주의할 점은 파라미터로 넘길 function은 익명함수를 넘기면 안된다.<br/>
		 * 이유는 setTimeout에 대한 id값을 프로퍼티로 저장해놔야 하기 때문이다.</b>
		 * 
		 * @example
		 * 
		 * function resize( event ){
		 * 	console.log( event );
		 * 	console.log( $(window).width() );
		 * }
		 * 
		 * window.onresize = function( event ){
		 * 	comLib.throttling( resize , arguments );
		 * }
		 * 
		 * @param {Function} func : 함수( 익명함수는 안됨 )
		 * @param {Array} arguments : 실행될 함수에 넘길 파라미터
		 * @param {Object} context : 실행될 함수의 Context
		 * @param {Number} interval : 반복되는시간초( 밀리초 ) default: 100
		 */
		throttling : function(func, args , context, interval ){
			interval = interval || 100;
			
			if( !func.toString().match(/function\s+\w/g) ) {
				alert("comLib.throttling() 함수를 사용 할 때는 익명함수를 사용할 수 없습니다. API를 확인해주세요.");
				return;
			}
			clearTimeout(func._tid);
			func._tid = setTimeout(function(){
				func.apply(context, args);
			}, interval);
		},
		
		_cookieMgr : new CookieManager(),
		/**
		 * 쿠키를 세팅(추가)한다.
		 * @example
		 * comLib.setCookie( 'test', 'test_cookie_value'); // "test=test_cookie_value"
		 * 
		 * @param {String} name : 쿠키 key 값
		 * @param {String} value 	: 쿠키 밸류값
		 * @param {Object} expireOption : 만기정보
		 * @return {String} document.cookie : 브라우저 쿠키 정보
		 */
		setCookie : function( name, value, expireOption ){
			this._cookieMgr.set(name, value, expireOption);
			return document.cookie;
		},
		/**
		 * 쿠키 데이터(정보)를 가져온다.
		 * @example
		 * comLib.getCookie('test'); // "test_cookie_value"
		 * 
		 * @param {String} name : 가져올 쿠키 key값
		 * @return {String} value : 쿠키 정보 
		 */
		getCookie : function(name){
			return this._cookieMgr.get(name);
		},
		/**
		 * 쿠키 정보를 삭제한다.
		 * @example
		 * comLib.delCookie('test'); // ""
		 * 
		 * @param {String} name : 삭제할 쿠키 key 값
		 * @return {String} document.cookie : 브라우저 쿠키 정보
		 */
		delCookie : function(name){
			this._cookieMgr.del(name);
			return document.cookie;
		},
		/**
		 * 클라이언트의 정보를 감지한다.<br/>
		 * [출처 : 「프론트엔드 개발자를위한 자바스크립트 프록래밍 - 니콜라스자카스 저」]
		 * @example
		 * 	browser: {
		 * 			<span class='comment'>// 브라우저 : 해당 브라우저의 버전이 세팅되어 반환됨.</span>
		 * 			ie: 11,   <span class='comment'>// ie 11인 경우</span>
		 * 	        firefox: 0,
		 * 	        safari: 0,
		 * 	        konq: 0,
		 * 	        opera: 0,
		 * 	        chrome: 0
		 * 	},
		 *  	engine: {
		 * 	       <span class='comment'>// 엔진 : 해당 엔진의 버전이 세팅되어 반환됨.</span>
		 * 	        ie: 0,
		 * 	        gecko: 0,
		 * 	        webkit: 0,
		 * 	        khtml: 0,
		 * 	        opera: 0
		 * 	},  
		 * 	system : {
		 * 	       <span class='comment'>// 시스템 : 해당 시스템에 대한 값이 반환됨.</span>
		 * 	        win: "7",   <span class='comment'>// window 7 인 경우</span>
		 * 	        mac: false,
		 * 	        x11: false,
		 * 	        
		 * 	        <span class='comment'>// mobile devices</span>
		 * 	        iphone: false,
		 * 	        ipod: false,
		 * 	        ipad: false,
		 * 	        ios: false,
		 * 	        android: false,
		 * 	        nokiaN: false,
		 * 	        winMobile: false,
		 * 	        
		 * 	        <span class='comment'>// game systems</span>
		 * 	        wii: false,
		 * 	        ps: false 
		 * 	}
		 * @return {Object}  - 브라우저, 엔진, 시스템 에 대한 정보를 담은 객체
		 */
		client : function(){

		    //rendering engines
		    var engine = {            
		        ie: 0,
		        gecko: 0,
		        webkit: 0,
		        khtml: 0,
		        opera: 0,

		        //complete version
		        ver: null  
		    };
		    
		    //browsers
		    var browser = {
		        
		        //browsers
		        ie: 0,
		        firefox: 0,
		        safari: 0,
		        konq: 0,
		        opera: 0,
		        chrome: 0,

		        //specific version
		        ver: null
		    };

		    
		    //platform/device/OS
		    var system = {
		        win: false,
		        mac: false,
		        x11: false,
		        
		        //mobile devices
		        iphone: false,
		        ipod: false,
		        ipad: false,
		        ios: false,
		        android: false,
		        nokiaN: false,
		        winMobile: false,
		        
		        //game systems
		        wii: false,
		        ps: false 
		    };    

		    //detect rendering engines/browsers
		    var ua = navigator.userAgent;    
		    if (window.opera){
		        engine.ver = browser.ver = window.opera.version();
		        engine.opera = browser.opera = parseFloat(engine.ver);
		    } else if (/AppleWebKit\/(\S+)/.test(ua)){
		        engine.ver = RegExp["$1"];
		        engine.webkit = parseFloat(engine.ver);
		        
		        //figure out if it's Chrome or Safari
		        if (/Chrome\/(\S+)/.test(ua)){
		            browser.ver = RegExp["$1"];
		            browser.chrome = parseFloat(browser.ver);
		        } else if (/Version\/(\S+)/.test(ua)){
		            browser.ver = RegExp["$1"];
		            browser.safari = parseFloat(browser.ver);
		        } else {
		            //approximate version
		            var safariVersion = 1;
		            if (engine.webkit < 100){
		                safariVersion = 1;
		            } else if (engine.webkit < 312){
		                safariVersion = 1.2;
		            } else if (engine.webkit < 412){
		                safariVersion = 1.3;
		            } else {
		                safariVersion = 2;
		            }   
		            
		            browser.safari = browser.ver = safariVersion;        
		        }
		    } else if (/KHTML\/(\S+)/.test(ua) || /Konqueror\/([^;]+)/.test(ua)){
		        engine.ver = browser.ver = RegExp["$1"];
		        engine.khtml = browser.konq = parseFloat(engine.ver);
		    } else if (/rv:([^\)]+)\) Gecko\/\d{8}/.test(ua)){    
		        engine.ver = RegExp["$1"];
		        engine.gecko = parseFloat(engine.ver);
		        
		        //determine if it's Firefox
		        if (/Firefox\/(\S+)/.test(ua)){
		            browser.ver = RegExp["$1"];
		            browser.firefox = parseFloat(browser.ver);
		        }
		    } else if (/MSIE ([^;]+)/.test(ua)){    
		        engine.ver = browser.ver = RegExp["$1"];
		        engine.ie = browser.ie = parseFloat(engine.ver);
		    } else if (/rv:([^\)]+)\)/.test(ua) ){   
		    	engine.ver = browser.ver = RegExp["$1"];
		    	if( /Trident/.test(ua) ) engine.ie = browser.ie = parseFloat(engine.ver);
		    }
		    
		    //detect browsers
		    browser.ie = engine.ie;
		    browser.opera = engine.opera;
		    

		    //detect platform
		    var p = navigator.platform;
		    system.win = p.indexOf("Win") == 0;
		    system.mac = p.indexOf("Mac") == 0;
		    system.x11 = (p == "X11") || (p.indexOf("Linux") == 0);

		    //detect windows operating systems
		    if (system.win){
		        if (/Win(?:dows )?([^do]{2})\s?(\d+\.\d+)?/.test(ua)){
		            if (RegExp["$1"] == "NT"){
		                switch(RegExp["$2"]){
		                    case "5.0":
		                        system.win = "2000";
		                        break;
		                    case "5.1":
		                        system.win = "XP";
		                        break;
		                    case "6.0":
		                        system.win = "Vista";
		                        break;
		                    case "6.1":
		                        system.win = "7";
		                        break;
		                    default:
		                        system.win = "NT";
		                        break;                
		                }                            
		            } else if (RegExp["$1"] == "9x"){
		                system.win = "ME";
		            } else {
		                system.win = RegExp["$1"];
		            }
		        }
		    }
		    
		    //mobile devices
		    system.iphone = ua.indexOf("iPhone") > -1;
		    system.ipod = ua.indexOf("iPod") > -1;
		    system.ipad = ua.indexOf("iPad") > -1;
		    system.nokiaN = ua.indexOf("NokiaN") > -1;
		    
		    //windows mobile
		    if (system.win == "CE"){
		        system.winMobile = system.win;
		    } else if (system.win == "Ph"){
		        if(/Windows Phone OS (\d+.\d+)/.test(ua)){;
		            system.win = "Phone";
		            system.winMobile = parseFloat(RegExp["$1"]);
		        }
		    }
		    
		    
		    //determine iOS version
		    if (system.mac && ua.indexOf("Mobile") > -1){
		        if (/CPU (?:iPhone )?OS (\d+_\d+)/.test(ua)){
		            system.ios = parseFloat(RegExp.$1.replace("_", "."));
		        } else {
		            system.ios = 2;  //can't really detect - so guess
		        }
		    }
		    
		    //determine Android version
		    if (/Android (\d+\.\d+)/.test(ua)){
		        system.android = parseFloat(RegExp.$1);
		    }
		    
		    //gaming systems
		    system.wii = ua.indexOf("Wii") > -1;
		    system.ps = /playstation/i.test(ua);
		    
		    //return it
		    return {
		        engine:     engine,
		        browser:    browser,
		        system:     system        
		    };

		}()
		//////////////////////////////////-- New 추가
		/**
		 * 타이머기능: 최소 초단위
		 * @example
		 *  var timer = comLib.timer( 150, function( cnt ,timeInfo ,interval){
		  		console.log( cnt,  timeInfo );
		  		if( cnt == 15 ) this.stop(); // or clearInterval(interval)
			}, true);
			
			setTimeout(function(){
				timer.stop();
			}, 5000);
		 */
		, timer : function( sec , callback , loop ){
			var cnt = 0 
				, sec_cnt = parseInt( sec , 10) 
				, _hour 
				, _min 
				, _sec 
				, t = this.timer;
			
			setTimeout(function(){
				var interval = setInterval(function(){
					sec_cnt--;
					cnt++;
					if(typeof callback == 'function'){
						_hour 	= Math.floor( sec_cnt/3600 );
						_min 	= Math.floor( (sec_cnt%3600)/60 );
						_sec 	= Math.round( (sec_cnt%3600)/60%1*60 );
						var timeInfo = {
								hour:_hour,
								min:_min,
								sec:_sec 
						}
						var isEnd = (_hour == 0 && _min == 0 && _sec == 0);
						// this.timer를 컨텍스트로하여 call한다,
						// 파라미터는 interval Id, 반복횟수, 시간정보 이다.
						callback.call(t, cnt , timeInfo, isEnd , interval);
					}
					
					if( (_hour == 0 && _min == 0 && _sec == 0 ) ){
						if( loop === false){
							// loop하지않는다면 타이머가 다됐을때 스톱
							clearInterval(interval);
						}else{
							// 아니면 다시 스타트
							sec_cnt = parseInt( sec , 10);
						}
					}
				}, 1000 );
				
				t.interval = interval;
				// stop 하는 함수
				t.stop = function(){
					clearInterval(t.interval);
				}
			}, 100);
			
			return t ;
		}
};
/**
 * 타이머기능: 최소 초단위
 * @class [Class] 초단위 타이머
 * @example
 *  var timer = new ComLibTimer( 150, function( cnt ,timeInfo ,interval){
  		console.log( cnt,  timeInfo );
  		if( cnt == 15 ) this.stop(); // or clearInterval(interval)
	}, true);
	
	setTimeout(function(){
		timer.stop();
	}, 5000);
 */
function ComLibTimer( sec , callback , loop ){
	var t = this;
	t.option = {
		sec : sec,
		cnt : 0,
		secCnt : parseInt( sec , 10 ),
		loop : loop,
		callback:callback
	}
	t.status = false;
	t._hour=0;
	t._min=0;
	t._sec=0;
}
/**
 * 타이머를 멈춘다.
 * @returns {ComLibTimer}
 */
ComLibTimer.prototype.stop = function (){
	this._stop(true);
	return this;
}
/**
 * 타이머를 일시정지한다.
 * @returns {ComLibTimer}
 */
ComLibTimer.prototype.pasue = function (){
	this._stop(false);
	return this;
}
ComLibTimer.prototype._stop = function (isClear){
	var t= this;
	if(isClear) t.option.secCnt = parseInt( t.option.sec , 10); 
	clearInterval(t.interval);
	t.status = false;
}
/**
 * 타이머를 시작한다.
 * @returns {ComLibTimer}
 */
ComLibTimer.prototype.start = function (){
	var t = this;
	if(t.status)return t;
	var callback = t.option.callback;
	var interval = setInterval(function(){
		t.option.secCnt--;
		t.option.cnt++;
		if(typeof callback == 'function'){
			t._hour 	= Math.floor( t.option.secCnt/3600 );
			t._min 	= Math.floor( (t.option.secCnt%3600)/60 );
			t._sec 	= Math.round( (t.option.secCnt%3600)/60%1*60 );
			var timeInfo = {
					hour:t._hour,
					min:t._min,
					sec:t._sec 
			}
			var isEnd = (t._hour == 0 && t._min == 0 && t._sec == 0);
			// this.timer를 컨텍스트로하여 call한다,
			// 파라미터는 interval Id, 반복횟수, 시간정보 이다.
			callback.call(t, t.option.cnt , timeInfo, isEnd , interval);
		
			if( isEnd ){
				if( t.option.loop === false){
					// loop하지않는다면 타이머가 다됐을때 스톱
					clearInterval(interval);
					t.status = false;
				}else{
					// 아니면 다시 스타트
					t.option.secCnt = parseInt( t.option.sec , 10);
					t.status = true;
				}
			}else{
				t.status = true;
			}
		}else{
			clearInterval(interval);
			throw "callback 함수를 찾을 수 없습니다.";
		}
	}, 1000 );
	t.interval = interval;
	return t;
}
/**
 * 시간을 설정한다.(초단위)
 * @returns {ComLibTimer}
 */
ComLibTimer.prototype.setTime = function( sec ){
	this.option.sec = sec;
	this.option.secCnt = parseInt( sec , 10); 
	return this;
}
/**
 * 카운트를 초기화한다.
 * @returns {ComLibTimer}
 */
ComLibTimer.prototype.initCount = function(){
	this.option.cnt = 0;
	return this;
}


/**
 * 쿠키정보를 set , get, del 한다.
 * @class [Class] 브라우저 쿠키 관리 클래스
 * @example
 * 
 * var cookieMgr = new CookieManager();
 * var expiresOpt = { 
 * 			type : 'date'
 *			, time : 1 
 *	}
 *	cookieMgr.set( name, value,  expiresOpt )  : 쿠키를 생성한다.
 *	  # name : 쿠키 key값
 *	  # value : 쿠키 value값
 *	  # expiresOpt : 
 *	  	  - type : 만기일범위 타입 [ year, month, date, delete ]
 *	  	  - time : 만기일범위 [ date / 1 ==> 1일 ( 24시간 ) ]
 *
 *	cookieMgr.get(name) : name에 해당하는 쿠키 value를 가져온다.
 *	cookieMgr.del(name) : name에 해당하는 쿠키 정보를 삭제한다.
 */
function CookieManager(){};

CookieManager.prototype._trim = function( str ){
	return str.replace(/^\s*|\s*$/g,'');
};

/**
 * 내부에서 사용하는 쿠키 만기일 세팅 함수
 *
 * @param {String} 쿠키 만기 타입 [ 'year', 'month', 'date', 'delete' ]
 * @param {Number} 만기 범위 [ex) 만기타입 : 'date' , 만기범위 1 : 1일(24시간)]
 * @return {Date}
 */
CookieManager.prototype._setExpireDate = function( expireTp , expireDate){
	//오늘날짜를 구해온다
	var curDt = new Date();
		curDtTime = curDt.getTime();
	var y = curDt.getFullYear(),
		m = curDt.getMonth(),
		d = curDt.getDate();
	
	//문자열을 넣었을때는 0, 오늘날짜 반환
	if( isNaN( parseInt( expireDate, 10 ) ) ) return new Date().toUTCString();
	else expireDate = parseInt( expireDate ,  10);
	 
	// switch문에서 사용자가 입력한 type에따라 해당 항목에 date를 더한다.(기한) 년:365일/월:30일/일:1일 기준
	switch (expireTp.toUpperCase()) {
		case 'YEAR' : y = new Date( curDtTime + 1000 * 60 * 60 * 24 * 365 * expireDate ).getFullYear(); break;
		case 'MONTH': m = new Date( curDtTime + 1000 * 60 * 60 * 24 * 31 * expireDate ).getMonth();  break;
		case 'DATE' : d = new Date( curDtTime + 1000 * 60 * 60 * 24 * expireDate ).getDate();		 break;
		
		case 'DELETE':
				// delete인 경우 현재시간을 반환한다.
				return new Date().toUTCString();
			break;
		default:
			var tmpCur = new Date();
			y = tmpCur.getFullYear();
			m = tmpCur.getFullYear();
			d = tmpCur.getFullYear();
			break;
	}
	
	// 기한이 더해진 값을 반환함.
	return new Date( y , m , d ).toUTCString(); 
					
},
/**
 * 쿠키를 세팅(추가)한다.
 * 
 * @param {String} name : 쿠키 key 값
 * @param {String} value: 쿠키 밸류값
 * @param {Object} expireOption : 만기정보 (default: 24시간 )
 */
CookieManager.prototype.set = function(  name, value, expireOption  ){
	// 형태 : key=value;expires=date
	var ck = name + "=" + value +";" ;
	if( typeof expireOption == 'undefined' ){
		expireOption = {};
		expireOption.type = 'date';
		expireOption.time = 1;
	}
	ck +='expires='+this._setExpireDate(expireOption.type , expireOption.time );
	//브라우저 쿠키에 저장
	document.cookie = ck;
}
/**
 * 쿠키 데이터(정보)를 가져온다.
 * 
 * @param {String} name : 가져올 쿠키 key값
 * @return {String} value : 쿠키 정보 
 */
CookieManager.prototype.get = function ( name ){
	// 브라우저 쿠키정보를 `;` 로 split 한다.
	var cookies = document.cookie.split(';'), retVal;
		name    = this._trim( name );//trim
	// 쿠키개수만큼 반복하면서 비교 후, 값을 꺼내온다.
	for( var i=0,len=cookies.length;i<len;i++){
		var __data = cookies[i].split('='),
			 _name = this._trim( __data[0] );  //trim
		if( _name == name ){
			retVal = this._trim( __data[1] ); //trim
			break;
		} 
	}
	// 결과리턴( undefined or value )
	return retVal;
}
/**
 * 쿠키 정보를 삭제한다.
 * @param {String} name : 삭제할 쿠키 key 값
 */
CookieManager.prototype.del = function( name ){
	var expireOption = {
			type:'delete',
			tiem: -1
		};
	this.set(name,'', expireOption);
}


/**
 * 메시지 관리객체.<br/>
 * 메시지 창을 유연하게 관리하기 위한 객체.
 * 
 * @namespace
 */
var Message = {
		/**
		 * Alert 창을 띄운다.<br/>
		 * 플러그인을 사용할 경우 여기서 수정.<br/>
		 * Default : window 기본 alert();
		 * 
		 * @param {String} message
		 * @param {Function} callback
		 * @param {String} title
		 */
		alert : function(str,callback,title){
			try{
				$.jAlert({
					'title'		: title || '알림',
					'closeBtn': true,
					'content'	: str,
					'closeOnClick': true,
					'closeOnEsc': true,
					 'btns': { 
						 'text': '확인',
						 onClick:function(e,btn){
							 if(typeof callback == 'function' )callback(e,btn);
						 }
					}
				});
			}catch(e){
				alert(str);
			}
			
		},
		/**
		 * confirm창을 띄운다.
		 * 플러그인을 사용할 경우 여기서 수정.<br/>
		 * Default : window 기본 confirm();
		 * 
		 * @param {String} message
		 * @param {Function} callback
		 * @param {String} title
		 * @returns {Boolean}
		 */
		confirm :function(str,callback,title){
			try{
				$.jAlert({
					'title': title || '확인',
					'closeBtn': true,
					'closeOnEsc': true,
					'type':'confirm',
					'confirmBtnText':'확인',
					'denyBtnText'	:'취소',
					'confirmQuestion':str,
					 onConfirm:function(e,btn){
						 if(typeof callback == 'function' )callback(e,btn);
					 }
				});
			}catch(e){
				return confirm(str);
			}
		}
}