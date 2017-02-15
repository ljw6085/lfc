package com.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 공통 Service 객체
 * 공통적으로 처리해야할 부분이 있다면 여기서 구현한다.
 * ex ) logger 세팅, DAO 사용
 * @author Leejw
 *
 */
@Service
public class CommonService extends SetLogger{
	@Autowired
	public CommonDAO dao;
}
