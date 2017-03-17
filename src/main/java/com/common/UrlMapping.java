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

	/** url  :  */
	public static final String LOGIN_URL="/cmm/login/login.do";
	/** jsp  : */
	public static final String LOGIN_JSP="/cmm/login/login";
	/** url  : */
	public static final String LOGOUT_URL="/cmm/login/logout.do";
	
	
	/** url  : */
	public static final String INDEX_URL="/index.do";
	/** jsp  : */
	public static final String INDEX_JSP="/index";

	
	/** url  : 공통코드 로드 */
	public static final String GET_COMMON_CODE="/getCommonCode.do";
	
	
	
/***************************************************************************************************/
	
	/** url  : 메뉴관리 리스트조회*/
	public static final String MGR0001_LIST_URL="/mgr/mgr0001/menuList.do";
	/** jsp  : 메뉴관리 리스트조회*/
	public static final String MGR0001_LIST_JSP="/mgr/mgr0001/menuList";
	/** url  : 메뉴관리 메뉴등록/수정*/
	public static final String MGR0001_INSERT_URL="/mgr/mgr0001/menuInert.do";
	/** url  : 메뉴Id 자동채번 load */
	public static final String MGR0001_GET_MAX_MENUID_URL="/mgr/mgr0001/getMaxMenuId.do";
	
/***************************************************************************************************/
	
	/** url  : 공통코드관리 조회 */
	public static final String MGR0002_LIST_URL="/mgr/mgr0002/codeList.do";
	/** jsp  : 공통코드관리 */
	public static final String MGR0002_LIST_JSP="/mgr/mgr0002/codeList";

	/** url  : 공통코드관리 등록 */
	public static final String MGR0002_INSERT_URL="/mgr/mgr0002/codeInsert.do";
	/** jsp  : 공통코드관리 */
	public static final String MGR0002_INSERT_JSP="/mgr/mgr0002/codeInsert";
	
	/** url  : 공통코드관리 삭제 */
	public static final String MGR0002_DELETE_URL="/mgr/mgr0002/codeDelete.do";
	
	/** url  : 공통코드관리 상세조회 */
	public static final String MGR0002_DETAIL_SELECT_URL="/mgr/mgr0002/codeDetailSelect.do";
	
/***************************************************************************************************/	
	
	/** url  : 주차장코드관리 조회 */
	public static final String MGR0003_LIST_URL="/mgr/mgr0003/codeList.do";
	/** jsp  : 주차장코드관리 */
	public static final String MGR0003_LIST_JSP="/mgr/mgr0003/codeList";
	
	/** url  : 주차장코드관리 등록 */
	public static final String MGR0003_INSERT_URL="/mgr/mgr0003/codeInsert.do";
	/** jsp  : 주차장코드관리 */
	public static final String MGR0003_INSERT_JSP="/mgr/mgr0003/codeInsert";
	
	/** url  : 주차장코드관리 삭제 */
	public static final String MGR0003_DELETE_URL="/mgr/mgr0003/codeDelete.do";
	
	/** url  : 주차장코드관리 상세조회 */
	public static final String MGR0003_DETAIL_SELECT_URL="/mgr/mgr0003/codeDetailSelect.do";
	
/***************************************************************************************************/
	/** url  : 판매차량 조회 */
	public static final String MGR0004_LIST_URL="/mgr/mgr0004/MGR0004$List.do";
	/** jsp  : 판매차량관리 */
	public static final String MGR0004_LIST_JSP="/mgr/mgr0004/MGR0004$List";
	
	/** url  : 판매차량 등록 */
	public static final String MGR0004_INSERT_URL="/mgr/mgr0004/MGR0004$Insert.do";
	/** jsp  : 판매차량관리 */
	public static final String MGR0004_INSERT_JSP="/mgr/mgr0004/MGR0004$Insert";
	
	/** url  : 판매차량 등록 */
	public static final String MGR0004_DETAIL_SEARCH_URL="/mgr/mgr0004/MGR0004$DetailSearch.do";
	/** jsp  : 판매차량관리 */
	public static final String MGR0004_DETAIL_SEARCH_JSP="/mgr/mgr0004/MGR0004$DetailSearch";
/***************************************************************************************************/	
	
	/** url  : 주차장관리 메인 */
	public static final String PRK0001_MAIN_URL="/prk/prk0001/parkingListMain.do";
	/** jsp  : 주차장관리 메인이동 */
	public static final String PRK0001_MAIN_JSP="/prk/prk0001/parkingListMain";
	
	/** url  : 주차장관리 관리페이지이동 */
	public static final String PRK0001_MANAGER_URL="/prk/prk0002/parkingListManager.do";
	/** jsp  : 주차장관리 관리페이지이동 */
	public static final String PRK0001_MANAGER_JSP="/prk/prk0002/parkingListManager";
	
	/** url  : 주차장관리 메인 */
	public static final String PRK0002_MAIN_URL="/prk/prk0002/parkingMgrMain.do";
	/** jsp  : 주차장관리 메인이동 */
	public static final String PRK0002_MAIN_JSP="/prk/prk0002/parkingMgrMain";
	
	/** url  : 주차장관리 층정보 상세조회*/
	public static final String PRK0002_DETAIL_URL="/prk/prk0002/parkingMgrDetail.do";
	/** jsp  : 주차장관리 메인이동 */
	public static final String PRK0002_DETAIL_JSP="/prk/prk0002/parkingMgrDetail";
	
	
	
	/** url  : 주차장관리 층정보 조회메인 */
	public static final String PRK0002_SELECT_URL="/prk/prk0002/parkingMgrSelect.do";
	
	
	/** url  : 주차장관리 관리페이지이동 */
	public static final String PRK0002_INSERT_URL="/prk/prk0002/parkingMgrInsert.do";
	/** jsp  : 주차장관리 관리페이지이동 */
	public static final String PRK0002_INSERT_JSP="/prk/prk0002/parkingMgrInsert";
	
	
	/** url  : svg object 정보 로드*/
	public static final String PRK0002_SELECT_SVG_OBJECT_INFO_URL="/prk/prk0002/selectSvgObjectInfo.do";
	
	
	
	/**
	 * url : /prk/deletePrkData.do<br>
	 * desc : 주차장데이터 삭제
	 */
	public static final String PARKING_DELETE_URL="/prk/deletePrkData.do";
	/**
	 * url : /prk/updatePrkData.do<br>
	 * desc : 주차장데이터 수정
	 */
	public static final String PARKING_UPDATE_URL="/prk/updatePrkData.do";
	/**
	 * url : /prk/insertPrkData.do<br>
	 * desc : 주차장데이터 입력
	 */
	public static final String PARKING_INSERT_URL="/prk/insertPrkData.do";
	/**
	 * url : /prk/selectPrkData.do<br>
	 * desc : 주차장 도면 데이터 로드
	 */
	public static final String PARKING_SELECT_URL="/prk/selectPrkData.do";
	
	
	/**
	 * url : /prk/deletePrkFlrData.do<br>
	 * desc : 주차장데이터 삭제
	 */
	public static final String PARKING_FLR_DELETE_URL="/prk/deletePrkFlrData.do";
	/**
	 * url : /prk/updatePrkFlrData.do<br>
	 * desc : 주차장데이터 수정
	 */
	public static final String PARKING_FLR_UPDATE_URL="/prk/updatePrkFlrData.do";
	/**
	 * url : /prk/insertPrkFlrData.do<br>
	 * desc : 주차장데이터 입력
	 */
	public static final String PARKING_FLR_INSERT_URL="/prk/insertPrkFlrData.do";
	/**
	 * url : /prk/selectPrkFlrData.do<br>
	 * desc : 주차장 도면 데이터 로드
	 */
	public static final String PARKING_FLR_SELECT_URL="/prk/selectPrkFlrData.do";
}
