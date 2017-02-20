package com.lfc.app;

import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.common.SetLogger;
import com.common.UrlMapping;
import com.common.utils.LfcUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController extends SetLogger{
	
//	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = UrlMapping.HOME_URL , method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return UrlMapping.HOME_JSP;
	}
	
	@RequestMapping(value = UrlMapping.INDEX_URL , method = RequestMethod.GET)
	public String index(Locale locale, Model model, HttpServletRequest req) {
		String returnOK = UrlMapping.INDEX_JSP;
		String returnNG = UrlMapping.LOGIN_JSP;
		return LfcUtils.isLogin(req, returnOK, returnNG);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	@RequestMapping(value = "/test.json" )
	public @ResponseBody Model testjson(Locale locale, Model model) {
		logger.info("json~~~!~! {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		Map<String,String> map = new HashMap<String,String>();
		map.put("test", "aaaaaaaaaaa");
		model.addAttribute("test", "aaaaaaaa");
		return model;
	}
	
	@RequestMapping(value = "/tableTest.do", method = RequestMethod.GET)
	public String testhtml(Locale locale, Model model, HttpServletResponse response) {
		return "mapTest";
	}
	@RequestMapping(value = "/tableTest2.do", method = RequestMethod.GET)
	public String testhtml2(Locale locale, Model model, HttpServletResponse response) {
		return "mapTest2";
	}
	@RequestMapping(value = "/tableTest3.do", method = RequestMethod.GET)
	public String testhtml3(Locale locale, Model model, HttpServletResponse response) {
		return "mapTest3";
	}
	@RequestMapping(value = "/tableTest4.do", method = RequestMethod.GET)
	public String testhtml4(Locale locale, Model model, HttpServletResponse response) {
		return "mapTest4";
	}
	@RequestMapping(value = "/tableTest5.do", method = RequestMethod.GET)
	public String testhtml5(Locale locale, Model model, HttpServletResponse response) {
		return "mapTest5";
	}
	@RequestMapping(value = "/tableTest6.do", method = RequestMethod.GET)
	public String testhtml6(Locale locale, Model model, HttpServletResponse response) {
		return "mapTest6";
	}
	@RequestMapping(value = "/tableTest7.do", method = RequestMethod.GET)
	public String testhtml7(Locale locale, Model model, HttpServletResponse response) {
		return "mapTest7";
	}
	
}
