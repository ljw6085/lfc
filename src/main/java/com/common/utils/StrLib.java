/**
 * 문자열관련 라이브러리
 * @author Leejw
 */
package com.common.utils;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

/**
 * 문자열 관련 클래스 - 문자열을 변형 하는 등 문자열 관련 라이브러리
 * @author Leejw
 */
@Component
public class StrLib {
	/**
	 * 조사 선택 {"는","은"}
	 */
	public static final int UNNUN = 1;
	/**
	 * 조사 선택 {"가","이"}
	 */
	public static final int IGA  = 2;
	/**
	 * 조사 선택 {"와","과"}
	 */
	public static final int WAGWA = 3;
	/**
	 * 조사 선택 {"를","을"}
	 */
	public static final int ULLUL = 4;
	/**
	 * 조사 선택 {"로","으로"}
	 */
	public static final int ROURO = 5;
	
	/**
	 * 한글 초/중/종성 분리 하는 메서드
	 * @param str
	 * @param onlyChosung
	 * @return list - 초/중/종성을 분리한 글자를 담은 list
	 */
	private static ArrayList<Character> dismantleHangul(String str,boolean onlyChosung){
		ArrayList<Character> list = new ArrayList<Character>();
		for(int i=0,len=str.length();i<len;i++){
			int p = str.codePointAt(i);
			char ch = str.charAt(i);
			if( p < Hangul.START_CODE ){
				list.add(ch);
			}else{
		        int cBase =  p - Hangul.START_CODE;
		        
		        int c1 = (int) Math.floor( cBase / Hangul.CHOSUNG );
		        list.add( Hangul.CHOSUNG_LIST[c1] );
		        
		        int c2 = (int) Math.floor( (cBase - (Hangul.CHOSUNG * c1)) / Hangul.JUNGSUNG );
		        if(!onlyChosung) list.add( Hangul.JUNGSUNG_LIST[c2] );
		        
		        int c3 = (int) Math.floor(  (cBase - (Hangul.CHOSUNG * c1) - (Hangul.JUNGSUNG * c2)) );
		        if(!onlyChosung) {
		        	String c = Hangul.JONGSUNG_LIST[c3]+"";
		        	if(!c.trim().isEmpty()) list.add( Hangul.JONGSUNG_LIST[c3]);
		        }
			}
		}
		return list;
	}
	
	/**
	 * 초/중/종 성을 분리한 데이터를 <b>List</b>로 반환받는다.
	 * <pre>
	 * String str = "안녕하세요?";
	 * StrLib.dismantleList(hi); 
	 * // "[ㅇ, ㅏ, ㄴ, ㄴ, ㅕ, ㅇ, ㅎ, ㅏ, ㅅ, ㅔ, ㅇ, ㅛ, ?]"
	 * </pre>
	 * @param str
	 * @return List<Character>
	 */
	public static List<Character> dismantleList( String str ){
		return dismantleList(str, false);
	}
	/**
	 * 초/중/종 성을 분리한 데이터를 <b>List</b>로 반환받는다.<br/>
	 * 두번째 파라미터로 초성만 받을지 결정할 수 있다.
	 * <pre>
	 * String str = "안녕하세요?";
	 * StrLib.dismantleList(hi , true); 
	 * // "[ㅇ, ㄴ, ㅎ, ㅅ, ㅇ, ?]"
	 * </pre>
	 * 
	 * @param str
	 * @param onlyChosung
	 * @return List<Character>
	 */
	public static List<Character> dismantleList( String str ,boolean onlyChosung){
		return dismantleHangul(str,onlyChosung);
	}
	/**
	 * 초/중/종 성을 분리한 데이터를 <b>Array</b>로 반환받는다.
	 * 
	 * @param str
	 * @return List<Character>
	 */
	public static String[] dismantle( String str ){
		return dismantle(str, false);
	}
	/**
	 * 초/중/종 성을 분리한 데이터를 <b>Array</b>로 반환받는다.<br/>
	 * 두번째 파라미터로 초성만 받을지 결정할 수 있다.
	 * @param str
	 * @param onlyChosung
	 * @return List<Character>
	 */
	public static String[] dismantle( String str ,boolean onlyChosung){
		ArrayList<Character> list = dismantleHangul(str,onlyChosung);
		String[] result = new String[list.size()];
		for(int i=0,len=result.length;i<len;i++) result[i] = list.get(i)+"";
		return result;
	}
	/**
	 * 종성여부를 확인하여 반환한다.<br/>
	 * 문자열의 길이가 1 이상인경우 마지막 글자의 종성여부를 반환한다.<br/>
	 * 
	 * 한글코드 = 종성 + 중성*28 + 초성*588 + 44032<br/>
	 * 한글코드-44032 = 종성 + 중성*28 + 초성*588<br/>
	 * 한글코드-44032 = 종성 + (중성 + 초성*21)*28<br/><br/>
	 *   
	 * <b>종성 = ( 한글코드 - 44032 ) % 28</b><br/>
	 * <pre>
	 * StrLib.hasJongsung( "가" ); // 0 
	 * StrLib.hasJongsung( "각" ); // 1 
	 * </pre>
	 * @param str
	 * @return 종성존재여부(  0 : 없음,  1 : 있음 )
	 */
	public static int hasJongsung( String str ){
		int point = str.codePointAt(str.length()-1); 
		if( point < Hangul.START_CODE){
			return Hangul.HAS_JONGSUNG;
		}else{
			return  ( point - Hangul.START_CODE ) % 28 > 0 ? Hangul.HAS_JONGSUNG : Hangul.HAS_NOT_JONGSUNG; 
		}
	}
	
	/**
	 * 한글인지 아닌지 확인한다.( 한글자만 확인 후 반환 )
	 * <pre> 
	 * StrLib.isHangul('a') // false
	 * StrLib.isHangul('가') // true
	 * StrLib.isHangul('a가') // false ( 첫글자만 확인함 )
	 * </pre> 
	 * @param str : 한글인지 아닌지 확인할 문자열 1글자.
	 * @returns : 한글인지 아닌지를 반환
	 */
	public static boolean isHangul( String str ){
//		int s = str.codePointAt(0);
		char s = str.charAt(0);
//		if( (s >= 12593 &&  s<=12643 ) || (s>= 44032 && s<= 55175)){
		if( (Character.UnicodeBlock.of(s) == Character.UnicodeBlock.HANGUL_SYLLABLES) || (s >= 12593 &&  s<=12643 ) ){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * byte수 만큼 문자열을 잘라서 반환한다.
	 * 
	 * @param str
	 * @param maxByte
	 * @return
	 */
	public static String cutBytes( String str, int maxByte ){
		return new String( Arrays.copyOf( str.getBytes() , maxByte));
	}
	
	/**
	 * byte수 만큼 문자열을 잘라서 반환한다.
	 * @param str
	 * @param maxByte
	 * @param charset
	 * @return
	 */
	public static String cutBytes( String str, int maxByte ,String charset) throws UnsupportedEncodingException{
		return new String( Arrays.copyOf( str.getBytes() , maxByte) , charset);
	}
	
	/**
    * under-score or under_score 를 camelCase 로 변환.
    * <pre>
    * StrLib.toCamelCase("under-score") // "underScore"
    * StrLib.toCamelCase("under_score") // "underScore"
    * </pre>
    * @param {String} str : camelCase로 변환할 UNDER_SCORE 문자열
    * @returns {String}
    */
	public static String toCamelCase( String str ){
		String tmp = "";
    	boolean isUpper = false;
    	for(int i=0,len=str.length();i<len;i++){
			char ch = str.charAt(i);
			if( ch == '_' || ch == '-'){
				isUpper = true;
				continue;
			}else{
				if( isUpper ){
					tmp += (ch+"").toUpperCase();
				}else{
					tmp += (ch+"").toLowerCase();
				}
				isUpper = false;
			}
		}
    	return tmp;
	}
	
	/**
     * camelCase => UNDER_SCORE 형태로 변환
     * @example
     * StrLib.toUnnderScore('camelCase') // 'CAMEL_CASE'
     * 
     * @param {String}  str : UNDER_SCORE형태로 변환할 camelCase형태의 문자열
     * @returns
     */
	public static String toUnnderScore( String str ){
		String tmp ="";
		for(int i=0,len=str.length();i<len;i++){
			char ch = str.charAt(i);
			if( ch < 97	){
				tmp += "_"+ch;
			}else{
				tmp += ch;
			}
		}
		return tmp.toUpperCase();
	}
	
	/**
    * 문자열 사이의 공백(1칸이상의 공백)을 하나(1칸)로 생략함<br/>
    * @example
    * StrLib.collapseSpace( "  공 \t\t 백 생략\t*\n  ")  // " 공 백 생략 * "
    * @param {String} str : 공백을 1칸으로 생략할 문자열
    * @returns {Strng}
    */
	public static String collapseSpace( String str ){
		Pattern p = Pattern.compile("\\s+",Pattern.MULTILINE);
		Matcher m = p.matcher(str);
		return m.replaceAll(" ");
	}
	
	/**
     * 반복할 문자열을 반복 횟수만큼 반복하여 반환한다.
     * @example
     * StrLib.repeat("*" ,  10 ) // "**********"
     * @param str : 반복할 문자열
     * @param cnt : 반복 횟수
     * @returns {String}
     */
	public static String repeat(String str, int cnt ){
		String tmp = "";
		do {
			tmp += str;
			cnt--;
		} while (cnt > 0);
		
		return tmp;
	}
	/**
     * 좌측으로부터 {N}개의 문자열을 가져옴<br/>
     * {-N}인 경우 우측에서부터 가져옴.
     * @example
     * StrLib.left("안녕하세요?",  2 ); // "안녕"
     * @example
     * StrLib.left("안녕하세요?", -2 ); // "요?"
     * 
     * @param str : 타겟 문자열
     * @param idx : 좌측으로부터의 index값
     * @returns {String}
     */
	public static String left(String str, int idx ){
		if( str.length() < Math.abs(idx) ) return str;
		return (idx > -1)? str.substring(0,idx) : StrLib.right(str, -1*idx );
	}
	
	 /**
     * 우측으로부터 {N}개의 문자열을 가져옴<br/>
     * {-N}인 경우 좌측에서부터 가져옴.
     * @example
     * StrLib.right("안녕하세요?",  2 ); // "요?"
     * @example
     * StrLib.right("안녕하세요?", -2 ); // "안녕"
     * 
     * @param str : 타겟 문자열
     * @param idx : 우측으로부터의 index값
     * @returns {String}
     */
	public static String right(String str, int idx ){
		int last = str.length();
		if( last < Math.abs(idx) ) return str;
		return (idx > -1)? str.substring(last-idx) : StrLib.left(str, -1*idx);
	}
	
	/**
     * 시작Index부터 {N} 개의 문자열을 가져옴.<br/>
     * @example
     * StrLib.mid("안녕하세요?",  1 , 3); // "녕하세"
     * 
     * @param str : 타겟 문자열
     * @param s : 시작 Index
     * @param e : 문자열개수
     * @returns {String}
     */
	public static String mid( String str, int s, int e ){
		if( (s+e) > str.length() ) {
			try {
				throw new Exception("넘어온 파라미터의 범위가 문자열 길이보다 큽니다.");
			} catch (Exception e1) {
				e1.printStackTrace();
				return str;
			}
		}
		return str.substring(s,s+e);
	}
	
	/**
     * 파라미터로 넘긴 문자열이 몇개나 존재하는지 갯수를 반환
     * @example
     * StrLib.count( "AAAAA D AAAAA", "A") // 10
     * @param {String} target : 타겟 문자열
     * @param {String} str : 찾을 문자열
     * @returns 일치하는 문자열의 개수
     */
	public static int count( String str , String target){
		int i=0;
		Matcher m = Pattern.compile(target).matcher(str);
		while( m.find() ) i++;
		return i;
	}
	
	/**
	 * 사용자가 지정한 포맷을 적용시켜 리턴한다.<br/>
	 * 문자열을 템플릿 화 시킬 수 있다.
	 * 매칭되는 부분은 반드시 '#' 문자열을 사용한다.<br/>
	 * # 앞 뒤로 오는 문자열은 그대로 반영된다.
	 * 
	 * @example
	 * StrLib.templete( "8801011111111" ,'######-#######') // "880101-1111111"
	 * @example
	 * StrLib.templete( "20160512" ,'####-##-##') // "2016-05-12"
	 * @example
	 * StrLib.templete( "1000000000" ,'오늘의 최저가 : #,### 원') //"오늘의 최저가 : 1,000,000,000 원"
	 * 
	 * @param {String} str
	 * @param {String} format 두 개 이상의 '#'을 포함한 포맷형식
	 * @returns {String}
	 */
	public static String templete ( String str, String format ){
		if( StrLib.count(format, "#") < 2){
			try {
				throw new Exception(" StrLib.templete() : '#' 은 2개 이상 입력해야합니다.");
			} catch (Exception e) {
				e.printStackTrace();
				return str;
			}
		}
		int pre = format.indexOf( "#" ) , suf = format.lastIndexOf( "#" );
		
		String preStr = format.substring(0,pre) , sufStr = format.substring(suf+1);
		
		String _fm = format.substring(pre,suf+1) , newStr = "";
		
		boolean conitnue = false;
		int j = _fm.length()-1;
		for(int i=str.length()-1,len=0;i>=len;i--){
			char ch = _fm.charAt(j--);
			switch( ch ){
				case '#':
					newStr = str.charAt(i) + newStr;
					break;
				default:
					newStr = ch + newStr;
					i++;
					break;
			}
			if( j == -1 ) j = _fm.length()-2;
		}
		newStr = preStr + newStr + sufStr;
		return newStr;
	}
	/**
     * 좌측의 공백만 모두 제거한다.
     * @example
     * StrLib.trimLeft( "\n\t    테스트       " ) // "테스트       ";
     * @param {String} str : 타겟 문자열 
     * @returns {String}
     */
	public static String trimLeft ( String str ){
		Pattern p = Pattern.compile("(^\\s*)");
		Matcher m = p.matcher(str);
		return m.replaceAll("");
	}
	/**
     * 우측의 공백만 모두 제거한다.
     * @example
     * StrLib.trimRight( "    테스트    \n\t   " ) // "    테스트"
     * @param {String} str : 타겟 문자열
     * @returns {String}
     */
	public static String trimRight ( String str ){
		return Pattern.compile("(\\s*$)").matcher(str).replaceAll("");
	}
	
	/**
     * max값 만큼 좌측으로 공백으로 채운다
     * @example
     * StrLib.fillLeft( "ABC", 10 ) // "       ABC" 
     * @param str   : 타겟문자열
     * @param max	: max length
     * 
     * @returns {String} 
     */
	public static String fillLeft(String str, int max){
		return fillLeft(str, max, ' ');
	}
	
	/**
     * max값 만큼 좌측으로 특정문자열(1byte)을 채운다
     * @example
     * strLib.fillLeft( "ABC", 10 , '*') // "*******ABC" 
     * @param str  : 타겟문자열
     * @param max	: max length
     * @param ch	: 채울 문자열
     * 
     * @returns {String} 
     */
	public static String fillLeft(String str, int max, char ch){
    	String result = ""; 
    	if( str.length() < max ){
    		for(int i=0 , diff= max - str.length(); i < diff ; i++) result += ch;
    		result += str;
    		return result;
    	}else{
    		return str.substring(0,max);
    	}
	}
	/**
     * max값 만큼 우측으로 공백으로 채운다
     * @example
     * strLib.fillRight( "ABC", 10 ) // "ABC       "
     * @param str : 타겟문자열
     * @param max	: max length
     * 
     * @returns {String} 
     */
	public static String fillRight(String str, int max){
		return fillRight(str,max, ' ');
	}
	
	/**
     * max값 만큼 우측으로 특정문자열(1byte)을 채운다
     * @example
     * strLib.fillRight( "ABC", 10 , '*') // "ABC*******"
     * @param str 	: 타겟문자열
     * @param max	: max length
     * @param ch	: 채울 문자열
     * 
     * @returns {String} 
     */
	public static String fillRight(String str, int max, char ch ){
    	if( str.length() < max ){
    		for(int i=0,diff = max - str.length(); i < diff ; i++) str += ch;
    		return str;
    	}else{
    		return str.substring(0,max);
    	}
	}
	
	/**
     * 좌측으로부터 n개의 문자열개수(또는 byte 수)까지 자른 후<br/>
     * 생략문자열( truncStr ) 로 생략하여 반환한다.
     * 
     * @example
     * StrLib.trunc("가나다라마",3,true , "[...]"); //"가 [...]"
     * @example
     * StrLib.trunc("가나다라마",3,false,",,,"); //"가나다,,,"
     * 
     * @param str
     * @param len
     * @param isByte
     * @returns {String}
     */
	public static String trunc(String str, int len, boolean isByte, String truncStr){
		String tmp = "";
		if(isByte){
			tmp = StrLib.cutBytes(str, len);
			if( StrLib.right(tmp,1).codePointAt(0) == 65533 ) tmp = tmp.substring(0, tmp.length()-1)+' ';
		}else{
			tmp = StrLib.left(str, len);
		}
		
		return tmp + truncStr;
	}
	
	/**
     * 좌측으로부터 n개의 문자열개수(또는 byte 수)까지 자른 후<br/>
     * "..." 로 생략하여 반환한다.
     *
     * <pre>
     * StrLib.trunc("가나다라마",3,true); //"가 ..."
     * StrLib.trunc("가나다라마",3); //"가나다..."
     * </pre>
     * @param str
     * @param len
     * @param isByte
     * @returns {String}
     */
	public static String trunc(String str, int len, boolean isByte){
		return StrLib.trunc(str, len, isByte, "..." );
	}
	
	/**
     * 좌측으로부터 해당 byte 수 까지 자른 후<br/>
     * "..." 로 생략하여 반환한다.
     * 
     * <pre>
     * StrLib.trunc("가나다라마",3); //"가나다..."
     * </pre>
     * @param str
     * @param len
     * @returns {String}
     */
	public static String trunc(String str, int len){
		return StrLib.trunc(str, len, true , "..." );
	}
	
	/**
	 * `{}` 형태의 문자열을 차례대로 매칭시켜 반환함.<br/>
	 * ( log4j 의 {}을 이용한 log 포맷형식을 따라함. )
	 * <pre>
	 * ComLib.format("안녕하세요? {}입니다. {}!", "이종욱", "반갑습니다"); 
	 * // "안녕하세요? 이종욱입니다. 반갑습니다!";
	 * </pre>
	 * @param s
	 * @param ...str
	 * @return
	 */
	public static String format(String s, Object ...str){
		return String.format(Pattern.compile("(\\{\\})").matcher(s).replaceAll("%s"), str);
	}
	/**
	 * 원하는 Index 이후에 해당 (정규식에매칭되는)문자열이 있는지 확인한다.
	 *  
	 * @param targetStr
	 * @param regex
	 * @param startIdx
	 * @return
	 */
	public static boolean hasWordFromIndex(String targetStr ,String regex, int startIdx){
		return Pattern.compile(regex).matcher(targetStr).find(startIdx);
	}
	
	/**
	 * 해당 문자열에대한 `조사`를 선택한다.(한글인경우)
	 * <pre>
	 * String hangul = "시계";
	 * 	StrLib.choiceJOSA( hangul, StrLib.UNNUN ); //"는"
	 * 	StrLib.choiceJOSA( hangul, StrLib.IGA ); //"가"
	 * 	StrLib.choiceJOSA( hangul, StrLib.WAGWA ); //"와"
	 * 	StrLib.choiceJOSA( hangul, StrLib.ULLUL ); //"를"
	 * 	StrLib.choiceJOSA( hangul, StrLib.ROURO ); //"로"
	 * </pre>
	 * @param str
	 * @param type
	 * @return
	 */
	public static String choiceJOSA(String str, int type){
		String result = "";
		int hasJongsung = StrLib.hasJongsung(str);
		switch (type) {
			case StrLib.UNNUN:
				result = Hangul.UNNUN[hasJongsung];
				break;
			case StrLib.IGA:
				result = Hangul.IGA[hasJongsung];
				break;
			case StrLib.WAGWA:
				result = Hangul.WAGWA[hasJongsung];
				break;
			case StrLib.ULLUL:
				result = Hangul.ULLUL[hasJongsung];
				break;
			case StrLib.ROURO:
				result = Hangul.ROURO[hasJongsung];
				break;
		}
		return result;
	}
}
