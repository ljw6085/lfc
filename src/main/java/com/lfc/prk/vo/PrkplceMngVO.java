package com.lfc.prk.vo;

/**
 * 주차장관리테이블 VO
 * @author Leejw
 *
 */
public class PrkplceMngVO {

	private String prkplceCode;
	private String prkplceNm;
	private String rm;
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
		return "PrkplceMngVO [prkplceCode=" + prkplceCode + ", prkplceNm=" + prkplceNm + ", rm=" + rm + "]";
	}
}