package com.lfc.mgr.mgr0006;

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
import com.common.utils.VAR;
import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;
import com.lfc.mgr.mgr0006.vo.CarModelInfoSearchVO;
import com.lfc.mgr.mgr0006.vo.CarModelInfoVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MGR0006$Controller extends SetLogger {
	
	@Autowired
	MGR0006$Service service;
	
	/**
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_LIST_URL, method=RequestMethod.GET)
	public String list() {
		return UrlMapping.MGR0006_LIST_JSP;
	}
	/**
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_INSERT_URL, method=RequestMethod.GET)
	public String insert() {
		return UrlMapping.MGR0006_INSERT_JSP;
	}
	/**
	 * 상세조회 판넬
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_DETAIL_SEARCH_URL, method=RequestMethod.GET)
	public String detailSearch() {
		return UrlMapping.MGR0006_DETAIL_SEARCH_JSP;
	}
	
	/**
	 * 자동차 모델 정보조회 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_LIST_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CarModelInfoVO> carModelSelect( @RequestBody CarModelInfoSearchVO param ) {
		return service.selectCarModelInfo(param); 
	}
	
	/**
	 * 자동차 모델 정보 등록/수정/삭제
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_INSERT_URL, method=RequestMethod.POST)
	public  @ResponseBody Map<String,String> carModelInsert( @RequestBody CarModelInfoVO param) {
		Map<String,String> returnMap = new HashMap<String,String>();
		// 그냥,,,,, 삭제 후 insert로 함.
		// 1. 분류코드 CRUD 체크 -  진행
		String status = param.getRowStatus();
		
		int ok = 0 ;
		if(VAR.UPDATE.equals(status)){
			ok = service.updateCarModelInfo(param);
		}else if(VAR.INSERT.equals(status)){
			CarModelInfoVO maxId = service.getMaxModelCode();
			param.setModelCode(maxId.getModelCode());
			ok = service.insertCarModelInfo(param);
		}else if(VAR.DELETE.equals(status)){
			ok = service.deleteCarModelInfo(param);
		}
		returnMap.put("ok", ok+"");
		return returnMap; 
	}
	
	/**
	 * 자동차 제조사 구분 조회 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_SELECT_CAR_COMP_DIV_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CmmnCodeVO> selectCarCompDiv( @RequestBody CmmnCodeVO param) {
		return service.selectCarCompDiv(param);
	}
	/**
	 * 자동차 제조사 조회 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_SELECT_CAR_COMP_LIST_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CmmnCodeVO> selectCarCompList( @RequestBody CmmnCodeVO param) {
		return service.selectCarCompList(param);
	}
	/**
	 * 자동차 종류 조회 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_SELECT_CAR_COMP_KIND_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CmmnCodeVO> selectCarKind( @RequestBody CmmnCodeVO param) {
		return service.selectCarKind(param);
	}
	/**
	 * 자동차 외형 조회 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_SELECT_CAR_COMP_OUTLINE_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CmmnCodeVO> selectCarOutline( @RequestBody CmmnCodeVO param) {
		return service.selectCarOutline(param);
	}
	/**
	 * 자동차 연료 조회 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_SELECT_CAR_COMP_FURE_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CmmnCodeVO> selectCarFure( @RequestBody CmmnCodeVO param) {
		return service.selectCarFure(param);
	}
	/**
	 * 자동차 미션 조회 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0006_SELECT_CAR_COMP_MSN_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CmmnCodeVO> selectCarMsn( @RequestBody CmmnCodeVO param) {
		return service.selectCarMsn(param);
	}
}
