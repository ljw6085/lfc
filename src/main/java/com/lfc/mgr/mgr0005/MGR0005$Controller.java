package com.lfc.mgr.mgr0005;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.common.SetLogger;
import com.common.UrlMapping;
import com.common.utils.VAR;
import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;
import com.lfc.mgr.mgr0002.vo.CmmnDivCodeVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MGR0005$Controller extends SetLogger {
	
	@Autowired
	MGR0005$Service service;
	
	/**
	 * 분류코드조회 화면 이동
	 * @param locale
	 * @param model
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0005_LIST_URL , method=RequestMethod.GET)
	public String codeListView(Locale locale, Model model) {
		return UrlMapping.MGR0005_LIST_JSP;
	}
	/**
	 * 분류코드 조회 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0005_LIST_URL, method=RequestMethod.POST)
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
	@RequestMapping(value = UrlMapping.MGR0005_INSERT_URL , method=RequestMethod.GET)
	public String codeListAdd(Locale locale, Model model , @ModelAttribute CmmnCodeVO param) {
		return UrlMapping.MGR0005_INSERT_JSP;
	}
	/**
	 * 코드 등록/수정 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0005_INSERT_URL , method=RequestMethod.POST)
	public @ResponseBody Map<String,String> codeInsert(Locale locale, Model model , @RequestBody CmmnDivCodeVO param) {
		Map<String,String> returnMap = new HashMap<String,String>();
		// 그냥,,,,, 삭제 후 insert로 함.
		// 1. 분류코드 CRUD 체크 -  진행
		String status = param.getRowStatus();
		
		CmmnCodeVO divCode = new CmmnCodeVO();
		divCode.setParentCode(param.getDivParentCode());
		divCode.setGrpCode(param.getDivGrpCode());
		divCode.setCode(param.getDivCode());
		divCode.setCodeNm(param.getDivCodeNm());
		divCode.setCodeDc(param.getDivCodeDc());
		divCode.setUseAt(param.getDivUseAt());
		
		// 2. 리스트만큼 돌면서 CRUD 체크 - 진행
		List<CmmnCodeVO> detailCodes = param.getCodeList();
		int div = 0, details = 0;
		if(VAR.UPDATE.equals(status)){
			div = service.updateCmmnCode( divCode );
		}else if(VAR.INSERT.equals(status)){
			div = service.insertCmmnCode( divCode );
		}else if(VAR.DELETE.equals(status)){
			
			div = service.deleteCmmnCode( divCode );
			if( null != detailCodes ){
				for( CmmnCodeVO vo : detailCodes ){
					int	res = service.deleteCmmnCode( vo );
					details += res;
					logger.debug("");
					logger.debug(" ################ {} : {} " , "[ "+ status +" ]"+ vo.getParentCode() , vo.getCode()+"/"+vo.getCodeNm() );
					logger.debug("");
				}
			}
			returnMap.put("divCode", div+"");
			returnMap.put("details", details+"");
			commonModel.refreshCommonCode();
			return returnMap;
		}
		
		if( null != detailCodes ){
			for( CmmnCodeVO vo : detailCodes ){
				String detailStatus = vo.getRowStatus();
				int res=0;
				if(VAR.UPDATE.equals(detailStatus)){
					res = service.updateCmmnCode( vo );
				}else if(VAR.INSERT.equals(detailStatus)){
					res = service.insertCmmnCode( vo );
				}else if(VAR.DELETE.equals(detailStatus)){
					res = service.deleteCmmnCode( vo );
				}
				details += res;
				logger.debug("");
				logger.debug(" ################ {} : {} " , "[ "+ status +" ]"+ vo.getParentCode() , vo.getCode()+"/"+vo.getCodeNm() );
				logger.debug("");
			}
		}
		
		returnMap.put("divCode", div+"");
		returnMap.put("details", details+"");
		commonModel.refreshCommonCode();
		return returnMap;
	}
	
	
	/**
	 * 공통코드 상세조회 - ajax
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0005_DETAIL_SELECT_URL , method=RequestMethod.POST)
	public @ResponseBody CmmnDivCodeVO  codeDetailList(@RequestBody CmmnCodeVO codeVo) {
		CmmnCodeVO VO = new CmmnCodeVO();
		CmmnDivCodeVO div = new CmmnDivCodeVO();
		div.setDivCode(codeVo.getParentCode());
		CmmnDivCodeVO resultDivVo  = service.selectDivCode(div);
		List<CmmnCodeVO> resultCodeList = service.selectCmmnCodeList(codeVo);
		resultDivVo.setCodeList(resultCodeList);
		
		return resultDivVo;
	}
	/**
	 * 공통코드 상세조회 - ajax
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0005_PARENT_CODE_SELECT_URL , method=RequestMethod.POST)
	public @ResponseBody List<CmmnCodeVO>  selectParentCode(@RequestBody CmmnCodeVO codeVo) {
		return service.selectParentCode(codeVo);
	}
	
	
	/**
	 * 코드 삭제 - ajax
	 * @param locale
	 * @param model
	 * @param param
	 * @return
	 */
	@RequestMapping(value = UrlMapping.MGR0005_DELETE_URL, method=RequestMethod.POST)
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
