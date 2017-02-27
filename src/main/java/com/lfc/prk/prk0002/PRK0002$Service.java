package com.lfc.prk.prk0002;

import java.util.Map;

import com.lfc.prk.prk0001.vo.PrkplceCellMngVO;
import com.lfc.prk.prk0002.vo.SvgObjectInfoVO;

public interface PRK0002$Service {
	public int insertPrkplaceCell(PrkplceCellMngVO param);
	public Map<String, String> selectSvgObjectInfo(SvgObjectInfoVO param);
}
