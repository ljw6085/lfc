package com.lfc.mgr.mgr0002.vo;

import java.util.List;

import com.common.vo.CommonVO;

public class CmmnDivCodeVO extends CommonVO{

	private String divParentCode;
	private String divCode;
	private String divCodeNm;
	private String divCodeDc;
	private String divUseAt;
	private String divGrpCode;
	private List<CmmnCodeVO> codeList;
	
	public String getDivGrpCode() {
		return divGrpCode;
	}
	public void setDivGrpCode(String divGrpCode) {
		this.divGrpCode = divGrpCode;
	}
	public List<CmmnCodeVO> getCodeList() {
		return codeList;
	}
	public void setCodeList(List<CmmnCodeVO> codeList) {
		this.codeList = codeList;
	}
	public String getDivParentCode() {
		return divParentCode;
	}
	public void setDivParentCode(String divParentCode) {
		this.divParentCode = divParentCode;
	}
	public String getDivCode() {
		return divCode;
	}
	public void setDivCode(String divCode) {
		this.divCode = divCode;
	}
	public String getDivCodeNm() {
		return divCodeNm;
	}
	public void setDivCodeNm(String divCodeNm) {
		this.divCodeNm = divCodeNm;
	}
	public String getDivCodeDc() {
		return divCodeDc;
	}
	public void setDivCodeDc(String divCodeDc) {
		this.divCodeDc = divCodeDc;
	}
	public String getDivUseAt() {
		return divUseAt;
	}
	public void setDivUseAt(String divUseAt) {
		this.divUseAt = divUseAt;
	}
	@Override
	public String toString() {
		return "CmmnDivCodeVO [divParentCode=" + divParentCode + ", divCode=" + divCode + ", divCodeNm=" + divCodeNm
				+ ", divCodeDc=" + divCodeDc + ", divUseAt=" + divUseAt + ", divGrpCode=" + divGrpCode + ", codeList="
				+ codeList + "]";
	}
}