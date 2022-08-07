package com.account.db;

import java.util.HashMap;
import java.util.List;

import com.account.bean.AccessBean;
import com.account.bean.MoneyBean;
import com.account.bean.SettingBean;

public interface MapperDB {

	/* 로그인 */
	public String matchPassword(AccessBean ac); // 로그인시 암호화된 패스워드 SELECT
	public int insAsl(AccessBean ac);	// 로그인 로그 INSERT
	public String isAccess(AccessBean ac);	// 아이피 확인
	public List<AccessBean> getAccessInfo(AccessBean ab);	// 가장 마지막 로그인
	
	
	/* 회원가입 */
	public String getMmCode();	// 회원가입시 CODE MAX SELECT
	public int insMember(AccessBean ac);	// 회원가입 INSERT
	
	
	/* 비밀번호 찾기 */
	public List<AccessBean> getPassword(AccessBean ab);	// 비밀번호 찾기 휴대폰번호or이름 기준으로 가져오기 SELECT
	
	
	/* 설정 */
	public List<SettingBean> getCustomer(AccessBean ab);	// 거래처 SELECT
	public String getCutomerCode();	// 거래처 코드
	public int isCuCode();	// 거래처 코드
	public List<SettingBean> getMoneyList(AccessBean ab);	// 예산 SELECT
	public int insCustomer(SettingBean sb);	// 거래처 INSERT
	public int updCustomer(SettingBean sb);	// 거래처 UPDATE
	public int delCustomer(SettingBean sb);	// 거래처 DELETE
	public SettingBean getTheme(AccessBean ab); // 현재 테마 SELECT
	public int insTheme(SettingBean ab); // 회원가입시 테마 INSERT
	public int updTheme(SettingBean ab); // 테마 변경 UPDATE
	public int delTheme(AccessBean ab); // 회원탈퇴시 테마 DELETE
	public String isPassword(SettingBean sb);	// 비밀번호 변경 중, 기존 비밀번호 매치 여부 확인
	public int updPassword(SettingBean sb);	// 비밀번호 변경 중, 새로 입력받은 비밀번호로 업데이트
	
	
	/* 입력 */

	
	/* 예산 */
	public List<MoneyBean> getMoList(HashMap map); // 예산 카테고리별 정보 SELECT
	public String getTotalBudget(HashMap map);// 내가 설정한 총 예산
	public String getTotalSpendBudget(HashMap map);// 내가 이번달 사용한 총 예산
	public int updTotalBudget(HashMap map); // 클라이언트에서 새로 입력받은 총 예산금액 업데이트하기
	public int updMinBudget(HashMap map); // 클라이언트에서 새로 입력받은 최소 예산금액 업데이트하기
	public String isUseCustomer(MoneyBean mb); // 삭제하려는 예산카테고리를 자식테이블인 customer테이블에서 사용중인지 확인
	public int delMoInCu(MoneyBean mb); // 예산카테고리에서 쓰고있다면 삭제
	public int delMoneyCa(MoneyBean mb); // MONEY테이블에서 예산카테고리 삭제
	public String getMoCode(MoneyBean mb); // insert할때 MOCODE 최대값or최소값 불러오기
	public int insMoney(MoneyBean mb); // MONEY테이블에 예산카테고리 추가
	public String getStatus(HashMap map); // (총설정예산-현재지출액) 가져오기
}
