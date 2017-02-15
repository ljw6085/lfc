package com.common.utils;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
/**
 * 공통 Util 객체
 * @author Leejw
 *
 */
public class LfcUtils {
	/** logger */
	public final Logger logger;
	public LfcUtils() { logger = LoggerFactory.getLogger(this.getClass()); }
	
	/**
	 * 로그인을 했는지 체크한다.
	 * @param req
	 * @return
	 */
	public static boolean isLogin( HttpServletRequest req ){
		if( null == req.getSession().getAttribute("userId") ){
			return false;
		}else{
			return true;
		}
		
	}
	
	/**
	 * 로그인을 했는지 체크한다.
	 * @param req
	 * @return
	 */
	public static String isLogin( HttpServletRequest req ,String returnOK, String returnNG ){
		if( null == req.getSession().getAttribute("userId") ){
			return returnNG;
		}else{
			return returnOK;
		}
		
	}
}
