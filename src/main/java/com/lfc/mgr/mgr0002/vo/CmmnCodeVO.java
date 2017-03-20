package com.lfc.mgr.mgr0002.vo;

import java.sql.Timestamp;

public class CmmnCodeVO {

	private String 		parentCode;
	private String 		grpCode;
	private String 		code;
	private String 		codeNm;
	private String 		codeDc;
	private String 		useAt;
	private int 		sort;
	private Timestamp 	frstRegistDt;
	private String		frstRegister;
	private Timestamp 	lastRegistDt;
	private String 		lastRegister ;

	public String getGrpCode() {
		return grpCode;
	}
	public void setGrpCode(String grpCode) {
		this.grpCode = grpCode;
	}
	public void setParentCode(String parentCode) {
		this.parentCode = parentCode;
	}
	public String getParentCode() {
		return parentCode;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCode() {
		return code;
	}
	public void setCodeNm(String codeNm) {
		this.codeNm = codeNm;
	}
	public String getCodeNm() {
		return codeNm;
	}
	public void setCodeDc(String codeDc) {
		this.codeDc = codeDc;
	}
	public String getCodeDc() {
		return codeDc;
	}
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}
	public String getUseAt() {
		return useAt;
	}
	public void setSort(int sort) {
		this.sort = sort;
	}
	public int getSort() {
		return sort;
	}
	public void setFrstRegistDt(Timestamp frstRegistDt) {
		this.frstRegistDt = frstRegistDt;
	}
	public Timestamp getFrstRegistDt() {
		return frstRegistDt;
	}
	public void setFrstRegister(String frstRegister) {
		this.frstRegister = frstRegister;
	}
	public String getFrstRegister() {
		return frstRegister;
	}
	public void setLastRegistDt(Timestamp lastRegistDt) {
		this.lastRegistDt = lastRegistDt;
	}
	public Timestamp getLastRegistDt() {
		return lastRegistDt;
	}
	public void setLastRegister (String lastRegister ) {
		this.lastRegister  = lastRegister ;
	}
	public String getLastRegister () {
		return lastRegister ;
	}

	@Override
	public String toString() {
		return "CmmnCodeVO [parentCode=" + parentCode + ", grpCode=" + grpCode + ", code=" + code + ", codeNm=" + codeNm
				+ ", codeDc=" + codeDc + ", useAt=" + useAt + ", sort=" + sort + ", frstRegistDt=" + frstRegistDt
				+ ", frstRegister=" + frstRegister + ", lastRegistDt=" + lastRegistDt + ", lastRegister=" + lastRegister
				+ "]";
	}
}