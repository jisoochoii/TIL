package com.account.bean;

import lombok.Data;

@Data
public class MoneyBean {
	/* MONEY (MO) */
	private String MMCODE;
	private String MOCODE;		// CU
	private String MONAME;
	private String MOTOTAL; //할당한 예산
	private String SPENDMONEY; //내가 쓴돈
	private int PERBG; // 내가쓴돈/할당한예산 퍼센트. 바에 value로 넣을것.
	private String SPENDTOTALMONEY; //내가 이번달에 사용한 총 예산
	
	/* TOTALMONEY (TM) */
	private String TMMAX;
	private String TMMIN;
	private String STATUS; // TMMAX - 당월 전체 지출금액
	
	/* 작업 수행 결과 alert 메세지 */
	private String message;
	
	/* 현재 달 */
	private String MONTH;
}
