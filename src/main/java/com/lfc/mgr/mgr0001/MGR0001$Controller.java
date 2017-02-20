package com.lfc.mgr.mgr0001;

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
public class MGR0001$Controller extends SetLogger {
	
	@Autowired
	MGR0001$Service service;
	
	@RequestMapping(value = UrlMapping.MGR0001_LIST_URL , method=RequestMethod.GET)
	public String listInit(Locale locale, Model model) {
		return UrlMapping.MGR0001_LIST_JSP;
	}
	@RequestMapping(value = UrlMapping.MGR0001_LIST_URL, method=RequestMethod.POST)
	public String listSelect(Locale locale, Model model) {
		return UrlMapping.MGR0001_LIST_JSP;
	}
	
}
