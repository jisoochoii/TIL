package com.account.bean;

import lombok.Data;

@Data
public class SettingBean {
	/* CATEGORY (CA) */
	private String CACODE; // AC
	private String CANAME;
	/* LOCAL (LO) */
	
	/* LOCAL (LO) */
	private String LOCODE;	// AC + IO
	private String LONAME;
	
	/* CUSTOMER (CU) */
	private String CUCODE;	// IO
	private String CUNAME;
	private String MOCODE;
	private String MONAME;
	
	/* ACCOUNT (AC) */
	private String ACCODE;	// IO
	private String ACNAME;
	
	private String MMCODE;
	private String MMNAME;
	private String MMPASSWORD;
	private String MMMESSAGE;
	
	/* SETTING (ST) */
	private String HBCOLOR;	// 헤더
	private String HFCOLOR;
	private String CBCOLOR; // 본문 
	private String CFCOLOR;
}
