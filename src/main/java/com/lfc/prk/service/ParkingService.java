package com.lfc.prk.service;

import java.util.List;

import com.lfc.prk.vo.PrkplceCellMngVO;

public interface ParkingService {
	public int insertParkgingCellInfo(PrkplceCellMngVO cell);
	public int insertParkgingCellInfo(List<PrkplceCellMngVO> cellList);
	public List<PrkplceCellMngVO> selectParkgingFloorInfo(PrkplceCellMngVO vo);
}
