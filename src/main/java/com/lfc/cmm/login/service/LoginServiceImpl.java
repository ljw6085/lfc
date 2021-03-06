package com.lfc.cmm.login.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;

@Service
public class LoginServiceImpl extends SetLogger implements LoginService{
	@Autowired
	CommonDAO dao;
	@Override
	public void SampleService1() {
		logger.debug(this.getClass().getName() +" sample service 1 !!");
		String result = dao.selectOne("Common.test");
		List<HashMap<String,String>> lists = dao.selectList("Common.list");
		logger.debug("Common.Test ==> " + result);
		logger.debug("Common.Test ==> " + lists.size());
	}

	@Override
	public void SampleService2() {
		logger.debug(this.getClass().getName() +" sample service 2 !!");
	}

}
