package com.lfc.prk.prk0001.vo;

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
	private String drwSizeWidth;
	private String drwSizeHeight;
	private int sort;
	private String rm;
	
	
	public String getDrwSizeWidth() {
		return drwSizeWidth;
	}
	public void setDrwSizeWidth(String drwSizeWidth) {
		this.drwSizeWidth = drwSizeWidth;
	}
	public String getDrwSizeHeight() {
		return drwSizeHeight;
	}
	public void setDrwSizeHeight(String drwSizeHeight) {
		this.drwSizeHeight = drwSizeHeight;
	}
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
				+ prkplceFlrNm + ", drwPath=" + drwPath + ", drwSizeWidth=" + drwSizeWidth + ", drwSizeHeight="
				+ drwSizeHeight + ", sort=" + sort + ", rm=" + rm + "]";
	}
	
}
