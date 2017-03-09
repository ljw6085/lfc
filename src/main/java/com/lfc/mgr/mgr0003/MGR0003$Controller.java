package com.lfc.mgr.mgr0003;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.common.SetLogger;
import com.common.UrlMapping;
import com.lfc.prk.prk0001.vo.PrkplceFlrMngVO;
import com.lfc.prk.prk0001.vo.PrkplceMngVO;
import com.lfc.prk.prk0002.PRK0002$Service;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MGR0003$Controller extends SetLogger {
	
	@Autowired
	MGR0003$Service service;
	
	@Autowired
	PRK0002$Service service0002;
	
	/**
	 * 주차장코드조회 화면 이동
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0003_LIST_URL , method=RequestMethod.GET)
	public String codeListView() {
		return UrlMapping.MGR0003_LIST_JSP;
	}
	/**
	 * 주차장코드 조회 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0003_LIST_URL, method=RequestMethod.POST)
	public  @ResponseBody List<PrkplceMngVO> codeListSelect(@RequestBody PrkplceMngVO param) {
		List<PrkplceMngVO> list = service.selectPrkCodeList(param);
		logger.debug("############## param ==>{}", param);
		logger.debug("############## result ==>{}", list);
		return list;
	}

	/**
	 * 코드 등록/수정 화면이동
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0003_INSERT_URL , method=RequestMethod.GET)
	public String codeListAdd() {
		return UrlMapping.MGR0003_INSERT_JSP;
	}
	/**
	 * 코드 등록/수정 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0003_INSERT_URL , method=RequestMethod.POST)
	public @ResponseBody Map<String,String> codeInsert(@RequestBody PrkplceMngVO param) {
		Map<String,String> returnMap = new HashMap<String,String>();
		// 그냥,,,,, 삭제 후 insert로 함.
		service.deletePrkplace(param);
		service.deletePrkplaceFlr(param);
		service.insertPrkplace(param);
		List<PrkplceFlrMngVO> floorList = param.getFloorList();
		for( PrkplceFlrMngVO vo : floorList  ){
			service0002.insertPrkplaceFlr(vo);
		}
		return returnMap;
	}
	
	
	/**
	 * 공통코드 상세조회 - ajax
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0003_DETAIL_SELECT_URL , method=RequestMethod.POST)
	public @ResponseBody PrkplceMngVO  codeDetailList(@RequestBody PrkplceMngVO param) {
		PrkplceFlrMngVO flrParam = new PrkplceFlrMngVO();
		flrParam.setPrkplceCode( param.getPrkplceCode());
		List<PrkplceFlrMngVO> list = service.selectPrkplaceFlr(flrParam );
		param.setFloorList(list);
		logger.debug("detail select ==> {}" , list);
		return param;
	}
	
	
	/**
	 * 코드 삭제 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0003_DELETE_URL, method=RequestMethod.POST)
	public @ResponseBody Map<String,String> codeDelete(@RequestBody PrkplceMngVO param) {
		Map<String,String> returnMap = new HashMap<String,String>();
		logger.debug("######## code 삭제 !!{}" ,  param );
		service.deletePrkplace(param);
		service.deletePrkplaceFlr(param);
		return returnMap;
	}
	
}
