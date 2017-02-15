package com.lfc.cmm.login.vo;

public class UserInfoVO {
	String userId		
			,passwd	    
			,email	    
			,userAuth  
			,userKind  
			,userNm	
			,phone;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUserAuth() {
		return userAuth;
	}

	public void setUserAuth(String userAuth) {
		this.userAuth = userAuth;
	}

	public String getUserKind() {
		return userKind;
	}

	public void setUserKind(String userKind) {
		this.userKind = userKind;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	@Override
	public String toString() {
		return "UserInfoVO [userId=" + userId + ", passwd=" + passwd + ", email=" + email + ", userAuth=" + userAuth
				+ ", userKind=" + userKind + ", userNm=" + userNm + ", phone=" + phone + "]";
	}
	
}
