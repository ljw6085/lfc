/**
 * @Description : j-timer. 타이머
 * @Modification Information
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2017.04.12		이종욱          	최초 생성
 *  @namespace 
 *  @author 이종욱
 *  @since 2017.04.12
 *  @version 1.0
 */

var jTimer = {
		/**
		 * 타이머생성
		 * option : {
		 * 		sec : 'Number'
		 * 		,isLoop : 'Boolean' //반복여부
		 * }
		 * ,callback : function( cnt ,timeInfo ,interval) {}
		 */
		create:function( option , callback){
			var sec 		= option.sec ? option.sec : 0 
				, callback 	=  typeof callback == 'function' ? callback : function(){} 
				, loop 		=  option.isLoop; 
			var timer = new ComLibTimer(sec, callback, loop);
			return timer;
		}
}
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
ComLibTimer.prototype = {
	/**
	 * 타이머를 멈춘다.
	 * @returns {ComLibTimer}
	 */
	stop : function (){
		this._stop(true);
		return this;
	}
	/**
	 * 타이머를 일시정지한다.
	 * @returns {ComLibTimer}
	 */
	,pasue : function (){
		this._stop(false);
		return this;
	}
	,_stop : function (isClear){
		var t= this;
		if(isClear) t.option.secCnt = parseInt( t.option.sec , 10); 
		clearInterval(t.interval);
		t.status = false;
	}
	/**
	 * 타이머를 시작한다.
	 * @returns {ComLibTimer}
	 */
	,start : function (){
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
						sec:t._sec,
						totalSec:t.option.secCnt
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
	,setTime : function( sec ){
		this.option.sec = sec;
		this.option.secCnt = parseInt( sec , 10); 
		return this;
	}
	/**
	 * 카운트를 초기화한다.
	 * @returns {ComLibTimer}
	 */
	,initCount : function(){
		this.option.cnt = 0;
		return this;
	}
}