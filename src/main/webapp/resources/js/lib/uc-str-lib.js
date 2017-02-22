/**
 * @Description : 문자열 관련 라이브러리<br/>
 * @Modification Information
 * 
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2016.05.09		이종욱          	최초 생성
 *  @namespace [Library] 문자열 관련 라이브러리
 *  @author 유채널(주) 개발팀 이종욱
 *  @since 2016.05.09
 *  @version 1.0
 */
var strLib = {
		/**
		 * 한글관련 정보 객체 <br/>
		 * 초,중,종성을 관리하고 분리하는 함수를 포함 
		 */
		hanGeul :{
			/**
			 * 한글의 조사를 종성여부에 따라 나눈 데이터를 가지고있다.<br/>
			 * `배열의 형태`로 데이터가 존재하며,<br/>
			 * [ 0 : 종성없음 / 1 : 종성 있음 ] 이다.
			 * @namespace [Data] 종성에따라 달라지는 `조사` 데이터
			 */
			josa:{
				/**
				 * (주격) 은/는 - '민우<span style='color:red;'><b>는</b></span> 착함' vs '종욱<span style='color:red;'><b>은</b></span> 착함'
				 */
				unnun:['는','은'],
				/**
				 * (주격) 이/가 - '민우<span style='color:red;'><b>가</b></span> 먼저' vs '종욱<span style='color:red;'><b>이</b></span> 먼저'
				 */
				iga  :['가','이'],
				/**
				 * (병립) 와/과 - '민우<span style='color:red;'><b>와</b></span> 야근' vs '종욱<span style='color:red;'><b>과</b></span> 야근'
				 */
				wagwa:['와','과'],
				/**
				 * (목적,대상) 을/를 - '민우<span style='color:red;'><b>를</b></span> 칭찬' vs '종욱<span style='color:red;'><b>을</b></span> 칭찬'
				 */
				ullul:['를','을'],
				/**
				 * (목적,대상) 로/으로 - '민우<span style='color:red;'><b>로</b></span> 결정' vs '종욱<span style='color:red;'><b>으로</b></span> 결정'
				 */
				rouro:['로','으로']
			},
			// 유니코드 한글 시작 : 44032, 끝 : 55199
			_START_CODE : 44032,
			// 초성 코드
			_CHOSUNG : 588,
			// 중성 코드
			_JUNGSUNG : 28,
			// 초성 리스트. 00 ~ 18
		    _CHOSUNG_LIST : [
		        'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 
		        'ㅅ', 'ㅆ', 'ㅇ' , 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
		    ],
		    // 중성 리스트. 00 ~ 20
		    _JUNGSUNG_LIST : [
		        'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 
		        'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 
		        'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 
		        'ㅡ', 'ㅢ', 'ㅣ'
		    ],
		    // 종성 리스트. 00 ~ 27 + 1(1개 없음)
		    _JONGSUNG_LIST : [
		        ' ', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ',
		        'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 
		        'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 
		        'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
		    ],
		    //실질적으로 초,중,종성을 분리하는 함수 
		    _dismantle : function( str , onlyChosung){
		    	var t = this, result = [];
		    	if( str.charCodeAt(0) < t._START_CODE ){
		    		result.push( str );
		    		return result;
		    	}else{
		    		// 한글은 아래와 같은 방법으로 유니코드로 조합된다.
			        var ch = t._START_CODE + (0 * t._CHOSUNG + 2 * t._JUNGSUNG );
			 
			        // 한글을 초성, 중성, 종성으로 분리하기.
			        // t._START_CODE(4403244) 제거
			        var charTemp = str.charCodeAt(0) , cBase = charTemp - t._START_CODE;
			        
			        // 초성
			        var c1 = Math.floor( cBase / t._CHOSUNG );
			        result.push( t._CHOSUNG_LIST[c1] );
			        
			        // 중성
			        var c2 = Math.floor(  (cBase - (t._CHOSUNG * c1)) / t._JUNGSUNG );
			        if( onlyChosung !== true ) result.push( t._JUNGSUNG_LIST[c2] );
			         
			        // 종성
			        var c3 = Math.floor(  (cBase - (t._CHOSUNG * c1) - (t._JUNGSUNG * c2)) );
			        if( c3 > 0 && onlyChosung !== true){
			        	result.push( t._JONGSUNG_LIST[c3] );
			        }
			        return result;
		    	}
		    	
		    }
		},
		/**
		 * 종성여부를 확인하여 반환한다.<br/><br/>
		 * 
		 * 한글코드 = 종성 + 중성*28 + 초성*588 + 44032<br/>
		 * 한글코드-44032 = 종성 + 중성*28 + 초성*588<br/>
		 * 한글코드-44032 = 종성 + (중성 + 초성*21)*28<br/><br/>
		 *   
		 *   <b>종성 = ( 한글코드 - 44032 ) % 28</b>
		 *   
		 *   
		 * @param {String} str
		 * @returns {Number} 종성존재여부(0:없음,1:있음)
		 */
		hasJongsung: function( str ){
			var t = this.hanGeul;
			if( str.charCodeAt(0) < t._START_CODE ){
	    		return 1;
	    	}else{
		        return ( str.charCodeAt(0) - t._START_CODE ) % 28 > 0? 1 : 0;
	    	}
		},
		/**
		 * 문자열의 총 바이트 수를 구한다.<br/>
		 * 한글을 2Byte로 간주함.
		 * 
		 * @example
		 * strLib.getBytes("abc") // 3
		 * @example
		 * strLib.getBytes("가abc") // 5
		 * 
		 * @param {String} str : 바이트수를 구할 문자열
		 * @returns {Number} : 문자열의 바이트 수
		 */
		getBytes:function ( str ){
			var bytes = 0
			for(var i=0,len=str.length;i<len;i++){
				if( this.isHangeul( str.charAt(i) ) ){
					bytes += 2;
				}else{
					bytes += 1;
				}
			}
			return bytes;
		},

		/**
		 * 한글인지 아닌지 확인한다.( 한글자만 확인 후 반환 )
		 * 
		 * @example
		 * strLib.isHangeul('a') // false
		 * @example
		 * strLib.isHangeul('가') // true
		 * @example
		 * strLib.isHangeul('a가') // false ( 첫글자만 확인함 )
		 * 
		 * @param {String} ch : 한글인지 아닌지 확인할 문자열 1글자.
		 * @returns {Boolean} : 한글인지 아닌지를 반환
		 */
		isHangeul:function  (ch){
			var _ch = ch.charCodeAt(0);
			if( ( _ch >= 12593 && _ch <= 12643) || ( _ch >= 44032  && _ch <= 55175 ) ){
				return true;
			}else{
				return false;
			}
		},

		/**
		 * 한글을 2Byte로 간주 하고, maxByte만큼 자른 String을 반환
		 * 
		 * @example
		 * strLib.cutBytes("가나다", 5) // "가나 "
		 * @example
		 * strLib.cutBytes("가나a", 5) // "가나a"
		 * 
		 * @param {String} str : maxByte 수 만큼 자를 문자열
		 * @param {Number} maxByte : Max Byte 수 
		 * @returns {String}
		 */
		cutBytes:function( str , maxByte ){
			var b = this.getBytes(str);
			if( b > maxByte ){
				var diff = b-maxByte , length = str.length , lastChIdx = 0; 
				for( var i=length-1;i>=0;i--){
					if( this.isHangeul( str.charAt(i) )){
						b -= 2;
					}else{
						b -= 1;
					}
					if( b <= maxByte ){
						lastChIdx = i;
						break;
					}
				}
				var newStr = str.substring(0, lastChIdx );
				return this.cutBytes( newStr, maxByte );
			}else if( b < maxByte){
				var diff = maxByte-b;
				for(var i=0;i<diff;i++){
					str += ' ';
				}
				return str;
			}else{
				return str;
			}
		},
		
		 /**
	     * 한글의 초 / 중 / 종성을 분리한다.
	     * 
	     * @example
	     * string.dismantle() // ["ㅇ", "ㅠ", "ㅊ", "ㅐ", "ㄴ", "ㅓ", "ㄹ"]
	     * @example
	     * string.dismantle(true) // ["ㅇ", "ㅊ", "ㄴ"]
	     * 
	     * @param {String} str : 분리할 한글 문자열
	     * @param {Boolean} onlyChosung : 초성만 return받을지 여부
	     * @return {Array}
	     */
	    dismantle : function( str , onlyChosung ){
	    	var t = this, result = [];
	    	for( var i =0,len=str.length;i<len;i++){
		    	var tmp = this.hanGeul._dismantle( str.charAt(i) , onlyChosung);
		    	for(var j=0,jLen=tmp.length;j<jLen;j++){
		    		result.push( tmp[j] );
		    	}
	    	}
	    	return result;
	    },
	    /**
	     * under-score or under_score // camelCase 로 변환.
	     * @example
	     * strLib.toCamelCase('under-score') // 'underScore'
	     * @example
	     * strLib.toCamelCase('under_score') // 'underScore'
	     * @param {String} str : camelCase로 변환할 UNDER_SCORE 문자열
	     * @returns {String}
	     */
	    toCamelCase:function( str ){
	    	var tmp = "";
	    	var isUpper = false;
	    	for(var i=0,len=str.length;i<len;i++){
				var ch = str.charAt(i);
				if( ch == "_" || ch == "-" ){
					isUpper = true;
					continue;
				}else{
					if( isUpper ){
						tmp += ch.toUpperCase();
					}else{
						tmp += ch.toLowerCase();
					}
					isUpper = false;
				}
			}
	    	return tmp;
	    },
	    /**
	     * camelCase => under_score 형태로 변환
	     * @example
	     * strLib.toUnnderScore('camelCase') // 'camel_case'
	     * @example
	     * strLib.toUnnderScore('camelCase' ,true ) // 'CAMEL_CASE'
	     * @param {String}  str : UNDER_SCORE형태로 변환할 camelCase형태의 문자열
	     * @param {Boolean} isUpper : 대문자로 변환 여부 
	     * @returns
	     */
	    toUnderScore:function(str, isUpper , hipen){
	    	// camelCase -> _, 대문자 로 변경
	    	var splitStr = "_";
	    	if( hipen ) splitStr = '-';
			var tmp ="";
			for(var i=0,len=str.length;i<len;i++){
				var ch = str.charAt(i);
				if( ch.charCodeAt() > 57 && ch.charCodeAt() < 97	){
					tmp += splitStr+ch;
				}else{
					tmp += ch;
				}
			}
			if( isUpper ){
				return tmp.toUpperCase();
			}else{
				return tmp.toLowerCase();
			}
	    },
	    /**
	     * 문자열 사이의 공백(1칸이상의 공백)을 하나(1칸)로 생략함<br/>
	     * @example
	     * strLib.collapseSpace( '  공 \t\t 백 생략\t*\n  ')  // " 공 백 생략 * "
	     * @param {String} str : 공백을 1칸으로 생략할 문자열
	     * @returns {Strng}
	     */
	    collapseSpace:function( str ){
	    	return str.replace(/\s+/g,' ');
	    },
	    /**
	     * html entity로 변환한다.
	     * 
	     * @example
	     * var string = '&lt;div id=&quot;test&quot;&gt;&lt;/div&gt;';
	     * strLib.escapeHtml( string ) // '&amp;lt;div id = &amp;quot;test&amp;quot;&amp;gt;&amp;lt;/div&amp;gt;'
	     * @param {String} str : HTML 태그 문자열
	     * @returns {String}
	     */
	    escapeHtml:function( str ){
	    	return str.replace(/<|>|\"/g,function(item){
	    		var replace;
	    		switch(item){
	    			case "<":  	replace = "&lt;";    break;
	    			case ">":  	replace = "&gt;";    break;
	    			case "\"":  replace = "&quot;";  break;
	    			case "&":   replace = "&amp;";   break;
	    		}
	    		return replace;
	    	});
	    },
	    /**
	     * html entity를 unescape한다.
	     * 
	     * @example
	     * var string = '&amp;lt;div id= &amp;quot;test&amp;quot;&amp;gt;&amp;lt;/div&amp;gt;';
	     * strLib.unescapeHtml( string ) // '&lt;div id=&quot;test&quot;&gt;&lt;/div&gt;' 
	     * @param {String} str : escape된 HTML 문자열
	     * @returns {String}
	     */
	    unescapeHtml : function( str ){
	    	return str.replace(/(&quot;)|(&gt;)|(&lt;)/g,function(item){
	    		var replace;
	    		switch(item){
	    			case "&lt;":  	replace = "<";   break;
	    			case "&gt;":  	replace = ">";   break;
	    			case "&quot;":  replace = "\"";  break;
	    			case "&amp;":   replace = "&";   break;
	    		}
	    		return replace;
	    	});
	    },
	    
	    /**
	     * 반복할 문자열을 반복 횟수만큼 반복하여 반환한다.
	     * @example
	     * strLib.repeat("*" ,  10 ) // "**********"
	     * @param {String} str : 반복할 문자열
	     * @param {Number} cnt : 반복 횟수
	     * @returns {String}
	     */
	    repeat:function( str, cnt ){
	    	var tmp = "";
	    	for(var i=0;i<cnt;i++){
	    		tmp += str;
	    	}
	    	return tmp;
	    },
	    
	    /**
	     * 좌측으로부터 {N}개의 문자열을 가져옴<br/>
	     * {-N}인 경우 우측에서부터 가져옴.
	     * @example
	     * strLib.left("안녕하세요?",  2 ); // "안녕"
	     * @example
	     * strLib.left("안녕하세요?", -2 ); // "요?"
	     * 
	     * @param {String} str : 타겟 문자열
	     * @param {Number} idx : 좌측으로부터의 index값
	     * @returns {String}
	     */
	    left : function( str , idx){
	    	return ( idx > -1 )? str.substring( 0 , idx ) : this.right( str, -1 * idx ); 
	    },
	    
	    /**
	     * 우측으로부터 {N}개의 문자열을 가져옴<br/>
	     * {-N}인 경우 좌측에서부터 가져옴.
	     * @example
	     * strLib.right("안녕하세요?",  2 ); // "요?"
	     * @example
	     * strLib.right("안녕하세요?", -2 ); // "안녕"
	     * 
	     * @param {String} str : 타겟 문자열
	     * @param {Number} idx : 우측으로부터의 index값
	     * @returns {String}
	     */
	    right: function( str , idx){
	    	return ( idx > -1 )? str.substr( -1 * idx )   : this.left( str, -1 * idx );
	    },
	    
	    /**
	     * 시작Index부터 N개 까지의 문자열을 가져옴.<br/>
	     * ### index는 0부터 시작함. ###
	     * @example
	     * strLib.mid("안녕하세요?",  1 , 3); // "녕하세"
	     * @example
	     * strLib.mid("안녕하세요?",  1 ); // "녕하세요?"
	     * 
	     * @param {String} str : 타겟 문자열
	     * @param {Number} sIdx : 시작 Index
	     * @param {Number} eIdx : 끝 Index
	     * @returns {String}
	     */
	    mid: function(str, sIdx, eIdx){
	    	var getLen;
	    	if( eIdx ){
	    		getLen = eIdx - sIdx + 1;
	    	}else{
	    		getLen = str.length;  
	    	}
	    	return str.substr( sIdx, getLen );
	    },
	    
	    //------------------------------------------------------------------------------------------
	    
	    /**
	     * 정규식객체 관리
	     * @member {Object}
	     */
	    regExp :{
	    	format : new RegExp("{-?[0-9]+}", "g"),
	    	onlyNumber : new RegExp("-?[0-9]+", "g")
	    },
	    
	    /**
	     * 문자열 치환 함수.<br/>
	     * {0}, {1} , ... {N} 형태의 문자열을 <br/>
	     * 파라미터로 넘겨받은 Array와 매칭하여 치환한다.
	     * 
	     * @example
	     * strLib.format( "{0},{1},{2}" , ["가","나","다"] ) // "가,나,다";
	     * @example
	     * strLib.format( "{2},{1},{0}" , ["가","나","다"] ) // "다,나,가";
	     *  
	     * @param {String} str : 치환 타겟 문자열 
	     * @param {Array} args : 매칭될 문자열들이 담긴 배열
	     * @returns {String}
	     */
	    format : function (str, args) {
	    	var _regExp = this.regExp;
	        return str.replace( _regExp.format , function(item) {
	        	var _matched = item.match( _regExp.onlyNumber ) , intVal = ( _matched.length > 0 )? parseInt( _matched[0] , 10) : -1;
	            return (typeof args[intVal] != 'undefined')? args[intVal] : item;
	        });
	    },
	    /**
		 * 사용자가 지정한 포맷을 적용시켜 리턴한다.<br/>
		 * 문자열을 템플릿 화 시킬 수 있다.
		 * 매칭되는 부분은 반드시 '#' 문자열을 사용한다.<br/>
		 * # 앞 뒤로 오는 문자열은 그대로 반영된다.
		 * 
		 * @example
		 * strLib.templete( "8801011111111" ,'######-#######') // "880101-1111111"
		 * @example
		 * strLib.templete( "20160512" ,'####-##-##') // "2016-05-12"
		 * @example
		 * strLib.templete( "1000000000" ,'오늘의 최저가 : #,### 원') //"오늘의 최저가 : 1,000,000,000 원"
		 * 
		 * @param {String} str :
		 * @param {String} format 두 개 이상의 '#'을 포함한 포맷형식
		 * @returns
		 */
	    templete : function( str , format ){

			if( format.match(/#/g).length < 2 ) return null;
			
			var pre = format.indexOf( '#' )
				, suf = format.lastIndexOf( '#' )
				, preStr = format.substring(0,pre)
				, sufStr = format.substring(suf+1);
			
			var _fm = format.substring(pre,suf+1)
				, str = str+""
				, newStr = "";
			var conitnue = false, j = _fm.length-1;
			for(var i=str.length-1,len=0;i>=len;i--){
				var ch = _fm[j--];
				switch( ch ){
					case '#':
						newStr = str[i] + newStr;
						break;
					default:
						newStr = ch + newStr;
						i++;
						break;
				}
				if( j == -1 ) j = _fm.length-2;
			}
			newStr = preStr + newStr + sufStr;
			return newStr;
	    },
	    /**
	     * 문자열 치환함수.<br/>
	     * 첫번째 문자열에 대하여<br/>
	     * 두번째 파라미터와 매칭되는 모든 문자열을,<br/>
	     * 세번째 파라미터로 모두 치환한다.
	     * @example
	     * strLib.replaceAll( "대상 문자열 : 대상 STRING"  ,  "대상"  ,  "치환"  ) // "치환 문자열 : 치환 STRING";
	     * @example
	     * strLib.replaceAll( "*-*-*-*-"  ,  "*"  ,  " "  ) // "* * * * ";
	     * @param {String} str : 타겟 문자열 
	     * @param {String} oldChar : 대상 문자
	     * @param {String} newChar : 치환 문자
	     * @returns {String}
	     */
	    replaceAll : function (str, oldChar ,newChar) {
	    	if( typeof newChar == 'undefined') return str;
	    	var _oldChar = "";
	    	for( var i=0,len=oldChar.length;i<len;i++){
	    		var ch = oldChar.charAt(i);
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
	    		_oldChar += ch;
	    	}
	    	
	        return str.replace( new RegExp(_oldChar,"gm") ,newChar);
	    },
	    /**
	     * 여러개의 문자열을 제거한다.
	     * @example
	     * strLib.removes( "가/나/다/라/마/바/사/아" , ["가","나","다"]  ) // "///라/마/바/사/아";
	     * 
	     * @param {String} str : 타겟 문자열 
	     * @param {Array} args : 제거할 문자열을 담은 배열
	     * @returns {String}
	     */
	    removes : function( str, args ){
	    	var tmp = str;
	    	if( typeof args =='string' ){
	    		tmp =  tmp.replaceAll(args, '');
	    	}else{
	    		for(var i=0,len=args.length;i<len;i++){
	    			tmp =  tmp.replaceAll(args[i], '');
	    		}
	    	}
	    	return tmp;
	    },
	    /**
	     * 앞 , 뒤로 공백을 제거한다.
	     * @example
	     * strLib.trim( "\n\t    유채널 \n \t\t" ) // "유채널";
	     * @param {String} str : 타겟 문자열 
	     * @returns {String}
	     */
	    trim : function(str){
	    	return str.replace(/(^\s*)|(\s*$)/g,"");
	    },
	    /**
	     * 좌측의 공백만 모두 제거한다.
	     * @example
	     * strLib.trimLeft( "\n\t    유채널       " ) // "유채널       ";
	     * @param {String} str : 타겟 문자열 
	     * @returns {String}
	     */
	    trimLeft : function(str){
	    	return str.replace(/(^\s*)/g,"");
	    },
	    /**
	     * 우측의 공백만 모두 제거한다.
	     * @example
	     * strLib.trimRight( "    유채널    \n\t   " ) // "    유채널"
	     * @param {String} str : 타겟 문자열
	     * @returns {String}
	     */
	    trimRight : function(str){
	    	return str.replace(/(\s*$)/g,"");
	    },
	    /**
	     * String을 Binary로 변환하여 반환한다.
	     * @example
	     * strLib.toBin( "ABC", "/" ) // "1000001/1000010/1000011"
	     * 
	     * @param {String} str : 타겟 문자열
	     * @param div : 구분자
	     * @returns {String}
	     */
	    toBin : function( str, div ){
	    	var result = "", div = div || "";
	    	for(var i=0,len=str.length;i<len;i++){
	    		result += str.charCodeAt(i).toString(2);
	    		if( i < len-1 ) result += div;
	    	}
	    	return result;
	    },
	    /**
	     * String형태의 2진수 문자열을 10진수로 변환하여 반환한다.
	     * @example
	     * strLib.binToDec( "1011110") // 94
	     * @param {String} str : 타겟 문자열
	     * @returns {Number}
	     */
	    binToDec : function(str){
	    	return parseInt( str , 2 );
	    },

	    /**
	     * 문자열 중 포함하는 특정문자가 있는지 없는지 체크함.
	     * @example
	     * strLib.contains( "AAAAA D AAAAA", "D") // true
	     * @param {String} target : 대상 문자열
	     * @param {String} str : 찾을(포함되어지는) 문자
	     * @returns {Boolean}
	     */
	    contains : function( target, findStr ){
	    	return ( target.indexOf( findStr ) == -1 )? false:true;
	    },
	    /**
	     * 파라미터로 넘긴 문자열이 몇개나 존재하는지 갯수를 반환
	     * @example
	     * strLib.count( "AAAAA D AAAAA", "A") // 10
	     * @param {String} target : 타겟 문자열
	     * @param {String} str : 찾을 문자열
	     * @returns {Number} : 일치하는 문자열의 개수
	     */
	    count : function( target, str ){
	    	var reg = new RegExp( str, "gm" );
	    	try{
	    		return target.match(reg).length;
	    	}catch(e){
	    		return 0;
	    	}
	    },

	    /**
	     * max값 만큼 좌측으로 특정문자열(1byte)을 채운다
	     * @example
	     * strLib.fillLeft( "ABC", 10 ) // "       ABC" 
	     * @param {String} str : 타겟문자열
	     * @param {Number} max	: max length
	     * @param {String} ch	: 채울 문자열( default : ' ' )
	     * 
	     * @returns {String} 
	     */
	    fillLeft : function( str, max , ch ){
	    	if( ch && ch.length > 1 ) ch = ch.substring(0,1);
	    	var result = "" , _ch = ch || ' ';
	    	if( str.length < max ){
	    		var diff = max - str.length;
	    		for(var i=0;i<diff;i++){
	    			result += _ch;
	    		}
	    		result = result+str;
	    		return result;
	    	}else{
	    		return str.substring(0,max);
	    	}
	    },
	    /**
	     * max값 만큼 우측으로 특정문자열(1byte)을 채운다
	     * @example
	     * strLib.fillRight( "ABC", 10 ) // "ABC       "
	     * @param {String} str : 타겟문자열
	     * @param {Number} max	: max length
	     * @param {String} ch	: 채울 문자열( default : ' ' )
	     * 
	     * @returns {String} 
	     */
	    fillRight : function( str, max , ch ){
	    	if( ch && ch.length > 1 ) ch = ch.substring(0,1);
	    	var _ch = ch || ' ';
	    	if( str.length < max ){
	    		var diff = max - str.length;
	    		for(var i=0;i<diff;i++){
	    			str += _ch;
	    		}
	    		return str;
	    	}else{
	    		return str.substring(0,max);
	    	}
	    },
	    /**
	     * 왼쪽에 문자열을 붙인다.
	     * @example
	     * strLib.addLeft( "ABC", "!" ) // "!ABC"
	     * @param {String} target : 타겟문자열
	     * @param {String} addStr : 추가할 문자열
	     * @returns {String}
	     */
	    addLeft : function( target, addStr){
	    	return addStr + target;
	    },
	    /**
	     * 오른쪽에 문자열을 붙인다.
	     * @example
	     * strLib.addRight( "ABC", "!" ) // "ABC!"
	     * @param {String} target : 타겟문자열
	     * @param {String} str : 추가할문자열
	     * @returns {String}
	     */
	    addRight : function( target, addStr ){
	    	return target + addStr;
	    },
	    /**
	     * 
	     * 파라미터로 받은 문자열로 좌,우를 감싼다<br/>
	     * 두번째 파라미터 한개만 넘기면 해당 문자열로 양 쪽을 감싼다.
	     * @example
	     * strLib.wrapSide( "ABC", "~" ,"#" ) // "~ABC#"
	     * @example
	     * strLib.wrapSide( "ABC", "#" )	// "#ABC#"
	     * 
	     * @param {String} target : 타겟 문자열
	     * @param {String} left : 왼쪽에 추가할문자열
	     * @param {String} right : 오른쪽에 추가할문자열
	     * @returns {String}
	     */
	    wrapSide : function( target, left, right){
	    	if( !left ) left = "";
	    	if( !right ) right = left;
	    	return target.addLeft( left ).addRight( right );
	    },
	    /**
	     * 좌측으로부터 n개의 문자열개수(또는 byte 수)까지 자른 후<br/>
	     * "..." 로 생략하여 반환한다.
	     * 
	     * @example
	     * strLib.trunc("가나다라마",3,true); //"가 ..."
	     * @example
	     * strLib.trunc("가나다라마",3); //"가나다..."
	     * 
	     * @param str
	     * @param len
	     * @param isByte
	     * @returns {String}
	     */
	    trunc:function( str , len , isByte){
	    	var targetStr;
	    	if(isByte){
	    		targetStr = this.cutBytes(str, len);
	    	}else{
	    		targetStr = this.left(str, len);
	    	}
	    	var attch = "...";
	    	if( str == targetStr ) attch = "";
	    	return targetStr + attch;
	    }
};


/**
 *  -------------------------------------------------------  편의상 네이티브 함수( String )에도 직접 추가시킴.
 */

/**
 * 문자열의 총 바이트 수를 구한다.<br/>
 * 한글을 2Byte로 간주함.
 * 
 * @example
 * var string = "나a가ab";
 * string.getBytes() // 7
 * 
 * @returns {Number}
 */
String.prototype.getBytes = function (){
	var str = this , bytes = 0
	for(var i=0,len=str.length;i<len;i++){
		if( strLib.isHangeul( str.charAt(i) ) ){
			bytes += 2;
		}else{
			bytes += 1;
		}
	}
	return bytes;
}

/**
 * 한글을 2Byte로 간주 하고, maxByte만큼 자른 String을 반환 *
 * @example
 * var string = "나a가ab";
 * string.cutBytes(4) // "나a "
 * 
 * @param {Number} maxByte
 * @returns {String}
 */
String.prototype.cutBytes = function( maxByte ){
	var str = this , b = this.getBytes();
	if( b > maxByte ){
		var diff = b-maxByte , length = str.length , lastChIdx = 0; 
		for( var i=length-1;i>=0;i--){
			if( strLib.isHangeul( str.charAt(i) )){
				b -= 2;
			}else{
				b -= 1;
			}
			if( b <= maxByte ){
				lastChIdx = i;
				break;
			}
		}
		var newStr = str.substring(0, lastChIdx );
		return newStr.cutBytes( maxByte );
	}else if( b < maxByte){
		var diff = maxByte-b;
		for(var i=0;i<diff;i++){
			str += ' ';
		}
		return str;
	}else{
		return str;
	}
}

/**
 * 
 * 한글의 초 / 중 / 종성을 분리한다.
 * @example
 * var string = "유채널";
 * string.dismantle() // ["ㅇ", "ㅠ", "ㅊ", "ㅐ", "ㄴ", "ㅓ", "ㄹ"]
 * @example
 * var string = "유채널";
 * string.dismantle(true) // ["ㅇ", "ㅊ", "ㄴ"]
 * 
 * @param {Boolean} onlyChosung	: 초성만 return받을지 여부
 * @return {Array}
 */
String.prototype.dismantle = function( onlyChosung ){
	var str = this , t = strLib, result = [];
	for( var i =0,len=str.length;i<len;i++){
    	var tmp = t.hanGeul._dismantle( str.charAt(i) , onlyChosung);
    	for(var j=0,jLen=tmp.length;j<jLen;j++){
    		result.push( tmp[j] );
    	}
	}
	return result;
}

/**
 * under-score or under_score // camelCase 로 변환.<br/>
 * 
 * @example
 * var string = "under-score-example"; 
 * string.toCamelCase() // "underScoreExample" <br/>
 * @example 
 * var string = "under_score_example";
 * string.toCamelCase() // "underScoreExample"
 * 
 * @returns {String}
 */
String.prototype.toCamelCase = function(){
	var str = this , tmp = "" , isUpper = false;
	for(var i=0,len=str.length;i<len;i++){
		var ch = str.charAt(i);
		if( ch == "_" || ch == "-" ){
			isUpper = true;
			continue;
		}else{
			if( isUpper ){
				tmp += ch.toUpperCase();
			}else{
				tmp += ch.toLowerCase();
			}
			isUpper = false;
		}
	}
	return tmp;
}

/**
 * camelCase => under_score 형태로 변환<br/>
 * 
 * @example
 * var string = "underScoreExample";
 * string.toUnnderScore() // "under_score_example";
 * @example
 * var string = "underScoreExample";
 * string.toUnnderScore(true) // ""UNDER_SCORE_EXAMPLE"";<br/>
 * 
 * @param {String}  str : camelCase형태의 문자열
 * @param {Boolean} isUpper : 대문자로 변환 여부 
 * @returns {String}
 */
String.prototype.toUnnderScore = function( isUpper ){
	// camelCase -> _, 대문자 로 변경
	var str = this, tmp ="";
	for(var i=0,len=str.length;i<len;i++){
		var ch = str.charAt(i);
		if( ch.charCodeAt() < 97 ){
			tmp += "_"+ch;
		}else{
			tmp += ch;
		}
	}
	if( isUpper ){
		return tmp.toUpperCase();
	}else{
		return tmp.toLowerCase();
	}
}

/**
 * 문자열 사이의 공백(1칸이상의 공백)을 하나(1칸)로 생략함
 * @example
 * '  문자열 \t    사이의 공백을   \t\n\t 하나로 생략함\t*\n  '.collapseSpace();
 * &nbsp;&nbsp;&nbsp;&nbsp;// " 문자열 사이의 공백을 하나로 생략함 * "
 * @returns {Strng}
 * 
 */
String.prototype.collapseSpace = function(){
	return this.replace(/\s+/g,' ');
}

/**
 * html entity로 변환한다.
 * @example
 * var string = '&lt;div id=&quot;test&quot;&gt;&lt;/div&gt;'
 * string.escapeHtml() // '&amp;lt;div id = &amp;quot;test&amp;quot;&amp;gt;&amp;lt;/div&amp;gt;'
 * @returns {String}
 */
String.prototype.escapeHtml = function(){
	return this.replace(/<|>|\"/g,function(item){
		var replace;
		switch(item){
			case "<":  	replace = "&lt;";    break;
			case ">":  	replace = "&gt;";    break;
			case "\"":  replace = "&quot;";  break;
			case "&":  replace = "&amp;";  break;
		}
		return replace;
	});
}

/**
 * html entity를 unescape한다.
 * @example
 * var string = '&amp;lt;div id= &amp;quot;test&amp;quot;&amp;gt;&amp;lt;/div&amp;gt; '
 * string.unescapeHtml() // '&lt;div id=&quot;test&quot;&gt;&lt;/div&gt;'
 * @returns {String}
 */
String.prototype.unescapeHtml  = function(){
	return this.replace(/(&quot;)|(&gt;)|(&lt;)/g,function(item){
		var replace;
		switch(item){
			case "&lt;":  	replace = "<";   break;
			case "&gt;":  	replace = ">";   break;
			case "&quot;":  replace = "\"";  break;
			case "&amp;":  replace = "&";  break;
		}
		return replace;
	});
}

/**
 * 반복할 문자열을 반복 횟수만큼 반복하여 반환한다.
 * @example
 * "*".repeat(10) // "**********"
 * 
 * @param {Number} cnt : 반복 횟수
 * @returns {String}
 */
String.prototype.repeat = function( cnt ){
	var str = this , tmp = "";
	for(var i=0;i<cnt;i++){
		tmp += str;
	}
	return tmp;
}

/**
 * 좌측으로부터 {N}개의 문자열을 가져옴<br/>
 * {-N}인 경우 우측에서부터 가져옴.
 * @example
 * var string = "안녕하세요?";
 * string.left( 2 ); // "안녕"
 * @example
 * var string = "안녕하세요?";
 * string.left( -2 ); // "요?"
 * 
 * @param {Number} idx
 * @returns {String}
 */
String.prototype.left = function(idx){
	var str = this;
	return ( idx > -1 )? str.substring( 0 , idx ) : str.right( -1 * idx ); 
}

/**
 * 우측으로부터 {N}개의 문자열을 가져옴<br/>
 * {-N}인 경우 좌측에서부터 가져옴.
 * @example
 * var string = "안녕하세요?";
 * string.right( 2 ); // "요?"
 * @example
 * var string = "안녕하세요?";
 * string.right( -2 ); // "안녕"
 * 
 * @param {Number} idx
 * @returns {String}
 */
String.prototype.right = function( idx){
	var str = this;
	return ( idx > -1 )? str.substr( -1 * idx )   : str.left( -1 * idx );
}

/**
 * 시작Index ~ 끝Index 까지의 문자열을 가져옴.<br/>
 * ### index는 0부터 시작함. ###
 * @example
 * var string = "안녕하세요?";
 * string.mid("안녕하세요?",  1 , 3); // "녕하세"
 * @example
 * var string = "안녕하세요?";
 * string.mid("안녕하세요?",  1 ); // "녕하세요?"
 * 
 * @param {Number} sIdx
 * @param {Number} eIdx
 * @returns {String}
 */
String.prototype.mid =  function(sIdx, eIdx){
	var str = this, getLen;
	if( eIdx ){
		getLen = eIdx - sIdx + 1;
	}else{
		getLen = str.length;  
	}
	return str.substr( sIdx, getLen );
}

/**
 * 문자열 치환 함수.<br/>
 * {0}, {1} , ... {N} 형태의 문자열을 <br/>
 * 파라미터로 넘겨받은 Array와 매칭하여 치환한다.
 * @example
 * var string = "안녕하세요? {0} 입니다."; 
 * string.format(["유채널"]); // "안녕하세요? 유채널 입니다."; 
 * 
 * @param {Array} args 
 * @returns {String}
 */
String.prototype.format = function (args) {
    var str = this;
    return str.replace(String.prototype.format.regex, function(item) {
    	var _matched = item.match(/-?[0-9]+/g) , intVal = ( _matched.length > 0 )? parseInt( _matched[0] , 10) : -1;
        return (typeof args[intVal] != 'undefined')? args[intVal] : item ;
    });
};
String.prototype.format.regex = new RegExp("{-?[0-9]+}", "g");

/**
 * 문자열 치환함수.<br/>
 * 첫번째 파라미터와 매칭되는 모든 문자열을,<br/>
 * 두번째 파라미터로 모두 치환한다. 
 * @example
 * var string = "간장공장 공장장";
 * string.replaceAll( "공장", "" ); // "간장 장";
 * 
 * @param {String} oldChar
 * @param {String} newChar
 * @returns {String}
 */
String.prototype.replaceAll = function (oldChar ,newChar) {
	if(typeof newChar =='undefined' ) return this.toString();
	var _oldChar = "";
	for( var i=0,len=oldChar.length;i<len;i++){
		var ch = oldChar.charAt(i);
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
		_oldChar += ch;
	}
    return this.replace( new RegExp(_oldChar,"gm") ,newChar);
};
/**
 * 여러개의 문자열을 제거한다.
 * @example
 * var string = "가/나/다/라/마/바/사/아";
 * string.removes( ["가","나","다"]  ) // "///라/마/바/사/아";
 * 
 * @param {Array} args : 제거할 문자열을 담은 배열
 * @returns {String}
 */
String.prototype.removes = function( args ){
	var tmp = this;
	if( typeof args == 'string'){
		tmp =  tmp.replaceAll(args, '');
	}else{
		for(var i=0,len=args.length;i<len;i++){
			tmp =  tmp.replaceAll(args[i], '');
		}
	}
	return tmp;
}
/**
 * 앞 , 뒤로 공백을 제거한다.
 * @example
 * var string = "      유채널   ";
 * string.trim(); // "유채널";
 * 
 * @returns {String}
 */
String.prototype.trim = function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}
/**
 * 좌측의 공백만 모두 제거한다.
 * 
 * @example
 * var string = "      유채널   ";
 * string.trimLeft(); // "유채널   ";
 * 
 * @returns {String}
 */
String.prototype.trimLeft = function(){
	return this.replace(/(^\s*)/g,"");
}
/**
 * 우측의 공백만 모두 제거한다.
 * @example
 * var string = "      유채널   ";
 * string.trimRight(); // "      유채널";
 * 
 * @returns {String}
 */
String.prototype.trimRight = function(){
	return this.replace(/(\s*$)/g,"");
}

/**
 * String을 Binary로 변환하여 반환한다.
 * 
 * @example
 * var string = "ABC";
 * string.toBin( "/" ); // "1000001/1000010/1000011"
 * @example
 * var string = "ABC";
 * string.toBin() // "100000110000101000011"
 * 
 * @param {String} div : 구분자
 * @returns {String}
 */
String.prototype.toBin = function( div ){
	var result = "", div = div || "";
	for(var i=0,len=this.length;i<len;i++){
		result += this.charCodeAt(i).toString(2);
		if( i < len-1 ) result += div;
	}
	return result;
}
/**
 * String형태의 2진수 문자열을 10진수로 변환하여 반환한다.<br/><br/>
 * 
 * @example
 * var string = "1011110";
 * string.binToDec() // 94
 * 
 * @returns {Number}
 */
String.prototype.binToDec = function(){
	return parseInt( this, 2 );
}

/**
 * 문자열 중 포함하는 특정문자가 있는지 없는지 체크함.
 * 
 * @example
 * var string = "AAAAA D AAAAA";
 * string.contains("D") // true
 * 
 * @param {String} str : 포함되어지는 문자
 * @returns {Boolean}
 */
String.prototype.contains = function( str ){
	return ( this.indexOf( str ) == -1 )? false:true;
}
/**
 * 파라미터로 넘긴 문자열이 몇개나 존재하는지 갯수를 반환
 * 
 * @example
 * var string =  "AAAAA D AAAAA";
 * string.count("A") // 10
 * 
 * @param {String} str
 * @returns {Number}
 */
String.prototype.count = function( str ){
	var reg = new RegExp( str, "gm" );
	return this.match(reg).length;
}

/**
 * max값 까지 좌측으로 특정문자열(1byte)을 채운다 
 * 
 * @example
 * var string = "ABC";
 * string.fillLeft( 10 ); // "       ABC"
 * @example
 * var string = "ABC";
 * string.fillLeft( 10 ,'0' ); // "0000000ABC"
 * 
 * @param {Number} max	: max length
 * @param {String} ch	: 채울 문자열( default : ' ' )
 * 
 * @returns {String} 
 */
String.prototype.fillLeft = function( max , ch ){
	var str = this; 
	if( ch && ch.length > 1 ) ch = ch.substring(0,1);
	var result = "" , _ch = ch || ' ';
	if( str.length < max ){
		var diff = max - str.length;
		for(var i=0;i<diff;i++){
			result += _ch;
		}
		result = result+str;
		return result;
	}else{
		return str.substring(0,max);
	}
}
/**
 * max값 까지 우측으로 특정문자열(1byte)을 채운다 
 * 
 * @example
 * var string = "ABC";
 * string.fillRight( 10 ); // "ABC       "
 * @example
 * var string = "ABC";
 * string.fillRight( 10 , '0' ); // "ABC0000000"
 * 
 * @param {Number} max	: max length
 * @param {String} ch	: 채울 문자열( default : ' ' )
 * 
 * @returns {String} 
 */
String.prototype.fillRight = function( max , ch ){
	var str = this; 
	if( ch && ch.length > 1 ) ch = ch.substring(0,1);
	var _ch = ch || ' ';
	if( str.length < max ){
		var diff = max - str.length;
		for(var i=0;i<diff;i++){
			str += _ch;
		}
		return str;
	}else{
		return str.substring(0,max);
	}
}
/**
 * 왼쪽에 문자열을 붙인다.
 * @example
 * var string = "div/&gt;";
 * string.addLeft( "&lt;" ) // "&lt;div/&gt;"
 * 
 * @param {String} str
 * @returns {String}
 */
String.prototype.addLeft=function( str ){
	return str + this;
}

/**
 * 오른쪽에 문자열을 붙인다.
 * @example
 * var string = "&lt;div";
 * string.addRight( "/&gt;" ) // "&lt;div/&gt;"
 * 
 * @param {String} str
 * @returns {String}
 */
String.prototype.addRight=function( str ){
	return this + str;
}
/**
 * 
 * 파라미터로 받은 문자열로 좌,우를 감싼다
 * @example
 * var string = "ABC";
 * string.wrapSide( "~" ,"#" ) // "~ABC#"
 * @example
 * var string = "ABC";
 * string.wrapSide( "#" )	// "#ABC#"
 * 
 * @param {String} left
 * @param {String} right
 * @returns {String}
 */
String.prototype.wrapSide = function( left, right){
	if( !left ) left = "";
	if( !right ) right = left;
	return this.addLeft( left ).addRight( right );
}
/**
 * 사용자가 지정한 포맷을 적용시켜 리턴한다.<br/>
 * 문자열을 템플릿 화 시킬 수 있다.
 * 매칭되는 부분은 반드시 '#' 문자열을 사용한다.<br/>
 * # 앞 뒤로 오는 문자열은 그대로 반영된다.
 * 
 * @example
 * var string = "8801011111111";
 * string.templete( '######-#######') // "880101-1111111"
 * @example
 * var string = "20160512";
 * string.templete( '####-##-##') // "2016-05-12"
 * @example
 * var string = "1000000000";
 * string.templete( '오늘의 최저가 : #,### 원') // "오늘의 최저가 : 1,000,000,000 원"
 * 
 * @param {String} str :
 * @param {String} format 두 개 이상의 '#'을 포함한 포맷형식
 * @returns
 */
String.prototype.templete = function( format ){
	
	if( format.match(/#/g).length < 2 ) return null;
	
	var pre = format.indexOf( '#' )
		, suf = format.lastIndexOf( '#' )
		, preStr = format.substring(0,pre)
		, sufStr = format.substring(suf+1);
	
	var _fm = format.substring(pre,suf+1)
		, str = this
		, newStr = "";
	var conitnue = false, j = _fm.length-1;
	for(var i=str.length-1,len=0;i>=len;i--){
		var ch = _fm[j--];
		switch( ch ){
			case '#':
				newStr = str[i] + newStr;
				break;
			default:
				newStr = ch + newStr;
				i++;
				break;
		}
		if( j == -1 ) j = _fm.length-2;
	}
	newStr = preStr + newStr + sufStr;
	return newStr;
}
/**
 * 좌측으로부터 n개의 문자열개수(또는 byte 수)까지 자른 후<br/>
 * "..." 로 생략하여 반환한다.
 * 
 * @example
 * strLib.trunc("가나다라마",3,true); //"가 ..."
 * @example
 * strLib.trunc("가나다라마",3); //"가나다..."
 * 
 * @param len
 * @param isByte
 * @returns {String}
 */
String.prototype.trunc = function( len , isByte){
	var str = this,targetStr;
	if(isByte){
		targetStr = this.cutBytes(str, len);
	}else{
		targetStr = this.left(str, len);
	}
	return targetStr + "...";
}
/**
 * 종성여부를 확인하여 반환한다.<br/><br/>
 * 
 * 한글코드 = 종성 + 중성*28 + 초성*588 + 44032<br/>
 * 한글코드-44032 = 종성 + 중성*28 + 초성*588<br/>
 * 한글코드-44032 = 종성 + (중성 + 초성*21)*28<br/><br/>
 *   
 *   <b>종성 = ( 한글코드 - 44032 ) % 28</b>
 *   
 * @returns {Number} 종성존재여부(0:없음,1:있음)
 */
String.prototype.hasJongsung= function(){
	var str = this;
	if( str.charCodeAt(0) < 44032 ){
		return 1;
	}else{
        return ( str.charCodeAt(0) - 44032 ) % 28 > 0? 1 : 0;
	}
}