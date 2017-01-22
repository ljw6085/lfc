package com.common.utils;

import java.util.HashMap;

import org.springframework.stereotype.Component;
/**
 * CamelCase 형태로 변경
 * @author Leejw
 *
 */
@Component
@SuppressWarnings("serial")
public class CamelCaseMap extends HashMap<String,Object>{
	@Override
	public Object put(String key, Object value) {
		return super.put(StrLib.toCamelCase(key), value);
	}
}
