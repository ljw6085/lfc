package com.lfc.mgr.cdm.controller;

import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.common.CommonController;
import com.common.UrlMapping;
import com.lfc.mgr.cdm.service.CmmCodeService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class CmmCodeController extends CommonController {
	
	@Autowired
	CmmCodeService service;
	
	@RequestMapping(value = UrlMapping.CODE_LIST_URL , method=RequestMethod.GET)
	public String codeListView(Locale locale, Model model) {
		return UrlMapping.CODE_LIST_JSP;
	}
	@RequestMapping(value = UrlMapping.CODE_LIST_URL , method=RequestMethod.POST)
	public String codeListSelect(Locale locale, Model model) {
		
		return UrlMapping.CODE_LIST_JSP;
	}
	
}
