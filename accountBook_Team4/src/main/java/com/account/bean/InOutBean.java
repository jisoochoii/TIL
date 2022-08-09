package com.account.bean;

import lombok.Data;

@Data
public class InOutBean {
	/* INOUT (IO) */
	private String IOCODE;
	private String IODATE;
	private String IOMONEY;
	private String IOMEMO;

	/* 현재 달 */
	private String MONTH;
}
