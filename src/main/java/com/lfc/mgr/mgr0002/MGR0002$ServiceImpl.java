package com.lfc.mgr.mgr0002;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;
import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;
import com.lfc.mgr.mgr0002.vo.CmmnDivCodeVO;

@Service
public class MGR0002$ServiceImpl extends SetLogger implements MGR0002$Service{

	@Autowired
	CommonDAO dao;
	
	@Override
	public List<CmmnDivCodeVO> selectDivCodeList(CmmnDivCodeVO param) {
		List<CmmnDivCodeVO> list = dao.selectList("MGR0002.selectDivCodeList",param);
		if( null == list ) list = new ArrayList<CmmnDivCodeVO>(); 
		return list;
	}

	@Override
	public CmmnDivCodeVO selectDivCode(CmmnDivCodeVO vo) {
		CmmnDivCodeVO result = dao.selectOne("MGR0002.selectDivCodeList", vo);
		if( null == result ) result = new CmmnDivCodeVO();
		return result;
	}

	@Override
	public List<CmmnCodeVO> selectCmmnCodeList(CmmnCodeVO vo) {
		List<CmmnCodeVO> result = dao.selectList("MGR0002.selectCmmnCode",vo);
		if( null == result ) result = new ArrayList<CmmnCodeVO>();
		return result;
	}

	@Override
	public int deleteCmmnCode(CmmnCodeVO vo) {
		return dao.delete("MGR0002.deleteCmmnCode",vo);
	}

	@Override
	public int insertCmmnCode(CmmnCodeVO vo) {
		return dao.insert("MGR0002.insertCmmnCode",vo);
	}
}
