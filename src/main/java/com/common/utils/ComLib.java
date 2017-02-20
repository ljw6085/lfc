/**
 * 공통 라이브러리
 * @author Leejw
 */
package com.common.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;


/**
 * 공통라이브러리 : 범용적기능, Array, Map, List 관리 등 공통적인 라이브러리를 모아둔 클래스
 * @author Leejw
 */
@Component
public class ComLib {
	
	public static final int SORT_DESC = 0;
	public static final int SORT_ASC = 1;
	
	/**
	 * 배열을 거꾸로 세팅하여 <b>새로운 배열</b>을 반환한다.
	 * <pre>
	 * int[] test = {1,2,3,4,5};
	 * int[] test2 = ComLib.reverseArray( test ); // "[5,4,3,2,1]";
	 * </pre>
	 * @param arr 대상 배열
	 * @return Array - reverse 된 배열
	 */
	//Generic사용
	public static <T> T[] reverseArray(T[] arr){
		int k = arr.length;
		T[] tmp = Arrays.copyOf(arr, k--);
		for(int i=0;k>=0;k--)
			tmp[i++] = arr[k];
		return tmp;
	}
	
	/**
	 * Map의 Value를 기준으로 Sorting하여 <b>새로운 Map</b>을 반환한다.<br/>
	 * SORT TYPE : ComLib.SORT_ASC / ComLib.SORT_DESC <br/>
	 * Sort 가능 타입 <br/>
	 *  - String / int / long / char / byte<Br/>
	 * <pre>
	 * 
	 * Map&lt;String,Object&gt; map = new HashMap&lt;String,Object&gt;();
	 * map.put("No1",5);
	 * map.put("No2",2);
	 * map.put("No3",9);
	 * 
	 * Map&lt;String,Object&gt; result = ComLib.sortByValueFromMap(map, ComLib.SORT_ASC); // "[No2=2,No1=5,No3=9]";
	 * 
	 * </pre>
	 * @see ComLib.SORT_ASC
	 * @see ComLib.SORT_DESC
	 * @param map sort하려는 Map
	 * @param sortType sort 타입( ComLib.SORT_ASC / ComLib.SORT_DESC )
	 * @return sort된 Map - sort 되어진 map( LinkedHashMap )
	 */
	public static <K,V> Map<K,V> sortByValueFromMap(final Map<K,V> map, int sortType){
		List<K> list = new ArrayList<K>( map.keySet() );
		switch (sortType) {
			case ComLib.SORT_ASC:
				
				Collections.sort(list,new Comparator<K>() {
					@Override
					public int compare(K o1, K o2) {
						int res = 0;
						if ( map.get(o1) instanceof Integer ){
							res = ( (Integer) map.get(o1) ).compareTo((Integer)map.get(o2) );
						}else if(map.get(o1) instanceof String){
							res = ( (String) map.get(o1) ).compareTo((String)map.get(o2) );
						}else if( map.get(o1) instanceof Long ){
							res = ( (Long) map.get(o1) ).compareTo((Long)map.get(o2) );
						}else if( map.get(o1) instanceof Character ){
							res = ( (Character) map.get(o1) ).compareTo((Character)map.get(o2) );
						}else if ( map.get(o1) instanceof Byte ){
							res = ( (Byte) map.get(o1) ).compareTo((Byte)map.get(o2) );
						}
						return res;
					}
				});
				
				break;
			case ComLib.SORT_DESC:
				
				Collections.sort(list,new Comparator<K>() {
					@Override
					public int compare(K o2, K o1) {
						int res = 0;
						if ( map.get(o1) instanceof Integer ){
							res = ( (Integer) map.get(o1) ).compareTo((Integer)map.get(o2) );
						}else if(map.get(o1) instanceof String){
							res = ( (String) map.get(o1) ).compareTo((String)map.get(o2) );
						}else if( map.get(o1) instanceof Long ){
							res = ( (Long) map.get(o1) ).compareTo((Long)map.get(o2) );
						}else if( map.get(o1) instanceof Character ){
							res = ( (Character) map.get(o1) ).compareTo((Character)map.get(o2) );
						}else if ( map.get(o1) instanceof Byte ){
							res = ( (Byte) map.get(o1) ).compareTo((Byte)map.get(o2) );
						}
						return res;
					}
				});
				break;
			default:
				break;
		}
		
		return ComLib._setMapByListAfterSort(map, list);
	}
	
	/**
	 * Map의 Key를 기준으로 Sorting하여 <b>새로운 Map</b>을 반환한다.<br/>
	 * SORT TYPE : ComLib.SORT_ASC / ComLib.SORT_DESC <br/>
	 * Sort 가능 타입 <br/>
	 *  - String / int / long / char / byte
	 * <pre>
	 * 
	 * Map&lt;String,Object&gt; map = new HashMap&lt;String,Object&gt;();
	 * map.put("No1",5);
	 * map.put("No2",2);
	 * map.put("No3",9);
	 * 
	 * Map&lt;String,Object&gt; result = ComLib.sortByKeyFromMap(map, ComLib.SORT_DESC); // "[No3=9,No2=2,No1=5]";
	 * 
	 * </pre>
	 * @see ComLib.SORT_ASC
	 * @see ComLib.SORT_DESC
	 * @param map sort하려는 Map
	 * @param sortType sort 타입( ComLib.SORT_ASC / ComLib.SORT_DESC )
	 * @return sort된 Map - sort 되어진 map( LinkedHashMap )
	 */
	public static <K,V> Map<K,V> sortByKeyFromMap(final Map<K,V> map, int sortType){
		List<K> list = new ArrayList<K>( map.keySet() );
		switch (sortType) {
			case ComLib.SORT_ASC:
				Collections.sort(list,new Comparator<K>() {
					@Override
					public int compare(K o1, K o2) {
						int res = 0;
						if ( o1 instanceof Integer ){
							res = ( (Integer) o1 ).compareTo((Integer)o2 );
						}else if(o1 instanceof String){
							res = ( (String) o1 ).compareTo((String)o2 );
						}else if( o1 instanceof Long ){
							res = ( (Long) o1 ).compareTo((Long)o2 );
						}else if( o1 instanceof Character ){
							res = ( (Character) o1 ).compareTo((Character)o2 );
						}else if ( o1 instanceof Byte ){
							res = ( (Byte) o1 ).compareTo((Byte)o2 );
						}
						return res;
					}
				});
				break;
			case ComLib.SORT_DESC:
				Collections.sort(list,new Comparator<K>() {
					@Override
					public int compare(K o2, K o1) {
						int res = 0;
						if ( o1 instanceof Integer ){
							res = ( (Integer) o1 ).compareTo((Integer)o2 );
						}else if(o1 instanceof String){
							res = ( (String) o1 ).compareTo((String)o2 );
						}else if( o1 instanceof Long ){
							res = ( (Long) o1 ).compareTo((Long)o2 );
						}else if( o1 instanceof Character ){
							res = ( (Character) o1 ).compareTo((Character)o2 );
						}else if ( o1 instanceof Byte ){
							res = ( (Byte) o1 ).compareTo((Byte)o2 );
						}
						return res;
					}
				});
				break;
		}
		return ComLib._setMapByListAfterSort(map, list);
	}
	
	private static <K,V> Map<K,V> _setMapByListAfterSort(Map<K,V> map, List<K> list){
		Map<K,V> newMap = new LinkedHashMap<K,V>();
		for( K k : list ) newMap.put(k, map.get(k));
		return newMap;
	}
	
	/**
	 * Map을 담은 List를 Map의 특정 Key에대한 값을 기준으로 sort 한다.
	 * <pre>
	 * Map&lt;String,Object&gt; map = new HashMap&lt;String,Object&gt;();
	 * map.put("No",5);
	 * Map&lt;String,Object&gt; map = new HashMap&lt;String,Object&gt;();
	 * map.put("No",88);
	 * Map&lt;String,Object&gt; map = new HashMap&lt;String,Object&gt;();
	 * map.put("No",60);
	 * 
	 * List&lt;Map&lt;String,Object&gt;&gt; list = new ArrayList&lt;Map&lt;String,Object&gt;&gt;();
	 * 
	 * ComLib.sortByMapFromList(list, "No", ComLib.SORT_DESC);
	 *  
	 * </pre>
	 * @see ComLib.SORT_ASC
	 * @see ComLib.SORT_DESC
	 * @param list sort하려는 list
	 * @param key sort 기준 key 
	 * @param sortType sort 타입( ComLib.SORT_ASC / ComLib.SORT_DESC )
	 * @return sort된 list - sort가 끝난 list
	 */
	public static <T,V> List<Map<T,V>> sortByMapFromList(List<Map<T,V>> list, final T key , int sortType){
		
		switch (sortType) {
			case ComLib.SORT_ASC:
				Collections.sort(list,new Comparator<Map>() {
					@Override
					public int compare(Map o1, Map o2) {
						int res = 0;
						Object _o1 = o1.get(key);
						if ( _o1 instanceof Integer ){
							res = ( (Integer) _o1 ).compareTo((Integer)o2.get(key) );
						}else if(_o1 instanceof String){
							res = ( (String) _o1 ).compareTo((String)o2.get(key) );
						}else if( _o1 instanceof Long ){
							res = ( (Long) _o1 ).compareTo((Long)o2.get(key) );
						}else if( _o1 instanceof Character ){
							res = ( (Character) _o1 ).compareTo((Character)o2.get(key) );
						}else if ( _o1 instanceof Byte ){
							res = ( (Byte) _o1 ).compareTo((Byte)o2.get(key) );
						}
						return res;
					}
				});
				break;
			case ComLib.SORT_DESC:
				Collections.sort(list,new Comparator<Map>() {
					@Override
					public int compare(Map o2, Map o1) {
						int res = 0;
						Object _o1 = o1.get(key);
						if ( _o1 instanceof Integer ){
							res = ( (Integer) _o1 ).compareTo((Integer)o2.get(key) );
						}else if(_o1 instanceof String){
							res = ( (String) _o1 ).compareTo((String)o2.get(key) );
						}else if( _o1 instanceof Long ){
							res = ( (Long) _o1 ).compareTo((Long)o2.get(key) );
						}else if( _o1 instanceof Character ){
							res = ( (Character) _o1 ).compareTo((Character)o2.get(key) );
						}else if ( _o1 instanceof Byte ){
							res = ( (Byte) _o1 ).compareTo((Byte)o2.get(key) );
						}
						return res;
					}
				});
				break;
		}
		return list;
	}
	
	/**
	 * 배열을 복사한다.( Arrays 클래스 이용 )<br/>
	 * 0 ~ arr.length 까지 복사한다.
	 * @param arr
	 * @return 복사된 배열
	 */
	public static <T> T[] arrayCopy(T[] arr){
		return Arrays.copyOf(arr, arr.length);
	}
	/**
	 * 배열을 복사한다.( Arrays 클래스 이용 )<br/>
	 * 0 ~ to 까지 복사한다.
	 * @param arr
	 * @param maxLen  : 0 ~ to 까지복사
	 * @return 복사된 배열
	 */
	public static <T> T[] arrayCopy(T[] arr, int to){
		return Arrays.copyOf(arr, to);
	}
	/**
	 * 배열을 복사한다.( Arrays 클래스 이용 )<br/>
	 * from ~ to 까지 복사한다.
	 * 
	 * @param arr
	 * @param from 
	 * @param to
	 * @return 복사된 배열
	 */
	public static <T> T[] arrayCopy(T[] arr, int from,int to){
		return Arrays.copyOfRange(arr, from, to);
	}
	
	/**
	 * log4j 에서 지원하는 형태로 콘솔창에 문자열을 찍는다.
	 * <pre>
	 * ComLib.println("{}번째 {}입니다.", 1, "data"); // "1번째 data입니다."
	 * </pre>
	 * @param stmt
	 * @param ...str
	 */
	public static <T> void println(String s, Object ...str){
		Pattern p = Pattern.compile("(\\{\\})");
		Matcher m = p.matcher(s);
		System.out.println( String.format(m.replaceAll("\\%s"), str) );
	}
	/**
	 * 콘솔창에 문자열을 찍는다.
	 * @param stmt
	 */
	public static <T> void println(Object s){
		System.out.println( s );
	}
	
	/**
	 * 정규식을 이용하여 특정 문자열을 replace한다.<br/>
	 * <pre>
	 * //오른쪽 공백을 제거함
	 * ComLib.replaceByRegExp( "가나다   ","(\\s*$)", "" ); //"가나다"
	 * </pre>
	 * @param targetStr	- 대상 String
	 * @param regexp	- 정규식
	 * @param replaceStr- 대체할 문자열
	 * @return
	 */
	public static String replaceByRegExp(String targetStr,  String replaceStr , String regexp ){
		return Pattern.compile( regexp , Pattern.MULTILINE ).matcher(targetStr).replaceAll(replaceStr);
	}
	
	/**
	 * 정규식을 이용하여 특정 문자열을 제거한다.<br/>
	 * <pre>
	 * //오른쪽 공백을 제거함
	 * ComLib.removeByRegExp( "    가나다   " , "(\\s*$)"); //"    가나다"
	 * </pre>
	 * @param targetStr	- 대상 String
	 * @param regexp	- 정규식
	 * @return
	 */
	public static String removeByRegExp(String targetStr , String regexp ){
		return ComLib.replaceByRegExp(regexp, targetStr, "");
	}
	
}
