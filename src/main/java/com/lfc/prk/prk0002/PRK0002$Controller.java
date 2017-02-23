package com.lfc.prk.prk0002;

import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.common.SetLogger;
import com.common.UrlMapping;

/**
 * Handles requests for the application home page.
 */
@Controller
public class PRK0002$Controller extends SetLogger {
	
	@Autowired
	PRK0002$Service service;
	
	/**
	 * 주차장관리 메인페이지이동
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PRK0002_MAIN_URL , method=RequestMethod.GET)
	public String parkingMain(Locale locale, Model model) {
		return UrlMapping.PRK0002_MAIN_JSP;
	}
	/**
	 * 주차장관리 메인페이지이동
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PRK0002_INSERT_URL , method=RequestMethod.GET)
	public String parkingManager(Locale locale, Model model) {
		return UrlMapping.PRK0002_INSERT_JSP;
	}
	
}
