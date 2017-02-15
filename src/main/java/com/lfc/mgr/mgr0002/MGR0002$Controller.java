package com.lfc.mgr.mgr0002;

import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.common.CommonController;
import com.common.UrlMapping;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MGR0002$Controller extends CommonController {
	
	@Autowired
	MGR0002$Service service;
	
	@RequestMapping(value = UrlMapping.MGR0002_LIST_URL , method=RequestMethod.GET)
	public String codeListView(Locale locale, Model model) {
		return UrlMapping.MGR0002_LIST_JSP;
	}
	@RequestMapping(value = UrlMapping.MGR0002_LIST_URL , method=RequestMethod.POST)
	public String codeListSelect(Locale locale, Model model) {
		return UrlMapping.MGR0002_LIST_JSP;
	}
	
}
