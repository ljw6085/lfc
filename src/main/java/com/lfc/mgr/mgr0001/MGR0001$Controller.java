package com.lfc.mgr.mgr0001;

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

import com.common.CommonModel;
import com.common.SetLogger;
import com.common.UrlMapping;
import com.lfc.mgr.mgr0001.vo.MenuInfoVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MGR0001$Controller extends SetLogger {
	
	@Autowired
	MGR0001$Service service;

	@Autowired
	CommonModel commonModel;
	
	@RequestMapping(value = UrlMapping.MGR0001_LIST_URL , method=RequestMethod.GET)
	public String listInit(Locale locale, Model model) {
		return UrlMapping.MGR0001_LIST_JSP;
	}
	@RequestMapping(value = UrlMapping.MGR0001_LIST_URL, method=RequestMethod.POST)
	public @ResponseBody List<MenuInfoVO> listSelect(@RequestBody MenuInfoVO param){
		List<MenuInfoVO> menus = commonModel.getMenuList();
		if( null ==  menus) commonModel.setMenuList(service.selectMenuList(param));
		return commonModel.getMenuList();
	}
	
	@RequestMapping(value = UrlMapping.MGR0001_INSERT_URL, method=RequestMethod.POST)
	public @ResponseBody List<MenuInfoVO> menuInsert(@RequestBody List<MenuInfoVO> param){
		// 전체삭제
		service.deleteMenuList(new MenuInfoVO());
		
		// 화면정보 그대로 insert
		for(MenuInfoVO vo : param) service.insertMenuList(vo);
		
		// 세션 메뉴리스트 업데이트
		commonModel.setMenuList(service.selectMenuList(new MenuInfoVO()));
		return param;
	}

	@RequestMapping(value = UrlMapping.MGR0001_GET_MAX_MENUID_URL, method=RequestMethod.POST)
	public @ResponseBody Map<String,String> getMaxMenuId(){
		return service.getMaxMenuId();
	}
	
}
