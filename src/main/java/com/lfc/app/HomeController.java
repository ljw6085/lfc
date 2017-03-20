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
	@RequestMapping(value = "/libTest.do", method = RequestMethod.GET)
	public String testtt(Locale locale, Model model, HttpServletRequest req) {
		return "libTest";
	}
	/*@RequestMapping(value = "/getImgTest.do" , method = RequestMethod.GET)
	public String tndex(Locale locale, Model model, HttpServletRequest req) throws IOException, InterruptedException {

		String url = "http://static.naver.net/m/auto/img/emblem/mnfco_%d.png";
		int[] arr = {16, 12, 48, 15, 13, 61321, 21, 23, 18, 20, 30, 39, 22, 41, 6435, 31, 26, 33, 24, 25, 28, 34, 3905, 19, 3848, 4029, 4129, 3824, 3814, 27, 4188, 4040, 3847, 35, 6434, 42, 44, 37, 43, 29, 4216, 46, 6436, 47, 45, 3801, 3999, 3827, 32, 40, 3840, 3806, 36, 3990, 3785, 3976, 29611, 54155, 29981, 52403, 53301, 29972, 47943, 53987, 56237, 29975, 40077, 53655, 29977, 29978, 29979, 50851, 30042, 29989, 58745, 67995, 29982, 29984, 29985, 30040, 29987, 4057, 29970, 54257, 29971, 55563, 53657, 29391, 29974, 55877, 19376, 29973, 18001, 49801, 55571, 29988, 29832, 60645, 14, 30039};

		
		
		String resultFileName = "C:\\Users\\Leejw\\Desktop\\lfc\\car-comp-%d.png";
		for( int i = 0 ; i< arr.length;i++){
			int code = arr[i];
			URL Url = new URL(String.format(url, code));
			URLConnection ucon =  Url.openConnection();
			String filePath = String.format(resultFileName, i);

			OutputStream  outStream = new BufferedOutputStream(new FileOutputStream(filePath));
			InputStream is =  ucon.getInputStream();
			byte[] buf = new byte[1024];
			int byteRead = 0;
			int byteWritten = 0;
			while ((byteRead = is.read(buf)) != -1) {
			    outStream.write(buf, 0, byteRead);
			    byteWritten += byteRead;
			 }
			is.close();
			outStream.close();
		}
		
		for( int i : arr ){
			System.out.println( String.format(url,i));
		}
		return null;
	}*/
	
	
	
	
	
	
	
	
	
	
	
	
	
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
	@RequestMapping(value = "/listTest.do", method = RequestMethod.GET)
	public String listTest(Locale locale, Model model, HttpServletResponse response) {
		return "listTest";
	}
	
}
