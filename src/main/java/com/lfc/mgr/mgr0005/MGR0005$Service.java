package com.lfc.mgr.mgr0005;

import java.util.List;

import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;
import com.lfc.mgr.mgr0002.vo.CmmnDivCodeVO;

public interface MGR0005$Service {
	
	public List<CmmnDivCodeVO> selectDivCodeList(CmmnDivCodeVO param);
	public CmmnDivCodeVO selectDivCode(CmmnDivCodeVO vo);
	public List<CmmnCodeVO> selectCmmnCodeList(CmmnCodeVO vo);
	
	public int deleteCmmnCode(CmmnCodeVO vo);
	public int insertCmmnCode(CmmnCodeVO vo);
}
