package com.account.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.account.bean.AccessBean;
import com.account.bean.SettingBean;
import com.account.db.AccountBookRule;
import com.account.utils.Encryption;
import com.account.utils.ProjectUtils;

@Service
public class Setting implements AccountBookRule{

	/* 암호화 복호화 */
	@Autowired
	private Encryption enc; 
	/* 세션 */
	@Autowired
	private ProjectUtils session; 
	/* DB 접근 */
	@Autowired
	private SqlSessionTemplate sql; 
	
	public Setting() { }

	@Override
	public void backController(ModelAndView mav, int num) {
		try {
			if(this.session.getAttribute("accessInfo")!=null) {
				switch(num) {
				case 0: this.entrance(mav); break;
				case 1: this.insTheme(mav); break;
				case 2: this.getTheme(mav); break;
				default:
				}
			} else {
				mav.setViewName("login");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void backController(Model model, int num) {
		switch(num) {
		case 2: this.updPw(model);
		break;
		case 3: this.checkPw(model); 
		break;
		case 4: this.customerForm(model);
		break;
		case 5: this.updateCustomer(model);
		break;
		case 6: this.deleteCustomer(model);
		break;
		case 7: this.updTheme(model);
		break;
		case 8: this.delTheme(model);
		break;
		default:
		}
	}
	// 입구
	private void entrance(ModelAndView mav) {
		// 설화 - 로그인시 사용자의 지정테마를 불러오기
		this.getTheme(mav);
		mav.setViewName("setting");
	}

	// 지수 - 비밀번호 수정
	private void updPw(Model model) {
	    SettingBean sb = (SettingBean)model.getAttribute("settingBean");
		
	    //입력받은 암호를 암호화해서 저장
	    try {
	    	AccessBean ab = ((AccessBean)this.session.getAttribute("accessInfo"));
			sb.setMMPASSWORD(this.enc.aesEncode(sb.getMMPASSWORD(), ab.getMMCODE()));
		    sb.setMMCODE(ab.getMMCODE());
		} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException | NoSuchPaddingException
				| InvalidAlgorithmParameterException | IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();} catch (Exception e) {e.printStackTrace();}

	    //sql에서 업데이트하기
	    if(this.convertToBoolean(this.sql.update("updPassword", sb))){
	    	sb.setMMMESSAGE("비밀번호 변경 성공");
	    }else {
	    	sb.setMMMESSAGE("비밀번호 변경 실패");
	    }
	    model.addAttribute("settingBean",sb);
	}

	// 지수 - 비밀번호 확인
	private void checkPw(Model model) {
		SettingBean sb = (SettingBean)model.getAttribute("settingBean");
	    String password = sb.getMMPASSWORD();
	    // db에서 해당 mmcode로 비밀번호 가져와서 복호화 한 뒤 클라이언트에서 입력받은 패스워드와 비교
	    // sql구문 SELECT MMPASSWORD FROM MM WHERE #{MMCODE}
	    try {
			AccessBean ab = ((AccessBean)this.session.getAttribute("accessInfo"));
			sb.setMMCODE(ab.getMMCODE());
			if(password.equals(this.enc.aesDecode(this.sql.selectOne("isPassword",sb),ab.getMMCODE()))){
			    //같을때
			    //다시 ajax로 돌아가서 모달창 innerText를 바꾸실 비밀번호로 바꿔주기
				sb.setMMMESSAGE("일치");
			    
			}else{
				sb.setMMMESSAGE("불일치");
			}
		} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException | NoSuchPaddingException
				| InvalidAlgorithmParameterException | IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();} catch (Exception e) {e.printStackTrace();	}
	    model.addAttribute("settingBean",sb);
	}
	
	// 슬기 - 거래처 등록을 위한 양식내용
	private void customerForm(Model model) {
		try {
			List<SettingBean> customerList = new ArrayList<SettingBean>();
			List<SettingBean> moneyList = new ArrayList<SettingBean>();
			AccessBean ab = (AccessBean)this.session.getAttribute("accessInfo");
			
			/* 예산 데이터, 이미 등록되어있는 거래처 데이터 가져오기 */
			customerList = this.sql.selectList("getCustomer", ab);
			moneyList = this.sql.selectList("getMoneyList", ab);
			if(customerList.size()!=0&&customerList!=null) {
				SettingBean temp = new SettingBean();
				temp.setCUCODE(this.sql.selectOne("getCustomerCode", ab));
				customerList.add(temp);
			} else {
				customerList = new ArrayList<SettingBean>();
				SettingBean temp = new SettingBean();
				temp.setCUCODE("1001");
				customerList.add(temp);
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("CustomerList", customerList);
			map.put("MoneyList", moneyList);
			
			model.addAttribute("CustomerInfo", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 슬기 - 거래처 등록
	@Transactional
	private void updateCustomer(Model model) {
		try {
			SettingBean sb = (SettingBean) model.getAttribute("settingBean");
			sb.setMMCODE(((AccessBean)this.session.getAttribute("accessInfo")).getMMCODE());
			
			//존재하는 cuCode면 1=>true 업데이트 실행, 없는 cuCode면 0=>false 인서트 실행
			if(this.convertToBoolean(this.sql.selectOne("isCuCode", sb))) {
				//update
				if(this.convertToBoolean(this.sql.update("updCustomer", sb))) {
					System.out.println("업데이트 성공");
				}
			} else {
				//insert
				if(this.convertToBoolean(this.sql.insert("insCustomer", sb))) {
					System.out.println("인서트 성공");
				}
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.customerForm(model);
	}
	
	// 슬기 - 거래처 삭제
	@Transactional
	private void deleteCustomer(Model model) {
		try {
			SettingBean sb = (SettingBean) model.getAttribute("settingBean");
			sb.setMMCODE(((AccessBean)this.session.getAttribute("accessInfo")).getMMCODE());
			
			//존재하는 cuCode면 1=>true 삭제
			if(this.convertToBoolean(this.sql.selectOne("isCuCode", sb))) {
				//delete
				if(this.convertToBoolean(this.sql.delete("delCustomer", sb))) {
					System.out.println("삭제 성공");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.customerForm(model);
	}
	
	// 설화 - 테마 조회 :: 페이지 이동할 때 사용자의 테마를 조회하여 적용
	private void getTheme(ModelAndView mav) {
		String code = "";
		try {
			// 세션에 있는 MMCODE를 파라미터 값으로 넣어주려고 선언함. 세션이라 트라이캐치문 사용.
			AccessBean ab = (AccessBean) this.session.getAttribute("accessInfo");
			// DB에 접근해서 MMCODE에 맞는 테마코드값을 가져와서 빈에 담았다.
			SettingBean sb = this.sql.selectOne("getTheme", ab);
			// 클라이언트쪽에서 처리를 편하게 하기 위하여 STRING으로 아예 양식을 만들었다.
			code = sb.getHBCOLOR() + ":" + sb.getHFCOLOR() + ":" + sb.getCBCOLOR() + ":" + sb.getCFCOLOR();
		} catch (Exception e) {
			e.printStackTrace();
		} 
		// 클라이언트쪽에 키값으로 넘긴다.
		mav.addObject("themeCode", code);
	}
	
	// 설화 - 테마 신규 :: 회원가입시 자동으로 기본 색상으로 INSERT
	@Transactional
	private void insTheme(ModelAndView mav) {
		try {
			// 새롭게 값을 담아야 해서 선언과 할당을 동시에 함.
			SettingBean sb = new SettingBean();
			
			// 컬러 초기값 지정 ==> 기본
			sb.setHBCOLOR("#D5D2E1");
			sb.setHFCOLOR("#000000");
			sb.setCBCOLOR("#FFFFFF");
			sb.setCFCOLOR("#000000");
			// ACCESS.JAVA에서 코드를 키값으로 받아왔다.
			// 세션을 살려서 해도된다.
			sb.setMMCODE((String)mav.getModel().get("MMCODE"));

			// 초기테마 설정값 INSERT
			if(this.convertToBoolean(this.sql.insert("insTheme" , sb))) {
				System.out.println("인설트 성공");
			}else {
				System.out.println("경고 : 인설트 실패");				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	// 설화 - 테마 추가 :: 테마를 사용자가 선택한 값으로 UPDATE
	@Transactional
	private void updTheme(Model model) {
		try {
			// 클라이언트에서 받아온 테마코드
			SettingBean sb = (SettingBean)model.getAttribute("settingBean");
			// 세션에 살아있는 MMCODE
			AccessBean ab = (AccessBean) this.session.getAttribute("accessInfo");
			
			// 세션에 살아있는 MMCODE를 따로 추가해서 넣어줌.
			// 이유 : 클라이언트에서 받아온 데이터를 값이 포함해서 넘겨야지 UPDATE를 진행 할 수 있음
			sb.setMMCODE(ab.getMMCODE());
			
			if(this.convertToBoolean(this.sql.update("updTheme", sb))) {
				System.out.println("업데이트 성공");
			}else {
				System.out.println("경고 : 업데이트 실패");	
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	// 설화 - 테마 삭제 :: 사용자가 탈퇴를 진행할 때 테마를 삭제 DELETE
	@Transactional
	private void delTheme(Model model) {
		/*
		 * 현재 회원탈퇴가 구현이 안되어 있는 상태이다.
		 * 회원탈퇴 기능을 220807 까지 구현해서 테마 삭제도 반영하기.
		 */
		
		try {
			// 세션에 살아있는 MMCODE를 가져와서 파라미터로 넘기려고 사용함.
			if(this.convertToBoolean(this.sql.delete("delTheme", (AccessBean) this.session.getAttribute("accessInfo")))) {
				System.out.println("딜리트 성공");
			}else {
				System.out.println("경고 : 딜리트 실패");	
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	private boolean convertToBoolean(int number) {		
		return number == 0?false:true;
	}
}
