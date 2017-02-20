package com.lfc.prk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.common.CommonDAO;
import com.common.SetLogger;
import com.lfc.prk.vo.PrkplceCellMngVO;

@Service
public class ParkingServiceImpl extends SetLogger implements ParkingService{
	@Autowired
	CommonDAO dao;
	@Override
	public int insertParkgingCellInfo(PrkplceCellMngVO cell) {
		return dao.insert("Parking.insertPrkplaceCell", cell);
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED)
	// 트랜잭션 해결안됨
	public int insertParkgingCellInfo(List<PrkplceCellMngVO> cellList) {
		// TODO Auto-generated method stub
		int result = 0;
		for( PrkplceCellMngVO vo : cellList ){
			result += insertParkgingCellInfo(vo);
		}
		return result ;
	}

	@Override
	public List<PrkplceCellMngVO> selectParkgingFloorInfo(PrkplceCellMngVO vo) {
		return dao.selectList("Parking.selectPrkplaceCell",vo);
	}
	
}
