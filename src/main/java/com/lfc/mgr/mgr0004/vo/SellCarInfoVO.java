package com.lfc.mgr.mgr0004.vo;

import com.common.vo.CommonVO;

public class SellCarInfoVO extends CommonVO{

	private String sellCarInnb;
	private String carDiv;
	private int brand;
	private int series;
	private int model;
	private int level;
	private String mission;
	private String fure;
	private String color;
	private String region;
	private String spot;
	private String company;
	private int cc;
	private String usedYear;
	private int usedDis;
	private String carNum;
	private String owner;
	private String ownerPhone;
	private String saleYn;
	private String prkplceCode;
	private String prkplceFlrCode;
	private String cellMapngId;
	private String holdYn;

	public void setSellCarInnb(String sellCarInnb) {
		this.sellCarInnb = sellCarInnb;
	}
	public String getSellCarInnb() {
		return sellCarInnb;
	}
	public void setCarDiv(String carDiv) {
		this.carDiv = carDiv;
	}
	public String getCarDiv() {
		return carDiv;
	}
	public void setBrand(int brand) {
		this.brand = brand;
	}
	public int getBrand() {
		return brand;
	}
	public void setSeries(int series) {
		this.series = series;
	}
	public int getSeries() {
		return series;
	}
	public void setModel(int model) {
		this.model = model;
	}
	public int getModel() {
		return model;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public int getLevel() {
		return level;
	}
	public void setMission(String mission) {
		this.mission = mission;
	}
	public String getMission() {
		return mission;
	}
	public void setFure(String fure) {
		this.fure = fure;
	}
	public String getFure() {
		return fure;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getColor() {
		return color;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getRegion() {
		return region;
	}
	public void setSpot(String spot) {
		this.spot = spot;
	}
	public String getSpot() {
		return spot;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getCompany() {
		return company;
	}
	public void setCc(int cc) {
		this.cc = cc;
	}
	public int getCc() {
		return cc;
	}
	public void setUsedYear(String usedYear) {
		this.usedYear = usedYear;
	}
	public String getUsedYear() {
		return usedYear;
	}
	public void setUsedDis(int usedDis) {
		this.usedDis = usedDis;
	}
	public int getUsedDis() {
		return usedDis;
	}
	public void setCarNum(String carNum) {
		this.carNum = carNum;
	}
	public String getCarNum() {
		return carNum;
	}
	public void setOwner(String owner) {
		this.owner = owner;
	}
	public String getOwner() {
		return owner;
	}
	public void setOwnerPhone(String ownerPhone) {
		this.ownerPhone = ownerPhone;
	}
	public String getOwnerPhone() {
		return ownerPhone;
	}
	public void setSaleYn(String saleYn) {
		this.saleYn = saleYn;
	}
	public String getSaleYn() {
		return saleYn;
	}
	public void setPrkplceCode(String prkplceCode) {
		this.prkplceCode = prkplceCode;
	}
	public String getPrkplceCode() {
		return prkplceCode;
	}
	public void setPrkplceFlrCode(String prkplceFlrCode) {
		this.prkplceFlrCode = prkplceFlrCode;
	}
	public String getPrkplceFlrCode() {
		return prkplceFlrCode;
	}
	public void setCellMapngId(String cellMapngId) {
		this.cellMapngId = cellMapngId;
	}
	public String getCellMapngId() {
		return cellMapngId;
	}
	public void setHoldYn(String holdYn) {
		this.holdYn = holdYn;
	}
	public String getHoldYn() {
		return holdYn;
	}

	@Override
	public String toString() {
		return "[sellCarInnb=" + sellCarInnb
		 + ", carDiv=" + carDiv
		 + ", brand=" + brand
		 + ", series=" + series
		 + ", model=" + model
		 + ", level=" + level
		 + ", mission=" + mission
		 + ", fure=" + fure
		 + ", color=" + color
		 + ", region=" + region
		 + ", spot=" + spot
		 + ", company=" + company
		 + ", cc=" + cc
		 + ", usedYear=" + usedYear
		 + ", usedDis=" + usedDis
		 + ", carNum=" + carNum
		 + ", owner=" + owner
		 + ", ownerPhone=" + ownerPhone
		 + ", saleYn=" + saleYn
		 + ", prkplceCode=" + prkplceCode
		 + ", prkplceFlrCode=" + prkplceFlrCode
		 + ", cellMapngId=" + cellMapngId
		 + ", holdYn=" + holdYn + "]";
	}
}