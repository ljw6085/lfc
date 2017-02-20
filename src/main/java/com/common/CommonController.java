package com.common;

import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;

/**
 * 공통 Controller 객체로써 컨트롤러 단에서 공통으로 사용해야하는 부분이 있다면
 * 여기서 구현한다.
 * ex) logger 세팅
 * @author Leejw
 *
 */
@Controller
public class CommonController extends SetLogger {

	@Autowired CommonService service;
	
	@RequestMapping(value = UrlMapping.GET_COMMON_CODE , method=RequestMethod.POST)
	public @ResponseBody Map<String,String>  getCommonCode(Locale locale, Model model 
				, @RequestBody CmmnCodeVO vo) {
		return commonModel.getCommonCode(vo.getParentCode());
	}
}
