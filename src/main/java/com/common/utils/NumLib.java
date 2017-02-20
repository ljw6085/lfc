package com.common.utils;

import java.text.NumberFormat;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

/**
 * 숫자 관련 클래스 - 숫자를 변형 하는 등 숫자 관련 라이브러리
 * @author Leejw
 */
@Component
public class NumLib {
	
	public static final String[] _kor1 = {  "","일","이","삼","사","오","육","칠","팔","구"  };
	public static final String[] _kor2 = {  "","십","백","천"  };
	public static final String[] _kor3 = {  "", "만","억","조","경","해","자","양","구","간","정","재","극","항하사","아승기","나유타","불가사의","무량대수"};
	
	/**
	 * 숫자를 Cash 형태로 변환
	 * <pre>
	 * 	NumLib.numberCash(123450	, Locale.KOREA	); // "￦123,450" 	
	 * 	NumLib.numberCash(123450.50	, Locale.US		); // "$123,450.50" 	
	 * 	NumLib.numberCash(123450	, Locale.JAPAN	); // "￥123,450"
	 * 	NumLib.numberCash(123450	, Locale.ITALY	); // "€ 123.450,00" 	
	 * 	NumLib.numberCash(123450	, Locale.GERMANY); // "123.450,00 €"
	 * </pre>
	 * @param number
	 * @param type
	 * @return
	 */
	public static String numberCash(Object  number , Locale type){
		return NumberFormat.getCurrencyInstance(type).format(number);
	}
	
	/**
	 * 3자리마다 ,(콤마) 를 찍음.
	 * <pre>
	 * NumLib.numberComma( 100000000 ) //"100,000,000"
	 * </pre>
	 * @param num : 변형할숫자
	 * @returns String : 3자리마다 , 가 찍힌 문자열
	 */
	public static String numberComma(int number){
		return NumberFormat.getNumberInstance().format(number);
	}
	
	/**
	 * 3자리마다 ,(콤마) 를 찍음.
	 * <pre>
	 * NumLib.numberComma( 100000000) //"100,000,000"
	 * </pre>
	 * @param num : 변형할숫자
	 * @returns String : 3자리마다 , 가 찍힌 문자열
	 */
	public static String numberComma(long number){
		return NumberFormat.getNumberInstance().format(number);
	}
	/**
	 * 3자리마다 ,(콤마) 를 찍음. (소수점전용)
	 * <pre>
	 * NumLib.numberComma( 100000000.50 ) //"100,000,000.50"
	 * </pre>
	 * @param num : Number 또는 숫자로 변형 가능한 String
	 * @returns String : 3자리마다 , 가 찍힌 문자열
	 */
	public static String numberComma(Object  number){
		String tmp =String.valueOf(number), tmp2 = "";
		int dot = tmp.indexOf(".");
		if( dot > -1 ){
			tmp2 = tmp.substring(dot);
			tmp = tmp.substring(0,dot);
		}
		Pattern p = Pattern.compile("\\B(?=(\\d{3})+(?!\\d))");
		Matcher m = p.matcher(tmp);
		return m.replaceAll(",") + tmp2;
	}
	
	/**
	 * ,(콤마) 를 제거한 숫자를 반환 
	 * 
	 * <pre>
	 * NumLib.removeComma("100,000,000") // "100000000"
	 * </pre>
	 * 
	 * @param strNum : 콤마가 포함되어있는 숫자
	 * @returns String : 콤마가 제거된 숫자의 문자열
	 */
	public static long removeComma(String commaNum){
		return Long.parseLong( commaNum.replaceAll(",", "") );
	}
	/**
	 * 사용자가 지정한 포맷을 적용시켜 리턴한다.<br/>
	 * 문자열을 템플릿 화 시킬 수 있다.
	 * 매칭되는 부분은 반드시 '#' 문자열을 사용한다.<br/>
	 * # 앞 뒤로 오는 문자열은 그대로 반영된다.
	 * 
	 * <pre>
	 * NumLib.format( "8801011111111" ,'######-#######') // "880101-1111111"
	 * NumLib.format( "20160512" ,'####-##-##') // "2016-05-12"
	 * NumLib.format( "1000000000" ,'오늘의 최저가 : #,### 원') //"오늘의 최저가 : 1,000,000,000 원"
	 * </pre>
	 * 
	 * @param num
	 * @param format 두 개 이상의 '#'을 포함한 포맷형식
	 * @returns String
	 */
	public static String format ( long num, String format ){
		String str = num+"";
		if( StrLib.count(format, "#") < 2){
			try {
				throw new Exception(" NumLib.format() :  '#' 은 2개 이상 입력해야합니다.");
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
	 * 숫자를 한글 숫자로 변환하여 반환.<br/>
	 * 
	 * <pre>
	 * NumLib.toHangul(100000000); // "일억"
	 * NumLib.toHangul(5390); // "오천삼백구십"
	 * </pre>
	 * 
	 * @param num
	 * @returns String
	 */
	public static String toHangul( Object num ){
		String tmp = "";
		
		String _split = null;
		if( num instanceof String ){
			String chkStr = (String)num;
			// 숫자외의 다른 문자열이 들어있거나, 9999무량대수를 초과하는경우 ""로 리턴
			if(Pattern.compile("[^\\d]").matcher(chkStr).find() || chkStr.length() > 72) return "";
			_split = StrLib.templete( chkStr ,"#,####");
		}else if( num instanceof Long ){
			_split = NumLib.format( (Long)num ,"#,####");
		}else if( num instanceof Integer ){
			_split = NumLib.format( (Integer) num ,"#,####");
		}else{
			return "";
		}
		// 4자리마다 자른 후 뒤집어서 배열화 함.
		String[] split = ComLib.reverseArray( _split.split(",") );
		
		for( int k=0, len = split.length ; k < len ; k++){
			int j = 0; 
			String pcs = split[k] , unitWord = "";
			
			for( int i = pcs.length()-1; i>=0;i--){
				
				int idx = Integer.parseInt( pcs.charAt(j++)+"" );
				String kor = NumLib._kor1[ idx ]; // 숫자 한글변환
				
				String unit = ( kor == "" ) ? "" : NumLib._kor2[i]; // 십,백,천 변환
				
				// 만단위 이상이고, 4자리씩끊었을때 마지막자리이고, 0000 이 아닌경우 숫자단위(만,억,경...)을 붙인다.
				if( k > 0 && i == 0 && ( Integer.parseInt( pcs ) > 0 ) )  unit +=   NumLib._kor3[k]; // 숫자 단위변환
				
				unitWord +=	kor + unit;
			}
			tmp = unitWord + tmp;
		}
		return tmp;
	}
}
