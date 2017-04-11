package com.lfc.mgr.mgr0006;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;
import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;
import com.lfc.mgr.mgr0006.vo.CarModelInfoSearchVO;
import com.lfc.mgr.mgr0006.vo.CarModelInfoVO;

@Service
public class MGR0006$ServiceImpl extends SetLogger implements MGR0006$Service{

	@Autowired
	CommonDAO dao;

	@Override
	public List<CmmnCodeVO> selectCarCompDiv(CmmnCodeVO param) {
		List<CmmnCodeVO> returnList = dao.selectList("MGR0006.selectCarCompDiv",param);
		if( returnList == null ) returnList = new ArrayList<CmmnCodeVO>(); 
		return returnList;
	}

	@Override
	public List<CmmnCodeVO> selectCarCompList(CmmnCodeVO param) {
		List<CmmnCodeVO> returnList = dao.selectList("MGR0006.selectCarCompList",param);
		if( returnList == null ) returnList = new ArrayList<CmmnCodeVO>(); 
		return returnList;
	}

	@Override
	public List<CmmnCodeVO> selectCarKind(CmmnCodeVO param) {
		List<CmmnCodeVO> returnList = dao.selectList("MGR0006.selectCarKind",param);
		if( returnList == null ) returnList = new ArrayList<CmmnCodeVO>(); 
		return returnList;
	}

	@Override
	public List<CmmnCodeVO> selectCarOutline(CmmnCodeVO param) {
		List<CmmnCodeVO> returnList = dao.selectList("MGR0006.selectCarOutline",param);
		if( returnList == null ) returnList = new ArrayList<CmmnCodeVO>(); 
		return returnList;
	}

	@Override
	public List<CmmnCodeVO> selectCarFure(CmmnCodeVO param) {
		List<CmmnCodeVO> returnList = dao.selectList("MGR0006.selectCarFure",param);
		if( returnList == null ) returnList = new ArrayList<CmmnCodeVO>(); 
		return returnList;
	}

	@Override
	public List<CmmnCodeVO> selectCarMsn(CmmnCodeVO param) {
		List<CmmnCodeVO> returnList = dao.selectList("MGR0006.selectCarMsn",param);
		if( returnList == null ) returnList = new ArrayList<CmmnCodeVO>(); 
		return returnList;
	}

	@Override
	public List<CarModelInfoVO> selectCarModelInfo(CarModelInfoSearchVO param) {
		List<CarModelInfoVO> returnList = dao.selectList("MGR0006.selectCarModelInfo",param);
		if( returnList == null ) returnList = new ArrayList<CarModelInfoVO>(); 
		return returnList;
	}

	@Override
	public int insertCarModelInfo(CarModelInfoVO param) {
		return dao.insert("MGR0006.insertCarModelInfo", param);
	}

	@Override
	public int updateCarModelInfo(CarModelInfoVO param) {
		return dao.update("MGR0006.updateCarModelInfo", param);
	}

	@Override
	public int deleteCarModelInfo(CarModelInfoVO param) {
		return dao.delete("MGR0006.deleteCarModelInfo", param);
	}

	@Override
	public CarModelInfoVO getMaxModelCode() {
		CarModelInfoVO result = dao.selectOne("MGR0006.getMaxModelCode");
		if( result == null ) result = new CarModelInfoVO(); 
		return result;
	}
	
}
