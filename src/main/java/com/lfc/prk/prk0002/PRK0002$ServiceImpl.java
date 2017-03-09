package com.lfc.prk.prk0002;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;
import com.lfc.prk.prk0001.vo.PrkplceCellMngVO;
import com.lfc.prk.prk0001.vo.PrkplceFlrMngVO;
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

	@Override
	public List<Map<String,String>> selectPrkplaceCell(PrkplceCellMngVO param) {
		List<Map<String,String>> result = dao.selectList("PRK0002.selectPrkplaceCell", param);
		if( null == result )result = new ArrayList<Map<String,String>>();
		return result;
	}

	@Override
	public int deletePrkplaceCell(PrkplceCellMngVO param) {
		return dao.delete("PRK0002.deletePrkplaceCell",param);
	}

	@Override
	public int updatePrkplaceCell(PrkplceCellMngVO param) {
		return dao.update("PRK0002.updatePrkplaceCell",param);
	}

	
	@Override
	public int insertPrkplaceFlr(PrkplceFlrMngVO param) {
		return dao.insert("PRK0002.insertPrkplaceFlr" , param);
	}

	@Override
	public int deletePrkplaceFlr(PrkplceFlrMngVO param) {
		return dao.delete("PRK0002.deletePrkplaceFlr",param);
	}

	@Override
	public int updatePrkplaceFlr(PrkplceFlrMngVO param) {
		return dao.update("PRK0002.updatePrkplaceFlr",param);
	}

	@Override
	public List<Map<String, String>> selectPrkplaceFlr(PrkplceFlrMngVO param) {
		List<Map<String,String>> result = dao.selectList("PRK0002.selectPrkplaceFlr", param);
		if( null == result )result = new ArrayList<Map<String,String>>();
		return result;
	}

	@Override
	public List<PrkplceFlrMngVO> selectPrkFlrList(PrkplceFlrMngVO param) {
		List<PrkplceFlrMngVO> result = dao.selectList("MGR0003.selectPrkFlrList", param);
		if( null == result )result = new ArrayList<PrkplceFlrMngVO>();
		return result;
	}

	@Override
	public Map<String, Object> selectPrkFlrInfo(PrkplceFlrMngVO param) {
		Map<String,Object> result = dao.selectOne("MGR0003.selectPrkInfo", param);
		if( null == result) result = new HashMap<String,Object>();
		return result;
	}


	

	
	
}
