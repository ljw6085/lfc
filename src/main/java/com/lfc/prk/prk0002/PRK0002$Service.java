package com.lfc.prk.prk0002;

import java.util.List;
import java.util.Map;

import com.lfc.prk.prk0001.vo.PrkplceCellMngVO;
import com.lfc.prk.prk0001.vo.PrkplceFlrMngVO;
import com.lfc.prk.prk0002.vo.SvgObjectInfoVO;

public interface PRK0002$Service {
	public List<PrkplceFlrMngVO> selectPrkFlrList(PrkplceFlrMngVO param);
	public Map<String,Object> selectPrkFlrInfo(PrkplceFlrMngVO param);
	
	public int insertPrkplaceFlr(PrkplceFlrMngVO param);
	public int deletePrkplaceFlr(PrkplceFlrMngVO param);
	public int updatePrkplaceFlr(PrkplceFlrMngVO param);
	public List<Map<String,String>> selectPrkplaceFlr(PrkplceFlrMngVO param);
	
	public int insertPrkplaceCell(PrkplceCellMngVO param);
	public int deletePrkplaceCell(PrkplceCellMngVO param);
	public int updatePrkplaceCell(PrkplceCellMngVO param);
	public List<Map<String,String>> selectPrkplaceCell(PrkplceCellMngVO param);
	public Map<String, String> selectSvgObjectInfo(SvgObjectInfoVO param);
}
