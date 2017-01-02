package com.lfc.sample.service;

import org.springframework.stereotype.Service;

import com.common.CommonService;

@Service("sample2")
public class SampleServiceImpl2 extends CommonService implements SampleService{
	
	@Override
	public void SampleService1() {
		logger.debug(this.getClass().getName() +" sample service 1 !!");
	}

	@Override
	public void SampleService2() {
		logger.debug(this.getClass().getName() +" sample service 2 !!");
	}

}
