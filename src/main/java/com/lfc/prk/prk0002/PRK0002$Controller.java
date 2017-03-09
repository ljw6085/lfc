package com.lfc.prk.prk0002;

import java.util.ArrayList;
import java.util.HashMap;
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
import com.lfc.prk.prk0001.vo.PrkplceFlrMngVO;
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
	@RequestMapping(value = UrlMapping.PRK0002_DETAIL_URL , method=RequestMethod.GET)
	public String parkingDetail(Locale locale, Model model) {
		return UrlMapping.PRK0002_DETAIL_JSP;
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
		//귀찮으니,,, 걍 삭제후 입력으로 하자...ㅎㅎ
		if( param.size() > 0 ){
			PrkplceCellMngVO deleteParam = new PrkplceCellMngVO();
			deleteParam.setPrkplceCode(param.get(0).getPrkplceCode());
			deleteParam.setPrkplceFlrCode(param.get(0).getPrkplceFlrCode());
			service.deletePrkplaceCell(deleteParam);
		}
		for( PrkplceCellMngVO vo : param ){
			service.insertPrkplaceCell(vo);
		}
		return param;
	}
	
	/**
	 * 주차장관리 정보입력 - 층
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PARKING_FLR_INSERT_URL, method=RequestMethod.POST)
	@ResponseBody PrkplceFlrMngVO parkingFlrInsert(@RequestBody PrkplceFlrMngVO param) {
		//귀찮으니,,, 걍 삭제후 입력으로 하자...ㅎㅎ
		service.insertPrkplaceFlr(param);
		return param;
	}
	/**
	 * 주차장관리 정보수정- 층
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PARKING_FLR_UPDATE_URL, method=RequestMethod.POST)
	@ResponseBody PrkplceFlrMngVO parkingFlrUpdate(@RequestBody PrkplceFlrMngVO param) {
		List<Map<String,String>> selected = service.selectPrkplaceFlr(param);
		if( selected.size() == 0 ){
			service.insertPrkplaceFlr(param);
		}else{
			service.updatePrkplaceFlr(param);
		}
		return param;
	}
	/**
	 * 주차장관리 정보수정- 층
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PARKING_FLR_DELETE_URL, method=RequestMethod.POST)
	@ResponseBody PrkplceFlrMngVO parkingFlrDelete(@RequestBody PrkplceFlrMngVO param) {
		//귀찮으니,,, 걍 삭제후 입력으로 하자...ㅎㅎ
		service.deletePrkplaceFlr(param);
		return param;
	}
	/**
	 * 주차장관리 정보수정- 층
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PARKING_FLR_SELECT_URL, method=RequestMethod.POST)
	@ResponseBody List<Map<String,String>> parkingFlrSelect(@RequestBody PrkplceFlrMngVO param) {
		//귀찮으니,,, 걍 삭제후 입력으로 하자...ㅎㅎ
		return service.selectPrkplaceFlr(param);
	}
	
	@RequestMapping(value = UrlMapping.PRK0002_SELECT_URL )
	public @ResponseBody List<Map<String, Object>> prk0002SelectUrl(@RequestBody PrkplceFlrMngVO param) {
		List<Map<String, Object>> returnList = new ArrayList<Map<String,Object>>();
		List<PrkplceFlrMngVO> result = service.selectPrkFlrList(param);
		for( PrkplceFlrMngVO vo : result ){
			Map<String,Object> flr = new HashMap<String, Object>();
			Map<String,Object> info = service.selectPrkFlrInfo(vo);
			flr.put("vo", vo);
			flr.put("info", info);
			returnList.add(flr);
		}
		
		return returnList;
	}
	
	
	
	/**
	 * svg 객체 정보를 가져온다.
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PRK0002_SELECT_SVG_OBJECT_INFO_URL , method=RequestMethod.POST)
	@ResponseBody Map<String,String> selectSvgObjectInfo(@RequestBody SvgObjectInfoVO param) {
		return service.selectSvgObjectInfo(param);
	}
	/**
	 * 저장된 주차장 도면을 조회해온다.
	 * @return
	 */
	@RequestMapping(value = UrlMapping.PARKING_SELECT_URL , method=RequestMethod.POST)
	@ResponseBody Map<String,Object> selectPrkplaceCell(@RequestBody PrkplceCellMngVO param) {
		Map<String,Object> result = new HashMap<String,Object>();
		
		PrkplceFlrMngVO flrVo = new PrkplceFlrMngVO();
		flrVo.setPrkplceCode(param.getPrkplceCode());
		flrVo.setPrkplceFlrCode(param.getPrkplceFlrCode());
		List<Map<String,String>> sizeInfo = service.selectPrkplaceFlr(flrVo);
		if( sizeInfo.size() > 0 ) result.put("sizeInfo", sizeInfo.get(0));
		
		List<Map<String,String>> resultList = service.selectPrkplaceCell(param);
		logger.debug("====> {} " , resultList);
		result.put("list", resultList);
		return result;
	}
	
}
