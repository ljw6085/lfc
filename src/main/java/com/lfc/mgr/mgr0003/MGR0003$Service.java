package com.lfc.mgr.mgr0003;

import java.util.List;

import com.lfc.prk.prk0001.vo.PrkplceFlrMngVO;
import com.lfc.prk.prk0001.vo.PrkplceMngVO;

public interface MGR0003$Service {
	public List<PrkplceMngVO> selectPrkCodeList(PrkplceMngVO param);
	public List<PrkplceFlrMngVO> selectPrkplaceFlr(PrkplceFlrMngVO param);
	
	public int insertPrkplace(PrkplceMngVO param);
	public int updatePrkplace(PrkplceMngVO param);
	public int deletePrkplace(PrkplceMngVO param);
	public int deletePrkplaceFlr(PrkplceMngVO param);
}
