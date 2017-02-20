package com.common;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.lfc.mgr.mgr0002.vo.CmmnCodeVO;

@Component
public class CommonModel {
	@Autowired
	CommonDAO dao;

	private Map<String,Map<String,String>> commonCode;
	private Map<String,String> commonDivCode;

	public void refreshCommonCode(){
		commonCode = new HashMap<String,Map<String,String>>();
		commonDivCode= new HashMap<String,String>();
		List<CmmnCodeVO> divCodes = dao.selectList("Common.selectAllCmmnDivCode");
		for( CmmnCodeVO val : divCodes){
			val.setParentCode(val.getCode());
			commonDivCode.put(val.getCode(), val.getCodeNm());
			List<LinkedHashMap<String,String>> result = dao.selectList("Common.selectCmmnCode",val);
			LinkedHashMap<String,String> code = new LinkedHashMap<String,String>();
			for( LinkedHashMap<String,String> _code : result){
				code.put(_code.get("code"), _code.get("codeNm"));
			}
			commonCode.put(val.getCode(), code);
		}
	}
	private void initCommonCode(){
		if( null == commonCode || null == commonDivCode ) refreshCommonCode();
	}
	/**
	 * 분류코드를 가져온다.
	 * @return
	 */
	public Map<String,String> getCommonDivCode(){
		initCommonCode();
		return commonDivCode;
	}
	/**
	 * 공통코드 전부를 가져온다.
	 * @return
	 */
	public Map<String,Map<String,String>> getCommonCode(){
		initCommonCode();
		return commonCode;
	}
	/**
	 * 공통코드 중 특정 분류코드만 가져온다.
	 * @param divCode
	 * @return
	 */
	public Map<String,String> getCommonCode(String divCode){
		initCommonCode();
		Map<String,String> result = commonCode.get(divCode);
		if( null == result) result = new HashMap<String,String>();
		return result;
	}
}
