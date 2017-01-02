package com.lfc.cmm.login.controller;

import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.common.CommonController;
import com.common.UrlMapping;

@Controller
public class LoginController extends CommonController{
	@RequestMapping(value = UrlMapping.LOGIN_URL, method = RequestMethod.GET)
	public String login(Locale locale, Model model) {
		logger.info("LOGIN Controller !!!" );
		return UrlMapping.LOGIN_JSP;
	}
}
