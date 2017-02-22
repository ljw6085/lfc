package com.lfc.mgr.mgr0001;

import java.util.List;
import java.util.Map;

import com.lfc.mgr.mgr0001.vo.MenuInfoVO;

public interface MGR0001$Service {
	public List<MenuInfoVO> selectMenuList(MenuInfoVO param);
	public int deleteMenuList(MenuInfoVO param);
	public int insertMenuList(MenuInfoVO param);
	public Map<String,String> getMaxMenuId();
}
