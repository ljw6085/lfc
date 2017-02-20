package com.lfc.sample.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;

@Service("sample2")
public class SampleServiceImpl2 extends SetLogger implements SampleService{
	@Autowired
	CommonDAO dao;
	@Override
	public void SampleService1() {
		logger.debug(this.getClass().getName() +" sample service 1 !!");
	}

	@Override
	public void SampleService2() {
		logger.debug(this.getClass().getName() +" sample service 2 !!");
	}

}
