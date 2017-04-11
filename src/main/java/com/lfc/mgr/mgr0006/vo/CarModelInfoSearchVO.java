package com.lfc.mgr.mgr0006.vo;

import java.util.Arrays;

import com.common.vo.CommonVO;

public class CarModelInfoSearchVO extends CommonVO{

	
	private String carCompGbn;
	private String carComp;
	private String modelCode;
	private String modelNm;
	private String[] carKind;
	private String[] carOutline;
	private String[] carFure;
	private String[] carMsn;
	public String getCarCompGbn() {
		return carCompGbn;
	}
	public void setCarCompGbn(String carCompGbn) {
		this.carCompGbn = carCompGbn;
	}
	public String getCarComp() {
		return carComp;
	}
	public void setCarComp(String carComp) {
		this.carComp = carComp;
	}
	public String getModelCode() {
		return modelCode;
	}
	public void setModelCode(String modelCode) {
		this.modelCode = modelCode;
	}
	public String getModelNm() {
		return modelNm;
	}
	public void setModelNm(String modelNm) {
		this.modelNm = modelNm;
	}
	public String[] getCarKind() {
		return carKind;
	}
	public void setCarKind(String[] carKind) {
		this.carKind = carKind;
	}
	public String[] getCarOutline() {
		return carOutline;
	}
	public void setCarOutline(String[] carOutline) {
		this.carOutline = carOutline;
	}
	public String[] getCarFure() {
		return carFure;
	}
	public void setCarFure(String[] carFure) {
		this.carFure = carFure;
	}
	public String[] getCarMsn() {
		return carMsn;
	}
	public void setCarMsn(String[] carMsn) {
		this.carMsn = carMsn;
	}
	@Override
	public String toString() {
		return "CarModelInfoSearchVO [carCompGbn=" + carCompGbn + ", carComp=" + carComp + ", modelCode=" + modelCode
				+ ", modelNm=" + modelNm + ", carKind=" + Arrays.toString(carKind) + ", carOutline="
				+ Arrays.toString(carOutline) + ", carFure=" + Arrays.toString(carFure) + ", carMsn="
				+ Arrays.toString(carMsn) + "]";
	}
	
}