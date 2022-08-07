package com.account.db;

import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

public interface AccountBookRule {
	
	// 로그인 회원가입 비밀번호찾기  - FORM 방식
	public void backController(ModelAndView mav, int num);
	
	// 입력 예산 셋팅 - JSON 방식
	public void backController(Model model, int num);
	
}
