package com.lfc.prk.prk0001.vo;

import java.util.List;

import com.common.vo.CommonVO;

/**
 * 주차장관리테이블 VO
 * @author Leejw
 *
 */
public class PrkplceMngVO extends CommonVO{

	private String prkplceCode;
	private String prkplceNm;
	private String rm;
	
	private List<PrkplceFlrMngVO> floorList;
	
	
	public List<PrkplceFlrMngVO> getFloorList() {
		return floorList;
	}
	public void setFloorList(List<PrkplceFlrMngVO> floorList) {
		this.floorList = floorList;
	}
	public String getPrkplceCode() {
		return prkplceCode;
	}
	public void setPrkplceCode(String prkplceCode) {
		this.prkplceCode = prkplceCode;
	}
	public String getPrkplceNm() {
		return prkplceNm;
	}
	public void setPrkplceNm(String prkplceNm) {
		this.prkplceNm = prkplceNm;
	}
	public String getRm() {
		return rm;
	}
	public void setRm(String rm) {
		this.rm = rm;
	}
	@Override
	public String toString() {
		return "PrkplceMngVO [prkplceCode=" + prkplceCode + ", prkplceNm=" + prkplceNm + ", rm=" + rm + ", floorList="
				+ floorList + "]";
	}
}