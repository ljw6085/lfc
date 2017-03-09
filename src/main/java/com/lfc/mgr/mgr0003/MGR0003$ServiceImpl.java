package com.lfc.mgr.mgr0003;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;
import com.lfc.prk.prk0001.vo.PrkplceFlrMngVO;
import com.lfc.prk.prk0001.vo.PrkplceMngVO;

@Service
public class MGR0003$ServiceImpl extends SetLogger implements MGR0003$Service{

	@Autowired
	CommonDAO dao;

	@Override
	public List<PrkplceMngVO> selectPrkCodeList(PrkplceMngVO param) {
		List<PrkplceMngVO> result = dao.selectList("MGR0003.selectPrkCodeList",param);
		if( result == null )result = new ArrayList<PrkplceMngVO>();
		return result;
	}

	@Override
	public List<PrkplceFlrMngVO> selectPrkplaceFlr(PrkplceFlrMngVO param) {
		List<PrkplceFlrMngVO> result = dao.selectList("MGR0003.selectPrkplaceFlr",param);
		if( result == null )result = new ArrayList<PrkplceFlrMngVO>();
		return result;
	}

	@Override
	public int insertPrkplace(PrkplceMngVO param) {
		return dao.insert("MGR0003.insertPrkplace", param);
	}

	@Override
	public int updatePrkplace(PrkplceMngVO param) {
		return dao.update("MGR0003.updatePrkplace", param);
	}

	@Override
	public int deletePrkplace(PrkplceMngVO param) {
		return dao.delete("MGR0003.deletePrkplace", param);
	}

	@Override
	public int deletePrkplaceFlr(PrkplceMngVO param) {
		return dao.delete("MGR0003.deletePrkplaceFlr", param);
	}

	
}
