package com.account.services;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.account.bean.AccessBean;
import com.account.utils.Encryption;
import com.account.utils.ProjectUtils;

@Service
public class Access {
	/* 암호화 복호화 */
	@Autowired
	private Encryption enc;
	/* 세션 */
	@Autowired
	private ProjectUtils session;
	/* DB 접근 */
	@Autowired
	private SqlSessionTemplate sql;
	/* io 이동 */
	@Autowired
	private Inout io;
	@Autowired
	private Setting st;

	// 생성자
	public Access() {
	}

	// 백컨트롤러
	public void backController(ModelAndView mav, int number) {
		switch (number) {
		case 0: // 첫페이지 : 로그인페이지 :: 메인 (세션을 활용하여 결정)
			this.firstCtl(mav);
			break;
		case 1: // 회원가입 폼 제어
			this.joinFormCtl(mav);
			break;
		case 2: // 회원가입 제어
			this.joinCtl(mav);
			break;
		case 3: // 로그인 제어
			this.accessCtl(mav);
			break;
		case 4: // 로그아웃 제어
			this.accessOutCtl(mav);
			break;
		case 5: // 비밀번호찾기 제어
			this.findPasswordCtl(mav);
			break;

		}
	}

	// 채이 - 첫페이지 : 로그인페이지 :: 메인 (세션을 활용하여 결정)
	private void firstCtl(ModelAndView mav) {
		String page = "login";
		// login확인
		try {
			// accessinfo 확인
			if ((AccessBean) this.session.getAttribute("accessInfo") != null) {

				io.backController(mav, 0);
			} else {
				mav.setViewName("login");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.setViewName(page);
	}

	// 지수 - 회원가입 폼 제어
	private void joinFormCtl(ModelAndView mav) {
		// 회원코드+1해서 가져오기
		if (this.sql.selectOne("getMmCode") != null) {
			mav.addObject("MMCODE", this.sql.selectOne("getMmCode"));
		} else {
			mav.addObject("MMCODE", "1001");
		}

	}

	// 지수 - 회원가입 제어
	@Transactional
	private void joinCtl(ModelAndView mav) {
		AccessBean ac = (AccessBean) mav.getModel().get("accessBean");

		// PASSWORD만 MMCODE로 암호화
		try {
			ac.setMMPASSWORD(this.enc.aesEncode(ac.getMMPASSWORD(), ac.getMMCODE()));
		} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException | NoSuchPaddingException
				| InvalidAlgorithmParameterException | IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();
		}
		// DB에 insert
		if (this.convertToBoolean(this.sql.insert("insMember", ac))) {
			// 지수 - TOTALMONEY 테이블에 tm_max, tm_min을 0으로 insert
			if(this.convertToBoolean(this.sql.insert("insTotalMoney",ac))){
			// 설화 - 테마등록을 위해 셋팅으로 이동
			mav.addObject("MMCODE", ac.getMMCODE());
			this.st.backController(mav, 1);

			// 성공
			mav.setViewName("login");
			mav.addObject("message", "회원가입 성공");
			}
		} else {
			// 실패
			mav.setViewName("join");
			mav.addObject("message", "회원가입 실패");
		}

	}

	// 채이 - 로그인 제어
	private void accessCtl(ModelAndView mav) {
		AccessBean ac = ((AccessBean) mav.getModel().get("accessBean"));
		
		try {
			/*
			 지수 - 현재 월 "month"라는 이름으로 세션에 저장
			long time = System.currentTimeMillis();
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM");
			date.format(new Date(time));

			this.session.setAttribute("month", date.format(new Date(time)));

			*/
			if (this.session.getAttribute("accessInfo") != null) {
				mav.setViewName("main");
			} else {

				/* 패스워드 비교 */
				String password = ac.getMMPASSWORD();
				if (password.equals(this.enc.aesDecode(this.sql.selectOne("matchPassword", ac), ac.getMMCODE()))) {
					/* db에 남은 로그인상태 기록을 로그아웃으로 변경(insert) */
					String dbState = (String) this.sql.selectOne("isAccess", ac); // ip
					if (dbState != null) {
						ac.setAHACTION(-1);
						this.sql.insert("insAsl", ac);
					}
					// action
					ac.setAHACTION(1);

					if (this.convertToBoolean(this.sql.insert("insAsl", ac))) {
						AccessBean a = (AccessBean) this.sql.selectList("getAccessInfo", ac).get(0);
						this.session.setAttribute("accessInfo", a);
						// 설화 - 로그인시 사용자의 지정테마를 불러오기
						this.st.backController(mav, 2);
						mav.setViewName("main");
					} else {
						mav.setViewName("login");
					}
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// 설화 - 로그아웃 제어 -- 채이 로그인할때 세션확인, 마지막 접속기록, 로그인기록 id값 확인 후 작성하기.
	private void accessOutCtl(ModelAndView mav) {
		AccessBean ab;

		try {
			/* 세션 생사 확인 */
			ab = (AccessBean) this.session.getAttribute("accessInfo");
			// 세션이 살아있는 경우
			if (ab != null) {
				String lastAccess = (String) this.sql.selectOne("isAccess", ab);
				// DB에 마지막 로그인 기록 확인 null 인지 판단
				if (lastAccess != null) {
					// 로그아웃액션 -1 지정
					ab.setAHACTION(-1);
					// 로그아웃 INSERT
					if (this.convertToBoolean(this.sql.insert("insAsl", ab))) {
						// 세션 소멸
						this.session.removeAttribute("accessInfo");
						// 로그아웃 후 로그인 페이지로 이동
						// mav.setViewName("login");
						// mav.addObject("message", "로그아웃 성공");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.setViewName("login");
		mav.addObject("message", "로그아웃 성공");
	}

	// 설화 - 비밀번호찾기 제어
	private void findPasswordCtl(ModelAndView mav) {
		// 페이지 로드시 알림창을 열지 말지를 결정할 boolean 선언
		boolean disp = false;
		// 클라이언트에서 받아온 코드, 이름, 핸드폰번호 받아온 정보 담기
		AccessBean ab = (AccessBean) mav.getModel().get("accessBean");
		List<AccessBean> abList = new ArrayList<AccessBean>();
		try {
			// DB - PASSWORD 가져오기 (파라미터 : 코드, 핸드폰번호)
			abList = this.sql.selectList("getPassword", ab);
			// 가져온 정보를 복호화하여 mav에 담아서 보내주기.
			abList.get(0).setMMPASSWORD(this.enc.aesDecode(abList.get(0).getMMPASSWORD(), abList.get(0).getMMCODE()));
			// 알림차을 열기 위하여 disp = true 변결 후 mav에 담기
			disp = true;
		} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException | NoSuchPaddingException
				| InvalidAlgorithmParameterException | IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();
		}
		mav.setViewName("find-password");
		mav.addObject("MMINFO", abList);
		mav.addObject("disp", disp);
	}

	private boolean convertToBoolean(int number) {
		return number == 0 ? false : true;
	}

}
