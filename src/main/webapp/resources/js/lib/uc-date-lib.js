/**
 * @Description : 날짜 관련 라이브러리
 * @Modification Information
 * 
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2016.05.09		이종욱          	최초 생성
 * 
 *  @namespace [Library] 날짜 관리/가공 관련 라이브러리
 *  @author 유채널(주) 개발팀 이종욱
 *  @since 2016.05.09
 *  @version 1.0
 */
var dateLib = {
		_fillZero:function( n ){
			return ( n < 10)? "0"+n:n;
		},
		_getDateFromString :function(str){
			
			if( str.length != 8) return new Date();
			
			var y , m , d ;
			y = str.substring(0,4);
			m = str.substring(4,6);
			d = str.substring(6);
			return new Date( y, parseInt( m ,10 )-1 , d);
		},
		_getDatePart : function( str , date ){
			//출처 : http://www.bsidesoft.com/
			switch (str) {
				case 'y':
					return this._getDatePart('Y',date).substring(2);
					break;
				case 'Y':
					return date.getFullYear()+"";
					break;
				case 'n':case'N':
					return date.getMonth();
					break;
				case 'm':case'M':
					return this._fillZero(  date.getMonth()+1  );
					break;
				case 'd':case'D':
					return this._fillZero(  date.getDate()  );
					break;
				case 'h':
					var h = date.getHours()%12;
					if( date.getHours() > 11 && h == 0) h = 12;
					return this._fillZero(  h  );
					break;
				case 'H':
					return this._fillZero(  date.getHours()  );
					break;
				case 'i':case'I':
					return this._fillZero(  date.getMinutes()  );
					break;
				case 's':case 'S':
					return this._fillZero(  date.getSeconds()  );
					break;
				
				case 'w':
			        switch( date.getDay() ){
			        case 0: return '일';
			        case 1: return '월';
			        case 2: return '화';
			        case 3: return '수';
			        case 4: return '목';
			        case 5: return '금';
			        case 6: return '토';
			    }
				case 'W':
					return this._getDatePart('w',date) + '요일';
				default:
					return str
					break;
			}
		},
		/**
		 * 날짜(Date객체)를 format에 맞춰 문자열로 반환한다.<br/>
		 * 두번째 파라미터로 Date 객체를 넘길 수 있다.<br/>
		 * 또한 'yyyymmdd' 형태의 8자리 문자열로 날짜를 넘길 수 있다. <br/>
		 * ('yyyymmdd'의 형태가 아닌경우 오늘날짜를 반환한다.)<br/>
		 * 두번째 파라미터를 넘기지 않는경우 오늘 날짜를 반환한다.
		 * 
		 * @example
		 * datelib.getDate() // '20160509' (오늘이 2016년5월9일일때)
		 * @example
		 * datelib.getDate('Y-m-d') // '2016-05-09' (오늘이 2016년5월9일일때)
		 * @example
		 * datelib.getDate('Y-m-d' , '20160409' ) // '2016-04-09'
		 * @example
		 * datelib.getDate('Y-m-d' , {DATE 객체} )
		 * 
		 * @param format : 날짜형식 <br/>
		 * 	- Y 	: 연도/FullYear ( yyyy ) <br/>
		 *  - y 	: 연도/Year ( yy )<br/>
		 *  - n,N 	: (+1 하지않은)달/month<br/>
		 *  - m,M 	: 달/month<br/>
		 *  - d,D 	: 날짜/date<br/>
		 *  - h 	: 시간( 12 )<br/>
		 *  - H		: 시간( 24 )<br/>
		 *  - i,I	: 분<br/>
		 *  - s,S	: 초<br/>
		 *  - w		: 요일(약어)<br/>
		 *  - W		: 요일(Full)<br/>
		 * @param {Date} date   : 문자열로 반환할 Date 객체<br/>
		 * @returns {String}
		 */
		getDate:function(format, date){
			
			var res = "";
			
			if( typeof date == 'undefined' ) {
				date = new Date();
			}else if( typeof date == 'string' ){
				date = this._getDateFromString( date );
			}
			
			if( typeof format != 'string')format = "Ymd";
			for(var i=0,len=format.length;i<len;i++){
				res += this._getDatePart( format.charAt(i) , date );
			}
			return res;
		},
		/**
		 * 오늘을 기준(또는 target 기준)으로<br/>
		 * 파라미터로 넘긴 날짜 수 만큼 계산하여 해당 날짜를 return한다.<br/>
		 * 파라미터를 넘기지 않으면 오늘날짜를 넘긴다.<br/>
		 * 
		 * @example
		 * dateLib.addDate( 2 ) // '20160512' (오늘이 2016년 5월 10일 일때 )
		 * @example
		 * dateLib.addDate( 2 , 'Y.m.d' ) // '2016.05.12' (오늘이 2016년 5월 10일 일때 )
		 * @example
		 * dateLib.addDate( 2 , 'Y.m.d', '20160501' ) // '2016.05.03'
		 * 
		 * @param {Number} addCnt  : 계산 일수 ex) -1 : 어제 , 0:오늘, 1:내일 
		 * @param {String} format : 날짜형식[y ,Y,m,d,H,h,i,s,w] ( 미입력시 Ymd )
		 * @param {String} target : 계산되어질 기준날짜(미입력시 오늘기준) 'yyyymmdd' 형태의 스트링 
		 * @returns {String} - format에 맞는 날짜 문자열
		 */
		addDate : function( date , format , target ){
			if( !date ) date = 0;
			var tmp = new Date();
			if( typeof target == 'string' )  tmp = this._getDateFromString( target );
			
			var dt = new Date( tmp.getTime() + ( 1000 * 60 * 60 * 24 * date ) );
			return this.getDate( format ,  dt );
		},
		/**
		 * 오늘을 기준(또는 target 기준)으로<br/>
		 * 파라미터로 넘긴 개월 수 만큼 계산하여 해당 날짜를 return한다.<br/>
		 * 파라미터를 넘기지 않으면 금월 날짜를 넘긴다.<br/>
		 * 
		 * @example
		 * dateLib.addMonth( 1 ) // '20160612' ( 오늘이 2016년 5월 12일 일 때 )
		 * @example
		 * dateLib.addMonth( 1, 'Y-m') // '2016-06' ( 오늘이 2016년 5월 12일 일 때 )
		 * @example
		 * dateLib.addMonth( 1, 'Y-m-d','20160401') // '2016-05-01'
		 * 
		 * @param {Number} addCnt : 계산 월수 ex) -1 : 이전달 , 0:이번달, 1:다음달 
		 * @param {String} format : 날짜형식[y ,Y,m,d,H,h,i,s,w] ( 미입력시 Ymd )
		 * @param {String} target : 계산되어질 기준날짜(미입력시 오늘기준) 'yyyymmdd' 형태의 스트링
		 * @returns {String}  - format에 맞는 날짜 문자열
		 */
		addMonth : function( month , format ,target){
			if( !month ) month = 0; 
			
			var tmp = new Date(); 
			if( typeof target == 'string' )  tmp = this._getDateFromString( target );
			
			var y = tmp.getFullYear() 
				, m = tmp.getMonth()
				, d = tmp.getDate();
			
			m += month;
			var dt = new Date( y , m , d );
			
			return this.getDate( format ,  dt );
		},
		/**
		 * 오늘(또는 target)을 기준으로<br/>
		 * 파라미터로 넘긴 년 수 만큼 계산하여 해당 날짜를 return한다.<br/>
		 * 파라미터를 넘기지 않으면 오늘날짜를 넘긴다.<br/>
		 * 
		 * @example
		 * dateLib.addYear( 1 ) // '20170512' ( 오늘이 2016년 5월 12일 일 때 )
		 * @example
		 * dateLib.addYear( 1, 'Y-m-d') // '2017-05-12' ( 오늘이 2016년 5월 12일 일 때 )
		 * @example
		 * dateLib.addYear( 1, 'Y-m-d','20160501') // '2017-05-01'
		 * 
		 * @param {Number} addCnt   : ex ) -1 : 작년 , 0:이번년 , 1: 내년 
		 * @param {String} format : 날짜형식[y ,Y,m,d,H,h,i,s,w] ( 미입력시 Ymd )
		 * @param {String} target : 계산되어질 기준날짜(미입력시 오늘기준) 'yyyymmdd' 형태의 스트링
		 * @returns {String} - format에 맞는 날짜 문자열
		 */
		addYear : function ( year , format, target ){
			return this.addMonth( 12 * year , format, target );
		},
		/**
		 * 윤년 구하기<br/>
		 * 파라미터로 넘긴 4자리의 숫자가 윤년인지 아닌지 boolean 으로 리턴.
		 *
		 * @example
		 * dateLib.isLeapYear( 2016 ); // true
		 * @example
		 * dateLib.isLeapYear( 2015 ); // false
		 * 
		 * @param {Number} year : 'yyyy' 형태의 숫자
		 * @returns {Boolean}
		 */
		isLeapYear : function ( year ){
			//출처 : http://www.bsidesoft.com/
			if( typeof year == 'string') year = parseInt( year , 10 );
		    return (year%4 == 0 && year%100 != 0 ) || year%400 == 0;
		},
		/**
		 * 날짜 차이 구하기 <br/>
		 * 두 날짜간의 일 수를 Number로 반환( 절대값으로 반환 )
		 * 
		 * @example
		 * dateLib.getDateDiff('20110509','20120509'); // 366
		 * @example
		 * dateLib.getDateDiff('20120509','20130509'); // 365
		 * @example
		 * dateLib.getDateDiff( new Date() ,'20150101') // 497 ( 오늘이 2016년 5월 12일 일 때 )
		 * 
		 * @param {String} oldDt : 이전날짜 ['yyyymmdd' 형태의 문자열 또는 Date 객체]
		 * @param {String} newDt : 나중날짜 ['yyyymmdd' 형태의 문자열 또는 Date 객체]
		 * @returns {Number} 두 날짜 사이의 일 수.
		 */
		getDateDiff: function( oldDt, newDt ){
			var diff, _old, _new;
			
			if(typeof oldDt == 'object'){
				_old = oldDt.getTime();
			}else if( typeof oldDt == 'string' ){
				_old = this._getDateFromString(oldDt).getTime();
			}else{
				return null;
			}
			
			if(typeof newDt == 'object'){
				_new = newDt.getTime();
			}else if( typeof newDt == 'string' ){
				_new = this._getDateFromString( newDt ).getTime();
			}else{
				return null;
			}
			
			diff = _new - _old;
			return Math.abs( Math.ceil( diff/(1000 * 60 * 60 * 24) ) );
		}
};