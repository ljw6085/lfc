package com.common.utils;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

/**
 * 날짜관련 라이브러리 - 날짜를 계산, 가공 하는 라이브러리
 * @author Leejw
 *
 */
@Component
public class DateLib {
	
	/**
	 * 날짜정보를 가져온다
	 * @param add	계산할 숫자
	 * @param format 날짜포맷
	 * @param type	계산할 타입( 년, 월, 일 )
	 * @return 
	 */
	private static String _getDate(int add, String format, int type){
		Calendar cal = Calendar.getInstance();
		cal.add(type, add);
		return new SimpleDateFormat(format).format( cal.getTime() );
	}
	
	/**
	 * " yyyyMMdd " 형태의 날짜형식인 문자열을 Date객체로 만든 후 반환한다.
	 * @param date ( yyyyMMdd )
	 * @return
	 */
	private static Date _setCalendar(String date){
		
		int y = Integer.parseInt( date.substring(0,4) );
		int m = Integer.parseInt( date.substring(4,6) ) - 1;
		int d = Integer.parseInt( date.substring(6) );
		
		Calendar c = Calendar.getInstance();
		c.set(Calendar.YEAR, y);
		c.set(Calendar.MONTH, m);
		c.set(Calendar.DATE, d);
		return c.getTime();
	}
	
	/**
	 * 숫자를 제외한 모든 문자열을 제거
	 * @param str
	 * @return
	 */
	private static String _onlyNumber(String str){
		return Pattern.compile("[^\\d]").matcher(str).replaceAll("") ;
	}
	
	/**
	 * 두 날짜의 일수를 계산하여 반환
	 * @param oldDt
	 * @param newDt
	 * @return
	 */
	private static int _doCalcDiff(Date oldDt, Date newDt){
		long diff = Math.abs( oldDt.getTime() - newDt.getTime() );
		return (int) ( diff / ( 1000 * 60 * 60 * 24 ) );
	}
	
	/**
	 * 실행되는 시점의 시각을 반환( yyyyMMddHHmmss )
	 * @return 
	 */
	public static String getNow(){
		return DateLib._getDate(0,"yyyyMMddHHmmss",Calendar.DATE);
	}
	/**
	 * 실행되는 시점의 시각을 원하는 format으로 반환
	 * @param format
	 * @return
	 */
	public static String getNow(String format){
		return DateLib._getDate(0,format,Calendar.DATE);
	}
	
	/**
	 * 실행되는시점의 날짜를 원하는 format으로 반환
	 * @param format
	 * @return
	 */
	public static String getDate(String format){
		return DateLib._getDate(0,format,Calendar.DATE);
	}
	
	/**
	 * 오늘 날짜를 반환( yyyyMMdd )
	 * @return "yyyyMMdd"
	 */
	public static String getDate(){
		return DateLib._getDate(0,"yyyyMMdd",Calendar.DATE);
	}
	
	/**
	 * 오늘을 기준으로 add 만큼 계산한 날짜를 반환("yyyyMMdd")
	 * @param add
	 * @return "yyyyMMdd"
	 */
	public static String getDate(int add){
		return DateLib._getDate(add,"yyyyMMdd",Calendar.DATE);
	}
	
	/**
	 * 오늘을 기준으로 add 만큼 계산한 날짜를 원하는 format으로 반환
	 * @param add
	 * @param format
	 * @return
	 */
	public static String getDate(int add, String format){
		return DateLib._getDate(add,format,Calendar.DATE);
	}

	
	/**
	 * 오늘을 기준으로 하는 달 을 반환( yyyyMM )
	 * @return "yyyyMM"
	 */
	public static String getMonth(){
		return DateLib._getDate(0,"yyyyMM",Calendar.MONTH);
	}
	/**
	 * 오늘을 기준으로 하는 달을 원하는 format으로 반환
	 * @param format
	 * @return
	 */
	public static String getMonth(String format){
		return DateLib._getDate(0,format,Calendar.MONTH);
	}
	/**
	 * 오늘을 기준으로 하는 달을 add만큼 계산하여 원하는 format으로 반환
	 * @param add
	 * @param format
	 * @return
	 */
	public static String getMonth(int add, String format){
		return DateLib._getDate(add,format,Calendar.MONTH);
	}
	/**
	 * 오늘을 기준으로 하는 달을 add만큼 계산하여 반환 ("yyyyMM")
	 * @param add
	 * @return "yyyyMM"
	 */
	public static String getMonth(int add){
		return DateLib._getDate(add,"yyyyMM",Calendar.MONTH);
	}
	/**
	 * 윤년 여부 체크 (int)
	 * @param year
	 * @return
	 */
	public static boolean isLeapYear( int year ){
	    return (year%4 == 0 && year%100 != 0 ) || year%400 == 0;
	}
	/**
	 * 윤년 여부 체크 ( String )
	 * @param _year
	 * @return
	 */
	public static boolean isLeapYear( String _year ){
		return DateLib.isLeapYear( Integer.parseInt( _year ) );
	}
	
	/**
	 * 두 날짜 사이의 일수를 계산 후 반환( 두 파라미터가 "yyyyMMdd" 형태여야 함. )
	 * @param (String) prev
	 * @param (String) next
	 * @return
	 */
	public static int getDateDiff(String prev, String next){
		prev = DateLib._onlyNumber( prev );
		next = DateLib._onlyNumber( next );
		if( prev.length() != 8 && next.length() != 8 ) {
			try {
				throw new Exception(" DateLib.getDateDiff() : 날짜 형식이 yyyyMMdd 가 아닙니다. 날짜형식을 확인하세요.");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return 0;
			}
		}
		
		return DateLib._doCalcDiff( DateLib._setCalendar(prev) ,  DateLib._setCalendar(next) );
	}
	/**
	 * 두 날짜 사이의 일수를 계산 후 반환
	 * @param (Calendar) prev
	 * @param (Calendar) next
	 * @return
	 */
	public static int getDateDiff(Calendar prev, Calendar next){
		return DateLib._doCalcDiff( prev.getTime() , next.getTime() );
	}
	
	/**
	 * 두 날짜 사이의 일수를 계산 후 반환
	 * @param (String) prev : "yyyyMMdd"형태
	 * @param (Calendar) next
	 * @return
	 */
	public static int getDateDiff(String prev, Calendar next){
			prev = DateLib._onlyNumber( prev );
			if( prev.length() != 8 ){
				try {
					throw new Exception(" DateLib.getDateDiff() : 날짜 형식이 yyyyMMdd 가 아닙니다. 날짜형식을 확인하세요.");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					return 0;
				}
			}
			return DateLib._doCalcDiff( DateLib._setCalendar(prev) ,  next.getTime() );
	}
}
