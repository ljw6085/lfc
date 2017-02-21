/**
 * @Description : object , array 등 data 가공 관련 라이브러리
 * @Modification Information
 * @   수정일		수정자				수정내용
 * @ ----------	   --------    ---------------------------
 * @ 2016.05.09		이종욱          	최초 생성
 *  @namespace [Library] Object,Array 등 데이터 가공 관련 라이브러리
 *  @author 유채널(주) 개발팀 이종욱
 *  @since 2016.05.09
 *  @version 1.0
 */
var dataLib = {
		/**
		 * Object의 key를 배열로 반환한다.
		 * 
		 * @example
		 * dataLib.getObjectKeys({'key01':'data01','key02':'data02'}); // ["key01", "key02"]
		 * 
		 * @param {Object} object
		 * @returns {Array} - Object의 key가 담긴 배열
		 */
		keys:function( o ){
			var a = [];
			for( var k in o ) a.push(k);
			return a;
		},
		/**
		 * undefined , null 만 체크 한다.
		 * 
		 * @example
		 * var undef;
		 * dataLib.isEmpty( undef ); // true
		 * @example
		 * dataLib.isEmpty( null ); //true
		 * 
		 * @param target
		 * @returns {Boolean}
		 */
		isEmpty : function( target ){
			var result;
			result = ( typeof target == 'undefined' )? true
						: null == target ? true
							: false;
			return result;
		},
		/**
		 * typeof 와 같은 기능을 함.<br/>
		 * Array , RegExp, Json 까지 구분할 수 있음.
		 * 
		 * @example
		 * dataLib.type( {} ); // 'object';
		 * @example
		 * dataLib.type( [] ); // 'array';
		 * @example
		 * dataLib.type( ' ' ); // 'string';
		 * @example
		 * dataLib.type( 1 ); // 'number';
		 * @example
		 * dataLib.type( true ); // 'boolean';
		 * @example
		 * dataLib.type( JSON ); // 'json';
		 * @example
		 * dataLib.type( new RegExp() ); // 'regexp';
		 * 
		 * 
		 * @param  target : type을 비교할 대상 
		 * @returns {String}
		 */
		type : function( o ){
			//출처 : http://youmightnotneedjquery.com/
			return Object.prototype.toString.call( o ).replace(/^\[object (.+)\]$/, '$1').toLowerCase();
		},
		/**
		 * 배열 Sorting 함수<br/>
		 * 배열에 존재하는 string, number, date, object 타입을 비교.<br/>
		 * object 타입의 경우 옵션에서 key값을 넘겨줘야 함.<br/><br/>
		 * 
		 * 정렬 후 바로 실행 할 함수를 세번째 파라미터로 넘겨줄 수 있다.
		 * 
		 * @example
		 * var array = [5,3,1,2,4]; 
		 * dataLib.sorting( array );
		 * //[1, 2, 3, 4, 5]
		 * @example 
		 * var array = [5,3,1,2,4]; 
		 * dataLib.sorting( array ,{ 
		 * 	orderby:'desc' 
		 * });
		 * //[5, 4, 3, 2, 1]
		 *
		 * @example
		 * var array = ['1','10','2','3']; 
		 * dataLib.sorting( array ,{ 
		 * 	sorttype :<b>'string'</b>
		 * });
		 * // ["1", "10", "2", "3"]
		 * 
		 * @example
		 * var array = ['1','10','2','3']; 
		 * dataLib.sorting( array ,{ 
		 * 	sorttype :<b>'number'</b>
		 * });
		 * // ["1", "2", "3", "10"]
		 * @example 
		 * var array = [{key:'2'},{key:'10'},{key:'1'},{key:'3'}]; 
		 * dataLib.sorting( array ,{ 
		 * 	<b>compareKey : 'key'
		 * 	, sorttype : 'number'</b>
		 * });
		 * // [{key:'1'},{key:'2'},{key:'3'},{key:'10'}]
		 * @example
		 * var array = [{key:'2'},{key:'10'},{key:'1'},{key:'3'}]; 
		 * dataLib.sorting( array ,{ 
		 * 	<b>compareKey : 'key'
		 * 	, sorttype :'string'</b>
		 * });
		 * // [{key:'1'},{key:'10'},{key:'2'},{key:'3'}]
		 * 
		 * 
		 * @param {Array} arr : Sorting 대상 배열
		 * @param {Object} sortOption 
		 * : {<br/>
		 * 	orderby : 'asc' [or 'desc'],<br/>
		 * 	sorttype : 'string' [, 'number'],<br/>
		 * 	compareKey : 'key'[ : 'object의 비교 key 값'] <br/>
		 * }<br/>
		 * @param {Function} callback
		 * @returns {Array}
		 */
		sorting : function( arr , sortOpt, callback ){
				if( !sortOpt ) sortOpt = {};
				var t = arr;
				var OBJ = 'object'
					, STR = 'string'
					, NUM = 'number'
					, ASC = 'asc'
					, DESC = 'desc'
					, orderby = sortOpt.orderby || 'asc'
					, sorttype = sortOpt.sorttype
					, compareKey = sortOpt.compareKey;
				
				function sortFunc( v1, v2 ){
					var _v1Type = typeof v1;
					var _v2Type = typeof v1;
					
					switch(true){
						case v1 instanceof Date && v2 instanceof Date :
							
							v1 = v1.getTime(), v2 = v2.getTime();
							if( orderby == DESC ) return v2-v1;
							else return v1-v2;
							
							break;
						case _v1Type === OBJ && _v2Type === OBJ : 
							return sortObject( v1 , v2 , compareKey );
							break;
						case ( _v1Type === STR && _v2Type === STR ) || sorttype == STR :
							return sortString( v1, v2, orderby);
							break;
						case ( _v1Type === NUM && _v2Type === NUM ) || sorttype == NUM :
							if( orderby == DESC ) return v2-v1;
							else return v1-v2;
							break;
						default:break;
					}
					
				}
				
				function sortString( v1 , v2 , order ){
					if( sorttype ==  NUM){
						v1 = parseFloat( v1 , 10 );
						v2 = parseFloat( v2 , 10 )
					}
					if( order == ASC){
						if( v1 > v2 ) return 1;
						else if( v1 < v2 )return -1;
						else return 0;
					}else{
						if( v1 > v2 )return -1;
						else if( v1 < v2 )return 1;
						else return 0;
					}
				}
				
				function sortObject( v1, v2, key){
					var _v1 = v1[key], _v2 = v2[key];
					
					if( sorttype === NUM ){
						_v1 = parseFloat( _v1 , 10 );
						_v2 = parseFloat( _v2 , 10 );
					}
					return sortFunc( _v1 , _v2 );
				}
				
				// sort 실행
				var t = arr.sort(sortFunc);
				if( typeof callback == 'function') callback.call(arr, t );
				return t;
		},
		
		//--------------------- array
		/**
		 * Array에 대해 filter 조건에 충족하는 데이터만 뽑아낸다.<br/>
		 * filter 는 함수형태로 넘기며 return Type이 반드시 Boolean 이어야 한다.
		 * 
		 * @example
		 * var arr = [ 1,2,'삼',4,'오' ];
		 * dataLib.filter( arr , function(item){
		 * 		return typeof item == 'string'; 
		 * }); // ['삼','오'];
		 * 
		 * @param {Array} arr : 대상 배열
		 * @param {Function} filter : 필터 함수
		 * 
		 * @return {Array} - 필터링된 데이터들을 담은 배열
		 */
		filter : function( arr , filter ){
			if( typeof filter != 'function' ) return arr;
			var  result=[],r=0;
			for(var i = 0,len=arr.length; i < len ; i++){
				var a = arr[i];
				if( filter(a) ) result[r++]=a;
			}
			return result;
		},
		//---------------------- object
		/**
		 * 두개의 Object를 합친다.<br/>
		 * 키가 같은 경우 마지막의 Object값으로 덮어쓴다.
		 *  
		 * @example
		 * var A = { a:'a'};
		 * var B = { b:'b'};
		 * dataLib.extend({},A,B); // { a: "a", b: "b"}
		 * @example
		 * var A = { a:'a'};
		 * var B = { a:'b'};
		 * dataLib.extend( A , B ) //{ a: "b"}
		 * @example
		 * var A = { a : 'a' }
		 * var B = {
		 *   b :'b',
		 *   c : { a :'a'}
		 * }
		 * dataLib.extend( A , B );
		 * //{ a: 'a',
		 *   b: 'b',
		 *   c: { a: 'a' }
		 * }
		 * 
		 * @param {Object} out : 결과가담길 오브젝트
		 * @returns {Object}
		 */
		extend: function( out ) {
			// 출처: http://youmightnotneedjquery.com/
			out = out || {};
			for (var i = 1; i < arguments.length; i++) {
				var obj = arguments[i];
				if (!obj) continue;
	
				for ( var key in obj ) {
					if (obj.hasOwnProperty(key)) {
						if (typeof obj[key] === 'object') {
							out[key] = arguments.callee(out[key], obj[key]);
						} else {
							out[key] = obj[key];
						}
					}
				}
			}
			return out;
		},
		/**
		 * 
		 * parent와 id값을 참조하여 Tree구조의 데이터를 만듦.<br/>
		 * TreeData를 보유,관리 하는 객체를 반환함<br/>
		 * `TreeData` class API 참조<br/>
		 * <br/>
		 * <span class='comment'>// property</span><br/>
		 * 	- data (Array) : tree구조의 data<br/>
		 *  - dataByDepth : depth별로 나눠진 data<br/><br/>
		 * <span class='comment'>// method</span><br/>
		 * 	- getById( id ) : id에 해당하는 객체를 반환함.
		 * 
		 * @example
		 * 데이터 형태는 아래와 같다.
		 * [ {parent:null, id:'', sort:1} , ... ]
		 * 
		 * parent와 id 는 필수 프로퍼티이며, sort를 기준으로 정렬된다.
		 * 또한 root인 경우 parent는 null이여야한다.
		 * 
		 * 트리구조가 완성된 후의 데이터는
		 * depth 프로퍼티와 child 프로퍼티가 생기며
		 * depth는 최상위(root)가 0이고,
		 * child프로퍼티 에 자식객체들이 배열형태로 들어간다.<br/>
		 * 
		 * @example
		 * var data = [{parent :null	,id: '001'	, sort:1 },
		 * 		{parent :null	,id: '002'	, sort:2 },
		 * 		{parent :'001'	,id: '003'	, sort:1 },
		 * 		{parent :'002'	,id: '004'	, sort:2 }];
		 * <span class='comment'>// 변환실행</span>
		 *  - treeObject생성
		 * var treeObject = dataLib.treeData( data );
		 * 
		 * <span class='comment'>// data 꺼냄</span>
		 * treeObject.data;
		 * 
		 * <span class='comment'>// 변환결과</span>
		 * "&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="">""</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"001"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">0</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="red">"001"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"003"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;},<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="">""</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"002"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">2</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">0</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="red">"002"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"004"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">2</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;}<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;}"
		 * @param data
		 * @returns {TreeData} - tree구조로 변환한 데이터를 가지고있는 객체 ( 'data' 프로퍼티 에 변환된 데이터가 존재함 )
		 */
		treeData : function( data , option){
			return new TreeData( data , option);
		},
		/**
		 *  String 형태의 
		 *  java.util.Map or java.util.List 를 JSON 객체로 변환한다.
		 */
		convertToJson : function( data ){
			if(data == '')return {};
			var tmpIdx = 0;
			var sIdx = false, sIdx2 = false, tmp = '';
			var chkComma = true, chkEq = false;
			
			for(var i = 0; i < data.length; i++){
				var curCh = data.charAt(i);
				
				if( curCh == '{'){
					sIdx = true;
					tmp += curCh +'"';
				}else if(curCh == '}'){
					sIdx = false,sIdx2 = false;
					if( data.charAt(i-1) == "]" ){
						tmp += curCh;
					}else{
						tmp += '"' + curCh;
					}
					
					if( !chkEq && chkComma ){
						var cIdx = tmp.lastIndexOf('","');
						tmp = tmp.substring( 0 , cIdx ) + "," + tmp.substring( cIdx + 3 );
					}
					
				}else if( curCh == '='){
					sIdx2 = true;
					if(sIdx){
						if( !chkEq && chkComma ){
							chkComma = false;
							chkEq = true;
						}
						if( data.charAt(i+1) == "[" ){
							tmp += '":';
						}else{
							tmp += '":"';
						}
					}else{
						tmp += curCh;
					}
				}else if ( curCh == ','){
					sIdx2 = false;
					if(sIdx){
						if( !chkComma && chkEq ){
							chkComma = true;
							chkEq = false;
						}else{
							var cIdx = tmp.lastIndexOf('","');
							tmp = tmp.substring( 0 , cIdx ) + "," + tmp.substring( cIdx + 3 );
						}
						tmp += '","';
						i++;
					}else{
						tmp += curCh;
					}
				}else{
					tmp+= curCh;
				}
			}
			return JSON.parse( tmp );
		}
};

/**
 * Tree 구조의 데이터를 생성하는 클래스<br/>
 * 파라미터 데이터 필수 프로퍼티<br/>
 *  - parent<br/>
 *  - id<br/>
 *  [- sort]<br/>
 *  <br/>
 *  
 * @example
 * [ {parent:null, id:'', sort:1} , ... ]
 *  
 * 
 * @class [Class] Tree 구조의 데이터를 생성하는 클래스
 * @property {Array} data - 트리형태로 변환된 데이터
 * @property {Array} dataByDepth - depth 별 데이터
 * @return {TreeData}
 */
function TreeData( data , option){
	var pId = 'parent', id = 'id';
	if( option.parentId ) pId = option.parentId;
	if( option.id ) id= option.id;
	this.pId = pId;
	this.id = id;
	this.dataByDepth = [];
	this.data = this.makeTreeData(  this.setDepth( data ) );
	
	return this;
};

/**
 * 객체에 들어있는 parent와 id를 이용하여 트리구조로 생성한다.<br/>
 * depth 프로퍼티와 child 프로퍼티가 생성된다.<br/>
 * @example
 * 데이터 형태는 아래와 같다.
 * [ {parent:null, id:'', sort:1} , ... ]
 * parent와 id 는 필수 프로퍼티이며, sort를 기준으로 정렬된다.
 * 또한 root인 경우 parent는 null이여야한다.
 * 
 * 트리구조가 완성된 후의 데이터는
 * depth 프로퍼티와 child 프로퍼티가 생기며
 * depth는 최상위(root)가 0이고,
 * child프로퍼티 에 자식객체들이 배열형태로 들어간다.
 * 
 * @example
 * 
 * <span class='comment'>// before</span>
 * var data = [{parent :null	,id: '001'	, sort:1 },
 * 		{parent :null	,id: '002'	, sort:2 },
 * 		{parent :'001'	,id: '003'	, sort:1 },
 * 		{parent :'002'	,id: '004'	, sort:2 }];
 * 
 * <span class='comment'>// after</span>
 * "&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="">""</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"001"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">0</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="red">"001"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"003"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;},<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="">""</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"002"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">2</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">0</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"parent"</span>:<span class="red">"002"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"id"</span>:<span class="red">"004"</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"sort"</span>:<span class="blue">2</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"depth"</span>:<span class="blue">1</span>,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="key">"child"</span>:<span class="">[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;&nbsp;&nbsp;}<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]</span><br/>&nbsp;&nbsp;}"
 * @param {Array} data
 * @returns {Array}
 */
TreeData.prototype.makeTreeData = function( data ){
	var _t = this , treeResult, r;
	
	var _parent = _t.pId;
	var _id = _t.id;
	_t.dataByDepth = r =  [];
	
	data.sorting({
   		compareKey : 'depth',
   		sorttype : 'number'
   		
   	}, function( data ){
   		var t = this, cursor = 0;
   		
   		for(var i=0,len=t.length;i<len;i++){
   			var c = t[i] , d = c.depth, id = c[_id];
   			if( typeof r[d] =='undefined' ){
				r[d] = {
					depth:d
				};
			}
   			c.child = [];
			r[d][ id ] = c;
   		}
   		
   		for(var j=r.length-1;j>=0;j--){
   			var o = r[j], keys = dataLib.keys ( o ); 
   			if( j > 0){
   				var parents = {} , upper = r[j-1];
   				
   				for(var k=0,kLen=keys.length;k<kLen;k++){
   					var key = keys[k], cur = o[key];
   					if(key == 'depth') continue;
//   					var pId = cur.parent;
   					var pId = cur[_parent];
   					upper[ pId ].child.push( cur );
   					parents[pId] = 0;
   				}
   				
   				var forP = dataLib.keys(parents);
   				for(var p=0,plen=forP.length;p<plen;p++){
		   			upper[ forP[p] ].child.sorting({
		   					compareKey : 'sort',
		   			   		sorttype : 'number'
		   			});
   				}
   			}
   		}
   		//init
   		var initData = r[0];
   		var roots = dataLib.keys( initData ), tree = [];
   		for(var i=0,len=roots.length;i<len;i++){
   			if( roots[i] == 'depth' ) continue;
   			tree.push( initData[ roots[i] ] );
   		}
   		
   		tree.sorting({
   			compareKey : 'sort',
		   	sorttype : 'number'
   		})
   		
   		treeResult = {
   			child : tree
   		}
   		
   	});
   	return treeResult;
};

/**
 * 자동으로 Depth프로퍼티를 세팅(생성)한다.<br/>
 * 트리구조로 데이터를 만들기전 진행되어야 할 필수 프로세스.
 * @param {Array} data
 * @returns {Array}
 */
TreeData.prototype.setDepth = function( data ){
	var _parent = this.pId;
	var _id = this.id;
	var known = {} , unknown = {},unknownLst = [];
	for(var i=0,len=data.length;i<len;i++){
		var d = data[i], p = d[_parent], id = d[_id], dep = d.depth;
		if( p == null || typeof p == 'undefined' || id.toLowerCase() == 'root' || dep == 0){
			known[id] = 0;
		}else{
			unknownLst.push( id );
			unknown[id] = p;
		}
	}
	
	var lastIdx = unknownLst.length-1;
	while( unknownLst.length != 0 ){
		var id = unknownLst[lastIdx] , p = unknown[ id ] , pDep = known[p];
		if( typeof pDep == 'undefined'){
			lastIdx--;
		}else{
			known[id] = pDep+1;
			unknownLst.splice(lastIdx,1);
			lastIdx = unknownLst.length-1;
		}
	}
	
	for(var i=0,len=data.length;i<len;i++){
		var d= data[i];
		d.depth = known[d[_id]];
	}
	
	return data;
};
/**
 * id에 해당하는 데이터를 반환한다.
 * 
 * @example
 * var data = [{parent:null, id:'root', sort:1},{parent:null, id:'root2', sort:2}]; 
 * var tree = new TreeData( data );
 * 
 * ## excute
 * tree.getById('root');
 * 
 * ## result
 * {
 * 	parent:null,
 * 	id:'root',
 * 	sort:1,
 * 	depth:0,
 * 	child:[]
 * }
 * @param {String} id : 찾을 id
 * @return {Object} : id에 해당하는 정보객체
 */
TreeData.prototype.getById = function(id){
	if( typeof id != 'string') return null;
	
	var data = this.dataByDepth;
	for(var i=0,len=data.length;i<len;i++){
		var d = data[i][id];
		if( typeof d != 'undefined') return d;
	}
	return null;
}


/**
 * sorting 함수<br/> 편의를 위하여 Array 객체 프로토타입에 직접 등록.<br/> 배열에 존재하는 string,
 * number, date, object 타입을 비교.<br/> object 타입의 경우 옵션에서 key값을 넘겨줘야 함.<br/><br/>
 * 
 * 정렬 후 바로 실행 할 함수를 두번째 파라미터로 넘겨줄 수 있다.
 * 
 * @example
 * var array = [5,3,1,2,4];
 * array.sorting();
 * //[1, 2, 3, 4, 5]
 * @example
 * var array = [5,3,1,2,4];
 * array.sorting({ 
 *  	orderby:'desc'
 * });
 * //[5, 4, 3, 2, 1]
 * @example
 * var array = ['1','10','2','3'];
 * array.sorting({
 * 	sorttype :<b>'string'</b>
 * });
 * // ["1", "10", "2", "3"]
 * @example
 * var array = ['1','10','2','3'];
 * array.sorting({
 * 	sorttype :<b>'number'</b>
 * });
 * // ["1", "2", "3", "10"]
 * @example
 * var array = [{key:'2'},{key:'10'},{key:'1'},{key:'3'}];
 * array.sorting({
 * 	<b>compareKey : 'key' 
 * 	, sorttype : 'number'</b> 
 * });
 * // [{key:'1'},{key:'2'},{key:'3'},{key:'10'}]
 * @example
 * var array = [{key:'2'},{key:'10'},{key:'1'},{key:'3'}];
 * array.sorting({
 * 	<b>compareKey : 'key' 
 * 	, sorttype :'string'</b> 
 * });
 * //[{key:'1'},{key:'10'},{key:'2'},{key:'3'}]
 * 
 * @param {Object}
 *            sortOption <br/> {<br/> orderby : 'asc' [or 'desc'],<br/>
 *            sorttype : 'string' [, 'number'],<br/> compareKey : 'key'[ :
 *            'object의 비교 key 값'] <br/> }<br/>
 * @param {Function}
 *            callback
 * @returns {Array}
 */
Array.prototype.sorting = function( sortOpt , callback ){
		if( !sortOpt ) sortOpt = {};
		var t = this;
		var OBJ = 'object'
			, STR = 'string'
			, NUM = 'number'
			, ASC = 'asc'
			, DESC = 'desc'
			, orderby = sortOpt.orderby || 'asc'
			, sorttype = sortOpt.sorttype
			, compareKey = sortOpt.compareKey;
		
		function sortFunc( v1, v2 ){
			var _v1Type = typeof v1;
			var _v2Type = typeof v1;
			
			switch(true){
				case v1 instanceof Date && v2 instanceof Date :
					
					v1 = v1.getTime(), v2 = v2.getTime();
					if( orderby == DESC ) return v2-v1;
					else return v1-v2;
					
					break;
				case _v1Type === OBJ && _v2Type === OBJ : 
					return sortObject( v1 , v2 , compareKey );
					break;
				case ( _v1Type === STR && _v2Type === STR ) || sorttype == STR :
					return sortString( v1, v2, orderby);
					break;
				case ( _v1Type === NUM && _v2Type === NUM ) || sorttype == NUM :
					if( orderby == DESC ) return v2-v1;
					else return v1-v2;
					break;
				default:break;
			}
			
		}
		
		function sortString( v1 , v2 , order ){
			if( sorttype ==  NUM){
				v1 = parseFloat( v1 , 10 );
				v2 = parseFloat( v2 , 10 )
			}
			if( order == ASC){
				if( v1 > v2 ) return 1;
				else if( v1 < v2 )return -1;
				else return 0;
			}else{
				if( v1 > v2 )return -1;
				else if( v1 < v2 )return 1;
				else return 0;
			}
		}
		
		function sortObject( v1, v2, key){
			var _v1 = v1[key], _v2 = v2[key];
			
			if( sorttype === NUM ){
				_v1 = parseFloat( _v1 , 10 );
				_v2 = parseFloat( _v2 , 10 );
			}
			return sortFunc( _v1 , _v2 );
		}
		
		// sort 실행
		if( this.sort ){
			var t = this.sort(sortFunc);
			if( typeof callback == 'function') callback.call(this, t );
			return t;
		}
		
}
/**
 * Array에 대해 filter 조건에 충족하는 데이터만 뽑아낸다.<br/>
 * filter 는 함수형태로 넘기며 return Type이 반드시 Boolean 이어야 한다.
 * 
 * @example
 * var arr = [ 1,2,'삼',4,'오' ];
 * arr.filter(function(item){
 * 		return typeof item == 'string'; 
 * }); // ['삼','오'];
 * 
 * @param {Function} filter : 필터 함수
 * 
 * @return {Array} - 필터링된 데이터들을 담은 배열
 */
Array.prototype.filter = function( filter ){
	var arr = this;
	
	if( typeof filter != 'function' ) return arr;
	var  result=[],r=0;
	for(var i = 0,len=arr.length; i < len ; i++){
		var a = arr[i];
		if( filter(a) ) result[r++]=a;
	}
	return result;
}