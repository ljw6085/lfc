package com.common.utils;

import java.util.HashMap;
/**
 * CamelCase 형태로 변경
 * @author Leejw
 *
 */
@SuppressWarnings("serial")
public class CamelCaseMap extends HashMap<String,Object>{
	@Override
	public Object put(String key, Object value) {
		return super.put(StrLib.toCamelCase(key), value);
	}
}
