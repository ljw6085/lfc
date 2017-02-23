package com.lfc.prk.prk0001;

import java.util.List;

import com.lfc.prk.prk0001.vo.PrkplceCellMngVO;

public interface PRK0001$Service {
	public int insertParkgingCellInfo(PrkplceCellMngVO cell);
	public int insertParkgingCellInfo(List<PrkplceCellMngVO> cellList);
	public List<PrkplceCellMngVO> selectParkgingFloorInfo(PrkplceCellMngVO vo);
}
