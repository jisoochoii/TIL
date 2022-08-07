package com.account.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.account.db.AccountBookRule;

@Service
public class Inout implements AccountBookRule{
	
	@Autowired
	private Setting st;
	
	public Inout() {}

	@Override
	public void backController(ModelAndView mav, int num) {
		switch(num) {
		case 0: this.entrance(mav); break;
		default:
		}
	}

	@Override
	public void backController(Model model, int num) {
		switch(num) {

		default:
		}
	}
	
	private void entrance(ModelAndView mav) {
		// 설화 - 로그인시 사용자의 지정테마를 불러오기
		this.st.backController(mav, 2);
		mav.setViewName("inout");
	}

}
