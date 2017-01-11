package com.common.utils;

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
	
}
