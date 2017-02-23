package com.lfc.prk.prk0002;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.common.CommonDAO;
import com.common.SetLogger;

@Service
public class PRK0002$ServiceImpl extends SetLogger implements PRK0002$Service{
	@Autowired
	CommonDAO dao;
	
}
