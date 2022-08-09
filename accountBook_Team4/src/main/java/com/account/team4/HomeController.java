package com.account.team4;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.account.bean.*;
import com.account.services.*;


@Controller
public class HomeController {
	
	/* 각 해당 잡코드에 해당 하는 클래스에 백컨트롤에 접근 */
	@Autowired
	private Access ac;
	@Autowired
	private Inout io;
	@Autowired
	private Money mo;
	@Autowired
	private Setting st;
	

	
	// 채이 - 첫페이지 제어  
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		ab.setAHPRIVATEIP(req.getRemoteAddr());
		mav.addObject(ab);
		this.ac.backController(mav, 0);

		return mav;
	}
	
	// 지수 - 회원가입 폼 사이트 이동 
	@RequestMapping(value = "/JoinForm", method = RequestMethod.POST)
	public ModelAndView joinForm(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		this.ac.backController(mav, 1);
		
		mav.setViewName("join");
	
		return mav;
	}
	
	// 지수 - 회원가입 제어 
	@RequestMapping(value = "/Join", method = RequestMethod.POST)
	public ModelAndView join(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		mav.addObject(ab);
		this.ac.backController(mav, 2);
		
		return mav;
	}
	
	// 채이 - 로그인 제어 
	@RequestMapping(value = "/Access", method = RequestMethod.POST)
	public ModelAndView Access(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		ab.setAHPRIVATEIP(req.getRemoteAddr());
		mav.addObject(ab);
		this.ac.backController(mav, 3);
	
		return mav;
	}
	
	// 설화 - 로그아웃 제어 
		@RequestMapping(value="/AccessOut", method= RequestMethod.POST)
		public ModelAndView logOut(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
			this.ac.backController(mav, 4);
			return mav;
		}
	
	// 설화 - 비밀번호 찾기 페이지로 이동 
	@RequestMapping(value = "/FindPassword", method = RequestMethod.POST)
	public ModelAndView findPassword(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		mav.setViewName("find-password");
		return mav;
	}
	
	// 설화 - 비밀번호 찾기 제어 
	@RequestMapping(value = "/FindOutPassword", method = RequestMethod.POST)
	public ModelAndView findOutPassword(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		// 클라이언트에서 받아서 가져온 정보 mav에 추가 
		mav.addObject(ab);
		// 비밀번호 찾으러간다.
		this.ac.backController(mav, 5);
		return mav;
	}
	
	// 설화 - 비밀번호 찾은 후 로그인 페이지 이동 
	@RequestMapping(value = "/LoginPage", method = RequestMethod.POST)
	public ModelAndView loginPage(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		mav.setViewName("login");
		return mav;
	}
	
	// 설화 - 메인 페이지 이동 
	@RequestMapping(value = "/Main", method = RequestMethod.POST)
	public ModelAndView mainPage(HttpServletRequest req, ModelAndView mav, @ModelAttribute AccessBean ab) {
		// 설화 - 로그인시 사용자의 지정테마를 불러오기
		this.st.backController(mav, 2);
		mav.setViewName("main");
		return mav;
	}
	
	// 슬기 - 입력페이지 이동 
	@RequestMapping(value = "/Inout", method = RequestMethod.POST)
	public ModelAndView inout(HttpServletRequest req, ModelAndView mav, @ModelAttribute InOutBean iob) {
		/*
		 *  지수 - 넘어온 month를 현재 달과 같은지 아닌지 판별해서 다르게 보내줌 
		long time = System.currentTimeMillis();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM");
		String month = date.format(new Date(time));
		mav.addObject(mb);

		
		if(mb.getMONTH().equals(month)) {
			// 넘어온 month가 현재 달과 일치할때
			this.mo.backController(mav, 0);
		}else {
		// 일치하지 않을때
		this.mo.backController(mav, 1);
		}
		 * */
		this.io.backController(mav, 0);
		
		return mav;
	}
	
	// 슬기 - 예산페이지 이동
	@RequestMapping(value = "/Money", method = RequestMethod.POST)
	public ModelAndView money(HttpServletRequest req, ModelAndView mav, @ModelAttribute MoneyBean mb) {
		/* 지수 - 넘어온 month를 현재 달과 같은지 아닌지 판별해서 다르게 보내줌 */
		long time = System.currentTimeMillis();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM");
		String month = date.format(new Date(time));
		mav.addObject(mb);
		
		if(mb.getMONTH().equals(month)) {
			// 넘어온 month가 현재 달과 일치할때
			this.mo.backController(mav, 0);
		}else {
		// 일치하지 않을때
		this.mo.backController(mav, 1);
		}
		
		return mav;
	}
	
	// 슬기 - 설정페이지 이동
	@RequestMapping(value = "/Setting", method = RequestMethod.POST)
	public ModelAndView setting(HttpServletRequest req, ModelAndView mav, @ModelAttribute SettingBean sb) {
		/*
		 *  지수 - 넘어온 month를 현재 달과 같은지 아닌지 판별해서 다르게 보내줌 
		long time = System.currentTimeMillis();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM");
		String month = date.format(new Date(time));
		mav.addObject(mb);

		
		if(mb.getMONTH().equals(month)) {
			// 넘어온 month가 현재 달과 일치할때
			this.mo.backController(mav, 0);
		}else {
		// 일치하지 않을때
		this.mo.backController(mav, 1);
		}
		 * */
		
		this.st.backController(mav, 0);
		
		return mav;
	}
	
}
