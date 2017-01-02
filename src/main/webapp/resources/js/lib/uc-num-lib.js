/**
 * @Description : 숫자 관련 라이브러리
 * @Modification Information
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2016.05.09		이종욱          	최초 생성
 *  @namespace [Library] 숫자 관련 라이브러리
 *  @author 유채널(주) 개발팀 이종욱
 *  @since 2016.05.09
 *  @version 1.0
 */
var numLib = {
		/**
		 * 숫자(배열)의 최대값을 반환.
		 * @example
		 * numLib.getMax([1,2,3,4,5]); // 5
		 * 
		 * @param arr
		 * @returns {Number}
		 */
		getMax:function( arr ){
			return arr.reduce( function ( p , c ) { return p > c ? p : c; });
		},
		/**
		 * 숫자(배열)의 최소값을 반환.
		 * @example
		 * numLib.getMin([1,2,3,4,5]); // 1
		 * 
		 * @param arr
		 * @returns {Number}
		 */
		getMin:function( arr ){
			 return arr.reduce( function ( p , c) { return p > c ? c : p; });
		},
		/**
		 * 숫자(배열)의 평균값을 반환.
		 * @example
		 * numLib.getAvg([1,2,3,4,5]); // 3
		 * 
		 * @param arr
		 * @returns {Number}
		 */
		getAvg : function( arr ){
			return this.getSum( arr ) / arr.length;
		},
		/**
		 * 숫자(배열)의 합계를 반환.
		 * @example
		 * numLib.getSum([1,2,3,4,5]); // 15
		 * 
		 * @param arr
		 * @returns {Number}
		 */
		getSum : function( arr ){
			return arr.reduce(function(p, c) { return p + c; });
		},
		/**
		 * 숫자를 객체화 시킴.<br/>
		 * 객체화 시킴으로써 변수에 담아놓고, <br/>
		 * <b>원천데이터는 유지한채로</b><br/>
		 * 숫자에대한 여러가지 함수들을 쓸 수 있음.<br/>
		 * API : {NewNum} class참조
		 * 
		 * @example
		 * # 프로퍼티
		 * 	- value					: 숫자정보
		 * # 사용가능 함수
		 * 	- .numberComma()		: 3자리마다 comma를 찍어서 반환 
		 * 	- .format( format )		: '#'을 포함한 포맷형태로 변환해서 반환 
		 * 	- .plus( num )			: `num`을 더한값을 반환 
		 * 	- .minus( num )			: `num`을 뺀 값을 반환
		 * 	- .divide( num )		: `num`을 나눈 값을 반환
		 * 	- .multiply( num )		: `num`을 곱한 값을 반환
		 * 	- .setValue( num )		: `num`을 새로운 value로 바꿈.
		 * 	- .getValue()			: 현재 value를 가져옴.
		 * 	- .toKor()				: 현재 value를 한글로 변환하여 반환.
		 * 
		 * ## 함수를 사용 하더라도 원천 데이터는 유지함.
		 * 
		 * @param {Number} num : 객체화시킬 숫자
		 * @returns {NewNum}
		 */
		newNum : function( num ){
			return  new NewNum( num );
		},
		/**
		 * 3자리마다 ,(콤마) 를 찍음.
		 * @example
		 * numLib.numberComma( 100000000 ) //"100,000,000"
		 * @param {Number} num : Number 또는 숫자로 변형 가능한 String
		 * @returns {String} : 3자리마다 , 가 찍힌 문자열
		 */
		numberComma:function( num ){
			if( isNaN( num ) ) return num;
			num += "";
			var tmp , tmp2="" , dot = num.indexOf(".");
			
			if( dot > -1 ){
				tmp2 = num.substring(dot);
				tmp = num.substring(0,dot);
			}else{
				tmp = num;
			}
			
			return ( tmp+"" ).replace(/\B(?=(\d{3})+(?!\d))/g, ',') + tmp2; 
		},
		/**
		 * ,(콤마) 를 제거한 숫자를 반환 
		 * 
		 * @example
		 * numLib.removeComma("100,000,000") // "100000000"
		 * 
		 * @param {String} strNum : 콤마가 포함되어있는 숫자
		 * @returns {String} : 콤마가 제거된 숫자의 문자열
		 */
		removeComma:function( strNum ){
			return strNum.replace( new RegExp(",","gi") ,"");
		},
		/**
		 * 사용자가 지정한 숫자 포맷을 리턴한다.<br/>
		 * 매칭되는 부분은 반드시 '#' 문자열을 사용한다.<br/>
		 * # 앞 뒤로 오는 문자열은 그대로 반영된다.
		 * 
		 * @example
		 * numLib.numberFormat( 1000000000 ,'#,###') // "1,000,000,000"
		 * @example
		 * numLib.numberFormat( 1000000000 ,'₩ #,###') //"₩ 1,000,000,000"
		 * @example
		 * numLib.numberFormat( 1000000000 ,'#,### 원') //"1,000,000,000 원"
		 * @example
		 * numLib.numberFormat( 1000000000 ,'오늘의 최저가 : #,### 원') //"오늘의 최저가 : 1,000,000,000 원"
		 * 
		 * @example
		 * #응용# : 문자열을 이용하여 템플릿 화 시킬 수 있다.
		 * numLib.numberFormat( "8801011111111" ,'######-#######') // "880101-1111111"
		 * numLib.numberFormat( "20160512" ,'####-##-##') // "2016-05-12"
		 * 
		 * @param {Number} num
		 * @param {String} format 두 개 이상의 '#'을 포함한 포맷형식
		 * @returns
		 */
		format : function(num, format){
			
			if( format.match(/#/g).length < 2 ) return null;
			
			var pre = format.indexOf( '#' )
				, suf = format.lastIndexOf( '#' )
				, preStr = format.substring(0,pre)
				, sufStr = format.substring(suf+1);
			
			var _fm = format.substring(pre,suf+1) 
				, numStr = num+""
				, newStr = "";
			var conitnue = false, j = _fm.length-1;
			for(var i=numStr.length-1,len=0;i>=len;i--){
				var ch = _fm[j--];
				switch( ch ){
					case '#':
						newStr = numStr[i] + newStr;
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
		_numInfo :{
			_kor1 :[ '','일','이','삼','사','오','육','칠','팔','구' ],
			_kor2 :[ '','십','백','천'],
			_kor3 :[ '', '만','억','조','경',"해","자","양","구","간","정","재","극","항하사","아승기","나유타","불가사의","무량대수"]
		},
		/**
		 * 숫자를 한글 숫자로 변환하여 반환.<br/>
		 * max : "구해구천구백구십구경", 999990000000000000000
		 * 
		 * @example
		 * numLib.toKor(999990000000000000000); // "구해구천구백구십구경"
		 * @example 
		 * numLib.toKor(100000000); // "일억"
		 * @example
		 * numLib.toKor(5390); // "오천삼백구십"
		 * 
		 * @param {Number} num
		 * @returns {String}
		 */
		toKor : function( num ){
			var tmp = "", t = this;
			// 4자리마다 자른 후 뒤집어서 배열화 함.
			var _split = t.format( num+"" ,"#,####") 
				, split = _split.split(",").reverse()
				, numInfo = t._numInfo;
			for( var k=0, len = split.length ; k < len ; k++){
				var j = 0 , pcs = split[k] , unitWord = "";
				for( var i = pcs.length-1; i>=0;i--){
					
					var kor = numInfo._kor1[ pcs.charAt(j++) ] // 숫자 한글변환 
						, unit = ( kor == '' ) ? '' : numInfo._kor2[i]; // 십,백,천 변환
					
					// 만단위 이상이고, 4자리씩끊었을때 마지막자리이고, 0000 이 아닌경우 숫자단위(만,억,경...)을 붙인다.
					if( k > 0 && i == 0 && parseInt( pcs ) )  unit +=  numInfo._kor3[k]; // 숫자 단위변환
					
					unitWord +=	kor + unit;
				}
				tmp = unitWord + tmp;
			}
			return tmp;
		}
};

/**
 * 숫자를 객체화 시킴.
 * @class [Class] 숫자를 객체화 시키는 클래스
 */
function NewNum( n ){
	this.setValue(n);
	return this;	
}
/**
 * 3자리마다 ,(콤마) 를 찍어서 반환
 * @example
 * var myNum = numLib.newNum(100000); 
 * myNum.numberComma(); //"100,000"
 * @returns {String}
 */
NewNum.prototype.numberComma = function(){
	return numLib.numberComma( this.value );
}

/**
 * 숫자를 한글 숫자로 변환하여 반환.<br/>
 * max : "구해구천구백구십구경", 999990000000000000000
 * 
 * @example
 * var myNum = numLib.newNum(5390);
 * myNum.toKor(); // "오천삼백구십" 
 * 
 * @returns {String}
 */
NewNum.prototype.toKor = function(){
	return numLib.toKor( this.value )
}
/**
 * 숫자에 대한 포맷을 지정하고, 적용하여 반환함.
 * 
 * @example
 * var myNum = numLib.newNum(100000); 
 * myNum.format('#,### 원'); //"100,000 원"
 * 
 * @param {String} format
 * @returns {String}
 */
NewNum.prototype.format = function( format ){
	return numLib.format( this.value , format);
}
/**
 * 숫자를 더함.
 * @example
 * var myNum = numLib.newNum(100000); 
 * myNum.plus( 500 ); // 100500
 * 
 * @param {Number} n
 * @returns {Number}
 */
NewNum.prototype.plus = function( n ){
	return this.value + n ;
}
/**
 * 숫자를 뺌
 * @example
 * var myNum = numLib.newNum(100000); 
 * myNum.minus( 500 ); // 99500
 * @param {Number} n
 * @returns {Number}
 */
NewNum.prototype.minus = function( n ){
	return this.value - n ;
}
/**
 * 숫자를 나눔
 * @example
 * var myNum = numLib.newNum(100000); 
 * myNum.divide( 500 ); // 200
 * 
 * @param {Number} n
 * @returns {Number}
 */
NewNum.prototype.divide = function( n ){
	return this.value / n ;
}
/**
 * 숫자를 곱함
 * @example
 * var myNum = numLib.newNum(100000); 
 * myNum.multiply( 2 ); // 200000
 * 
 * @param {Number} n
 * @returns {Number}
 */
NewNum.prototype.multiply = function( n ){
	return this.value * n ;
}

/**
 * 새로운 숫자를 세팅
 * @example
 * var myNum = numLib.newNum(100000); 
 * myNum.setValue( 5000 ); // NewNum { value: 5000 }
 * 
 * @param {Number} n
 * @returns {NewNum}
 */
NewNum.prototype.setValue = function( n ){
	this.value = parseInt( isNaN(n)?0:n , 10);
	return this;
}
/**
 * 세팅된 숫자를 반환
 * @example
 * var myNum = numLib.newNum( 5000 ); 
 * myNum.getValue(); // 5000
 * 
 * @returns {Number}
 */
NewNum.prototype.getValue = function(){
	return this.value;
}
/**
 * 숫자 증가
 * 
 * @example
 * var myNum = numLib.newNum( 5000 ); 
 * myNum.increase().increase().getValue(); // 5002
 * 
 * @param {Number} interval
 * @returns {NewNum}
 */
NewNum.prototype.increase = function(interval){
	if(!interval) interval = 1;
	this.value = this.value + interval;
	return this
}
/**
 * 숫자 감소
 * 
 * @example
 * var myNum = numLib.newNum( 5000 ); 
 * myNum.decrease().decrease().getValue(); // 4998
 * 
 * @param {Number} interval
 * @returns {NewNum}
 */
NewNum.prototype.decrease = function(interval){
	if(!interval) interval = 1;
	this.value = this.value - interval;
	return this
}