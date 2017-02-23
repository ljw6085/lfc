package com.lfc.prk.prk0001;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.common.SetLogger;
import com.common.UrlMapping;
import com.lfc.prk.prk0001.vo.PrkplceCellMngVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class PRK0001$Controller extends SetLogger {
	
	@Autowired
	PRK0001$Service service;
	
	@RequestMapping(value = UrlMapping.PARKING_INSERT_URL )
	public @ResponseBody Map<String, Object> parkingInsert(Locale locale, Model model, @RequestBody List<PrkplceCellMngVO> list) {
		Map<String,Object> returnMap = new HashMap<String,Object>();
		logger.debug(" param size == {}", list.size());
		int result = service.insertParkgingCellInfo(list);
		returnMap.put("successCount", result);
		return returnMap;
	}
	@RequestMapping(value = UrlMapping.PARKING_SELECT_URL )
	public @ResponseBody Map<String, Object> parkingSelect(Locale locale, Model model, @RequestBody PrkplceCellMngVO vo) {
		Map<String,Object> returnMap = new HashMap<String,Object>();
		logger.debug("####### vo ==> {}" , vo );
		List<PrkplceCellMngVO> result = service.selectParkgingFloorInfo(vo);
		returnMap.put("result", result);
		return returnMap;
	}
	
}
