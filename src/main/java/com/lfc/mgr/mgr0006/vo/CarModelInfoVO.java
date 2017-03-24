package com.lfc.mgr.mgr0006.vo;

import com.common.vo.CommonVO;

public class CarModelInfoVO extends CommonVO{

	private String carComp;
	private String modelCode;
	private String modelNm;
	private String carKind;
	private String carOutline;
	private String carFure;
	private String carMsn;

	public void setCarComp(String carComp) {
		this.carComp = carComp;
	}
	public String getCarComp() {
		return carComp;
	}
	public void setModelCode(String modelCode) {
		this.modelCode = modelCode;
	}
	public String getModelCode() {
		return modelCode;
	}
	public void setModelNm(String modelNm) {
		this.modelNm = modelNm;
	}
	public String getModelNm() {
		return modelNm;
	}
	public void setCarKind(String carKind) {
		this.carKind = carKind;
	}
	public String getCarKind() {
		return carKind;
	}
	public void setCarOutline(String carOutline) {
		this.carOutline = carOutline;
	}
	public String getCarOutline() {
		return carOutline;
	}
	public void setCarFure(String carFure) {
		this.carFure = carFure;
	}
	public String getCarFure() {
		return carFure;
	}
	public void setCarMsn(String carMsn) {
		this.carMsn = carMsn;
	}
	public String getCarMsn() {
		return carMsn;
	}

	@Override
	public String toString() {
		return "[carComp=" + carComp
		 + ", modelCode=" + modelCode
		 + ", modelNm=" + modelNm
		 + ", carKind=" + carKind
		 + ", carOutline=" + carOutline
		 + ", carFure=" + carFure
		 + ", carMsn=" + carMsn + "]";
	}
}