package com.common.utils;

import org.springframework.stereotype.Component;

/**
 * 한글관련 상수 클래스 - 한글관련 데이터들을 모아 놓은 클래스
 * @author Leejw
 */
@Component
public class Hangul {
	/**
	 * 한글인경우 종성이 있음
	 */
	public static final int HAS_JONGSUNG = 1;
	/**
	 * 한글인경우 종성이 없음
	 */
	public static final int HAS_NOT_JONGSUNG = 0;
	
	/**
	 * {"는","은"}
	 * (주격) 은/는 - '민우<span style='color:red;'><b>는</b></span> 착함' vs '종욱<span style='color:red;'><b>은</b></span> 착함'
	 */
	public static final String[] UNNUN = {"는","은"};
	/**
	 * {"가","이"}
	 * (주격) 이/가 - "민우<span style="color:red;"><b>가</b></span> 먼저" vs "종욱<span style="color:red;"><b>이</b></span> 먼저"
	 */
	public static final String[] IGA  = {"가","이"};
	/**
	 * {"와","과"}
	 * (병립) 와/과 - "민우<span style="color:red;"><b>와</b></span> 야근" vs "종욱<span style="color:red;"><b>과</b></span> 야근"
	 */
	public static final String[] WAGWA = {"와","과"};
	/**
	 * {"를","을"}
	 * (목적,대상) 을/를 - "민우<span style="color:red;"><b>를</b></span> 칭찬" vs "종욱<span style="color:red;"><b>을</b></span> 칭찬"
	 */
	public static final String[] ULLUL = {"를","을"};
	/**
	 * {"로","으로"}
	 * (목적,대상) 로/으로 - "민우<span style="color:red;"><b>로</b></span> 결정" vs "종욱<span style="color:red;"><b>으로</b></span> 결정"
	 */
	public static final String[] ROURO = {"로","으로"};
	
	/**
	 * 유니코드 한글 시작 : 44032, 끝 : 55199
	 */
	public static final int START_CODE = 44032;
	/**
	 * 초성 코드
	 */
	public static final int CHOSUNG = 588;
	/**
	 * 중성 코드
	 */
	public static final int JUNGSUNG = 28;
	/**
	 * 초성 리스트. 00 ~ 18
	 */
	public static final char[] CHOSUNG_LIST = { 
			'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 
			'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ' , 
			'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 
			'ㅎ' 
	};
	/**
	 * 중성 리스트. 00 ~ 20
	 */
	public static final char[] JUNGSUNG_LIST = {
			'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 
		    'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 
		    'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 
		    'ㅡ', 'ㅢ', 'ㅣ'
	};
	/**
	 * 종성 리스트. 00 ~ 27 + 1(1개 없음)
	 */
	public static final char[] JONGSUNG_LIST = {
			' ', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 
			'ㄶ', 'ㄷ','ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 
			'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ','ㅁ', 'ㅂ', 
			'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 
		    'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
	};
}
