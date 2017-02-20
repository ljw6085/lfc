package com.lfc.prk.vo;

/**
 * 주차장관리테이블VO 상속 > [주차장층 관리테이블 VO]
 * @author Leejw
 *
 */
public class PrkplceFlrMngVO extends PrkplceMngVO{

	private String prkplceCode;
	private String prkplceFlrCode;
	private String prkplceFlrNm;
	private String drwPath;
	private int sort;
	private String rm;
	@Override
	public String getPrkplceCode() {
		return prkplceCode;
	}
	@Override
	public void setPrkplceCode(String prkplceCode) {
		this.prkplceCode = prkplceCode;
	}
	public String getPrkplceFlrCode() {
		return prkplceFlrCode;
	}
	public void setPrkplceFlrCode(String prkplceFlrCode) {
		this.prkplceFlrCode = prkplceFlrCode;
	}
	public String getPrkplceFlrNm() {
		return prkplceFlrNm;
	}
	public void setPrkplceFlrNm(String prkplceFlrNm) {
		this.prkplceFlrNm = prkplceFlrNm;
	}
	public String getDrwPath() {
		return drwPath;
	}
	public void setDrwPath(String drwPath) {
		this.drwPath = drwPath;
	}
	public int getSort() {
		return sort;
	}
	public void setSort(int sort) {
		this.sort = sort;
	}
	@Override
	public String getRm() {
		return rm;
	}
	@Override
	public void setRm(String rm) {
		this.rm = rm;
	}
	@Override
	public String toString() {
		return "PrkplceFlrMngVO [prkplceCode=" + prkplceCode + ", prkplceFlrCode=" + prkplceFlrCode + ", prkplceFlrNm="
				+ prkplceFlrNm + ", drwPath=" + drwPath + ", sort=" + sort + ", rm=" + rm + "]";
	}
	
}
