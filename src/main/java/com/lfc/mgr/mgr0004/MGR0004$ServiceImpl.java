package com.lfc.mgr.mgr0004;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;

@Service
public class MGR0004$ServiceImpl extends SetLogger implements MGR0004$Service{

	@Autowired
	CommonDAO dao;
	
}
