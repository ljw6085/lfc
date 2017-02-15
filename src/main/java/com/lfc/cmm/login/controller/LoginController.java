package com.lfc.cmm.login.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.common.CommonController;
import com.common.UrlMapping;
import com.common.utils.LfcUtils;
import com.lfc.cmm.login.vo.UserInfoVO;

@Controller
public class LoginController extends CommonController{
	@RequestMapping(value = UrlMapping.LOGOUT_URL, method = RequestMethod.GET)
	public String logout(Locale locale, Model model, HttpServletRequest req) {
		req.getSession().invalidate();
		return UrlMapping.LOGIN_JSP;
	}
	@RequestMapping(value = UrlMapping.LOGIN_URL, method = RequestMethod.GET)
	public String login(Locale locale, Model model, HttpServletRequest req) {
		String returnOK = UrlMapping.INDEX_JSP;
		String returnNG = UrlMapping.LOGIN_JSP;
		return LfcUtils.isLogin(req, returnOK, returnNG);
	}
	@RequestMapping(value = UrlMapping.LOGIN_URL, method = RequestMethod.POST)
	public String loginAction(Locale locale, Model model, @ModelAttribute UserInfoVO vo, HttpServletRequest req) {
		if( !vo.getUserId().isEmpty() ){
			req.getSession().setAttribute("userId", vo.getUserId());
			return UrlMapping.INDEX_JSP;
		}
		return UrlMapping.LOGIN_JSP;
	}
}
