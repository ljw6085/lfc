package com.lfc.mgr.mgr0006;

import java.util.List;

import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;
import com.lfc.mgr.mgr0006.vo.CarModelInfoVO;

public interface MGR0006$Service {

	public List<CmmnCodeVO> selectCarCompDiv (CmmnCodeVO param);
	public List<CmmnCodeVO> selectCarCompList (CmmnCodeVO param);
	public List<CmmnCodeVO> selectCarKind (CmmnCodeVO param);
	public List<CmmnCodeVO> selectCarOutline (CmmnCodeVO param);
	public List<CmmnCodeVO> selectCarFure (CmmnCodeVO param);
	public List<CmmnCodeVO> selectCarMsn (CmmnCodeVO param);
	
	public List<CarModelInfoVO> selectCarModelInfo (CarModelInfoVO param);
	public int insertCarModelInfo (CarModelInfoVO param);
	public int updateCarModelInfo (CarModelInfoVO param);
	public int deleteCarModelInfo (CarModelInfoVO param);
}
