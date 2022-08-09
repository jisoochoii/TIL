package com.account.bean;

import lombok.Data;

@Data
public class AccessBean {
	/* MEMBER (MM) */
	private String MMCODE;		// MM + AH + MO + TM + IO
	private String MMPASSWORD;
	private String MMNAME;
	private String MMPHONE;
	
	/* ACCESSHISTORY (AH) */
	private String AHDATE;
	private String AHPUBLICIP;
	private String AHPRIVATEIP;
	private int AHACTION;
	
	/* 현재 달 */
	private String MONTH;
}
