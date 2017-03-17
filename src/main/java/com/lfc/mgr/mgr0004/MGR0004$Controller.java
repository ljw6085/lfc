package com.lfc.mgr.mgr0004;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.common.SetLogger;
import com.common.UrlMapping;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MGR0004$Controller extends SetLogger {
	
	@Autowired
	MGR0004$Service service;
	
	/**
	 * 주차장관리 메인페이지이동
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0004_LIST_URL, method=RequestMethod.GET)
	public String list() {
		return UrlMapping.MGR0004_LIST_JSP;
	}
	/**
	 * 주차장관리 메인페이지이동
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0004_INSERT_URL, method=RequestMethod.GET)
	public String insert() {
		return UrlMapping.MGR0004_INSERT_JSP;
	}
	/**
	 * 상세조회 판넬
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0004_DETAIL_SEARCH_URL, method=RequestMethod.GET)
	public String detailSearch() {
		return UrlMapping.MGR0004_DETAIL_SEARCH_JSP;
	}
}
