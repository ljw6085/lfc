package com.lfc.mgr.mgr0001;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;
import com.lfc.mgr.mgr0001.vo.MenuInfoVO;

@Service
public class MGR0001$ServiceImpl extends SetLogger implements MGR0001$Service{

	@Autowired
	CommonDAO dao;
	
	@Override
	public List<MenuInfoVO> selectMenuList(MenuInfoVO param) {
		logger.debug(" #### load menu List ");
		List<MenuInfoVO> result = dao.selectList("MGR0001.selectMenuList",param);
		if( null == result )result = new ArrayList<MenuInfoVO>();
		return result;
	}

	@Override
	public Map<String, String> getMaxMenuId(){ 
		return dao.selectOne("MGR0001.getMaxMenuId");
	}

	@Override
	public int deleteMenuList(MenuInfoVO param) {
		return dao.delete("MGR0001.deleteMenu",param);
	}

	@Override
	public int insertMenuList(MenuInfoVO param) {
		return dao.insert("MGR0001.insertMenu",param);
	}
}
