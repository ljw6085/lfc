package com.common;
/**
 * URL Mapping 를 관리한다.
 * 
 * @author Leejw
 *
 */
public class UrlMapping {

	/** url  : /home.do */
	public static final String HOME_URL="/home.do";
	/** jsp  : home.jsp */
	public static final String HOME_JSP="home";

	/** 
	 * url  : /test.do <br>
	 * desc : Mybatis DB Test URL 
	 * */
	public static final String TEST_URL="/test.do";

	/** url  : */
	public static final String LOGIN_URL="/cmm/login/login.do";
	/** jsp  : */
	public static final String LOGIN_JSP="/cmm/login/login";
	
	
	/** url  : */
	public static final String INDEX_URL="/index.do";
	/** jsp  : */
	public static final String INDEX_JSP="/index";

	/** url  : */
	public static final String CODE_LIST_URL="/mgr/codeList.do";
	/** jsp  : */
	public static final String CODE_LIST_JSP="/mgr/code/codeList";
	
	
	
	/**
	 * url : /prk/insertPrkData.do<br>
	 * desc : 주차장데이터 입력
	 */
	public static final String PARKING_INSERT_URL="/prk/insertPrkData.do";
	/**
	 * url : /prk/selectPrkData.do<br>
	 * desc : 주차장데이터 로드
	 */
	public static final String PARKING_SELECT_URL="/prk/selectPrkData.do";
}
