package com.lfc.mgr.mgr0001.vo;

public class MenuInfoVO {

	private String menuId;
	private String menuDiv;
	private String menuNm;
	private String menuKindCd;
	private String menuPid;
	private String menuUrl;
	private String menuImg1;
	private String menuImg2;
	private String menuIcon;
	private int sort;
	private int useAuth;
	private String useAt;
	private String regDt;
	private String regUserId;

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}
	public String getMenuId() {
		return menuId;
	}
	public void setMenuDiv(String menuDiv) {
		this.menuDiv = menuDiv;
	}
	public String getMenuDiv() {
		return menuDiv;
	}
	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}
	public String getMenuNm() {
		return menuNm;
	}
	public void setMenuKindCd(String menuKindCd) {
		this.menuKindCd = menuKindCd;
	}
	public String getMenuKindCd() {
		return menuKindCd;
	}
	public void setMenuPid(String menuPid) {
		this.menuPid = menuPid;
	}
	public String getMenuPid() {
		return menuPid;
	}
	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}
	public String getMenuUrl() {
		return menuUrl;
	}
	public void setMenuImg1(String menuImg1) {
		this.menuImg1 = menuImg1;
	}
	public String getMenuImg1() {
		return menuImg1;
	}
	public void setMenuImg2(String menuImg2) {
		this.menuImg2 = menuImg2;
	}
	public String getMenuImg2() {
		return menuImg2;
	}
	public void setMenuIcon(String menuIcon) {
		this.menuIcon = menuIcon;
	}
	public String getMenuIcon() {
		return menuIcon;
	}
	public void setSort(int sort) {
		this.sort = sort;
	}
	public int getSort() {
		return sort;
	}
	public void setUseAuth(int useAuth) {
		this.useAuth = useAuth;
	}
	public int getUseAuth() {
		return useAuth;
	}
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}
	public String getUseAt() {
		return useAt;
	}
	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}
	public String getRegDt() {
		return regDt;
	}
	public void setRegUserId(String regUserId) {
		this.regUserId = regUserId;
	}
	public String getRegUserId() {
		return regUserId;
	}
	@Override
	public String toString() {
		return "MenuInfoVO [menuId=" + menuId + ", menuDiv=" + menuDiv + ", menuNm=" + menuNm + ", menuKindCd="
				+ menuKindCd + ", menuPid=" + menuPid + ", menuUrl=" + menuUrl + ", menuImg1=" + menuImg1
				+ ", menuImg2=" + menuImg2 + ", menuIcon=" + menuIcon + ", sort=" + sort + ", useAuth=" + useAuth
				+ ", useAt=" + useAt + ", regDt=" + regDt + ", regUserId=" + regUserId + "]";
	}
	
}