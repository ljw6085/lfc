package com.lfc.mgr.mgr0002;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.common.SetLogger;
import com.common.UrlMapping;
import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;
import com.lfc.mgr.mgr0002.vo.CmmnDivCodeVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MGR0002$Controller extends SetLogger {
	
	@Autowired
	MGR0002$Service service;
	
	
	@RequestMapping(value = "/alert.do" , method=RequestMethod.GET)
	public String alert(Model model,@RequestParam(value="message",required=false) String message, @RequestParam(value="title",required=false) String title) {
		model.addAttribute("message",message);
		model.addAttribute("title",title);
		return "cmm/inc/alert";
	}
	
	/**
	 * 분류코드조회 화면 이동
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0002_LIST_URL , method=RequestMethod.GET)
	public String codeListView(Locale locale, Model model) {
		return UrlMapping.MGR0002_LIST_JSP;
	}
	/**
	 * 분류코드 조회 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0002_LIST_URL, method=RequestMethod.POST)
	public  @ResponseBody List<CmmnDivCodeVO> codeListSelect(Locale locale, Model model, @RequestBody CmmnDivCodeVO param) {
		return service.selectDivCodeList(param); 
	}

	/**
	 * 코드 등록/수정 화면이동
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0002_INSERT_URL , method=RequestMethod.GET)
	public String codeListAdd(Locale locale, Model model , @ModelAttribute CmmnCodeVO param) {
		return UrlMapping.MGR0002_INSERT_JSP;
	}
	/**
	 * 코드 등록/수정 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0002_INSERT_URL , method=RequestMethod.POST)
	public @ResponseBody Map<String,String> codeInsert(Locale locale, Model model , @RequestBody CmmnDivCodeVO param) {
		Map<String,String> returnMap = new HashMap<String,String>();
		// 그냥,,,,, 삭제 후 insert로 함.
		
		logger.debug("## 코드 등록 ##" );
		logger.debug("## 등록정보 파라미터 : ##" );
		logger.debug("## {} " , param );
		
		List<CmmnDivCodeVO> div = service.selectDivCodeList(param);
		
		CmmnCodeVO curDivCode = new CmmnCodeVO();
		curDivCode.setParentCode("ROOT");
		curDivCode.setCode(param.getDivCode());
		curDivCode.setCodeNm(param.getDivCodeNm());
		curDivCode.setCodeDc(param.getDivCodeDc());
		curDivCode.setUseAt(param.getDivUseAt());
		
		List<CmmnCodeVO> detailCodes = param.getCodeList();
		if( div.size() > 0){
			//삭제
			codeDelete( param , curDivCode);
		}
		//등록
		int r = service.insertCmmnCode( curDivCode );
		
		if( null != detailCodes ){
			for( CmmnCodeVO vo : detailCodes ){
				int insertR = service.insertCmmnCode( vo );
				logger.debug("");
				logger.debug(" ################ {} : {} 등록 " , "[ "+ insertR +" ]"+ vo.getParentCode() , vo.getCode()+"/"+vo.getCodeNm() );
				logger.debug("");
			}
		}
		returnMap.put("result", r+"");
		return returnMap;
	}
	
	
	/**
	 * 공통코드 상세조회 - ajax
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0002_DETAIL_SELECT_URL , method=RequestMethod.POST)
	public @ResponseBody CmmnDivCodeVO  codeDetailList(@RequestBody CmmnDivCodeVO divCodeVo) {
		CmmnCodeVO VO = new CmmnCodeVO();
		VO.setParentCode(divCodeVo.getDivCode());
		CmmnDivCodeVO resultDivVo  = service.selectDivCode(divCodeVo);
		List<CmmnCodeVO> resultCodeList = service.selectCmmnCodeList(VO);
		resultDivVo.setCodeList(resultCodeList);
		
		return resultDivVo;
	}
	
	
	/**
	 * 코드 삭제 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0002_DELETE_URL, method=RequestMethod.POST)
	public @ResponseBody Map<String,String> codeDelete(Locale locale, Model model , @RequestBody CmmnDivCodeVO param) {
		Map<String,String> returnMap = new HashMap<String,String>();
		
		CmmnCodeVO curDivCode = new CmmnCodeVO();
		curDivCode.setParentCode("ROOT");
		curDivCode.setCode(param.getDivCode());
		
		int r = codeDelete( param , curDivCode);
		returnMap.put("result", r+"");
		return returnMap;
	}
	
	
	/**
	 * 코드 삭제 메서드
	 * @param param
	 * @param curDivCode
	 */
	public int codeDelete( CmmnDivCodeVO param , CmmnCodeVO curDivCode){
		//삭제
		int r = service.deleteCmmnCode( curDivCode );
		
		logger.debug("");
		logger.debug(" ######## 분류코드 {} : {} 삭제 " , curDivCode.getParentCode() ,curDivCode.getCode()+" - "+curDivCode.getCodeNm() );
		logger.debug("");
		
		CmmnCodeVO deleteCodes = new CmmnCodeVO();
		deleteCodes.setParentCode(param.getDivCode());
		int r2 = service.deleteCmmnCode( deleteCodes );
		logger.debug("");
		logger.debug(" ############# 상세코드 {} 건 삭제 " , "[ "+ r +" ]" );
		logger.debug("");
		
		return r + r2;
	}
	
}
