package com.common;

import org.springframework.stereotype.Component;

/**
 * URL Mapping 를 관리한다.
 * 
 * @author Leejw
 *
 */
@Component
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
	public static final String LOGOUT_URL="/cmm/login/logout.do";
	
	
	/** url  : */
	public static final String INDEX_URL="/index.do";
	/** jsp  : */
	public static final String INDEX_JSP="/index";

	/** url  : 메뉴관리 리스트조회*/
	public static final String MGR0001_LIST_URL="/mgr/mgr0001/menuList.do";
	/** jsp  : 메뉴관리 리스트조회*/
	public static final String MGR0001_LIST_JSP="/mgr/mgr0001/menuList";
	
	/** url  : 공통코드관리 */
	public static final String MGR0002_LIST_URL="/mgr/mgr0002/codeList.do";
	/** jsp  : 공통코드관리 */
	public static final String MGR0002_LIST_JSP="/mgr/mgr0002/codeList";
	
	
	
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
