package com.lfc.prk.prk0002;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.common.SetLogger;
import com.common.UrlMapping;
import com.lfc.prk.prk0001.vo.PrkplceCellMngVO;
import com.lfc.prk.prk0002.vo.SvgObjectInfoVO;

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
	@RequestMapping(value = UrlMapping.PRK0002_MAIN_URL2 , method=RequestMethod.GET)
	public String parkingMain2(Locale locale, Model model) {
		return UrlMapping.PRK0002_MAIN_JSP2;
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
	
	/**
	 * 주차장관리 정보입력
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PRK0002_INSERT_URL , method=RequestMethod.POST)
	@ResponseBody List<PrkplceCellMngVO>parkingManager(Locale locale, Model model , @RequestBody List<PrkplceCellMngVO> param) {
		logger.debug("################# {}", param);
		for( PrkplceCellMngVO vo : param ){
			service.insertPrkplaceCell(vo);
		}
		return param;
	}
	
	/**
	 * 주차장관리 정보입력
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PRK0002_SELECT_SVG_OBJECT_INFO_URL , method=RequestMethod.POST)
	@ResponseBody Map<String,String> selectSvgObjectInfo(Locale locale, Model model , @RequestBody SvgObjectInfoVO param) {
		return service.selectSvgObjectInfo(param);
	}
	
}
