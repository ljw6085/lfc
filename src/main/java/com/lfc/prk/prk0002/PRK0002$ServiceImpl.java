package com.lfc.prk.prk0002;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;
import com.lfc.prk.prk0001.vo.PrkplceCellMngVO;
import com.lfc.prk.prk0002.vo.SvgObjectInfoVO;

@Service
public class PRK0002$ServiceImpl extends SetLogger implements PRK0002$Service{
	@Autowired
	CommonDAO dao;

	@Override
	public int insertPrkplaceCell(PrkplceCellMngVO param) {
		// TODO Auto-generated method stub
		return dao.insert("PRK0002.insertPrkplaceCell", param);
	}

	@Override
	public Map<String,String> selectSvgObjectInfo(SvgObjectInfoVO param) {
		// TODO Auto-generated method stub
		Map<String,String> result = dao.selectOne("PRK0002.selectSvgObjectInfo", param);
		if( null == result) result = new HashMap<String,String>();
		return result;
	}

	
	
}
