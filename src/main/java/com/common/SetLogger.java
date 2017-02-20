package com.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.common.utils.LfcUtils;

/**
 * log4j Logger 를 세팅해주는 공통 클래스
 * 해당 클래스를 상속받아 사용하면 logger 객체를 사용할 수 있다.
 * @author Leejw
 *
 */
public class SetLogger {
	@Autowired
	/** 공통 util */
	public LfcUtils utils;
	@Autowired
	public CommonModel commonModel;
	/** logger */
	public final Logger logger;
	
	public SetLogger() {
		logger = LoggerFactory.getLogger(this.getClass());
	}
}
