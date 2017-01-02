package com.lfc.sample.controller;

import java.util.Locale;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.common.CommonController;
import com.common.UrlMapping;
import com.lfc.sample.service.SampleService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class TestController extends CommonController{
	
	//private static final Logger logger = LoggerFactory.getLogger(TestController.class);
	
	/*
	 * Type을 기준으로 주입시 : Autowired
	 * 같은 Type을 여러개 써야할경우 ( Name을 구분하여 주입시 ) : Resource(name="이름")
	 * 
	 * */
	@Resource(name="sample1")
	SampleService sample1;
	@Resource(name="sample2")
	SampleService sample2;
	
	@RequestMapping(value = UrlMapping.TEST_URL , method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.debug("================================ test??");
		sample1.SampleService1();
		sample1.SampleService2();
		
		sample2.SampleService1();
		sample2.SampleService2();

		return UrlMapping.HOME_JSP;
	}
}
