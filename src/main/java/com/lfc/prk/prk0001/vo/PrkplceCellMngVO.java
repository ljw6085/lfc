package com.lfc.prk.prk0001.vo;

/**
 * 주차장관리테이블VO 상속 > 주차장층 관리테이블 VO 상속 >  [주차장 칸 관리테이블VO] 
 * @author Leejw
 *
 */
public class PrkplceCellMngVO extends PrkplceFlrMngVO{

	private String prkplceCode;
	private String prkplceFlrCode;
	private String cellMapngId;
	private String cellType;
	private String styleCls;
	private String saleCarInnb;
	private String x;
	private String y;
	private String width;
	private String height;
	@Override
	public String getPrkplceCode() {
		return prkplceCode;
	}
	@Override
	public void setPrkplceCode(String prkplceCode) {
		this.prkplceCode = prkplceCode;
	}
	@Override
	public String getPrkplceFlrCode() {
		return prkplceFlrCode;
	}
	@Override
	public void setPrkplceFlrCode(String prkplceFlrCode) {
		this.prkplceFlrCode = prkplceFlrCode;
	}
	public String getCellMapngId() {
		return cellMapngId;
	}
	public void setCellMapngId(String cellMapngId) {
		this.cellMapngId = cellMapngId;
	}
	public String getCellType() {
		return cellType;
	}
	public void setCellType(String cellType) {
		this.cellType = cellType;
	}
	public String getStyleCls() {
		return styleCls;
	}
	public void setStyleCls(String styleCls) {
		this.styleCls = styleCls;
	}
	public String getSaleCarInnb() {
		return saleCarInnb;
	}
	public void setSaleCarInnb(String saleCarInnb) {
		this.saleCarInnb = saleCarInnb;
	}
	public String getX() {
		return x;
	}
	public void setX(String x) {
		this.x = x;
	}
	public String getY() {
		return y;
	}
	public void setY(String y) {
		this.y = y;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
	@Override
	public String toString() {
		return "PrkplceCellMngVO [prkplceCode=" + prkplceCode + ", prkplceFlrCode=" + prkplceFlrCode + ", cellMapngId="
				+ cellMapngId + ", cellType=" + cellType + ", styleCls=" + styleCls + ", saleCarInnb=" + saleCarInnb
				+ ", x=" + x + ", y=" + y + ", width=" + width + ", height=" + height + "]";
	}
}
