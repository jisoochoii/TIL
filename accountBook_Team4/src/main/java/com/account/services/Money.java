package com.account.services;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.account.bean.AccessBean;
import com.account.bean.MoneyBean;
import com.account.db.AccountBookRule;
import com.account.utils.ProjectUtils;

@Service
public class Money implements AccountBookRule{
	/* 세션 */
	@Autowired
	private ProjectUtils session;
	/* DB 접근 */
	@Autowired
	private SqlSessionTemplate sql;
	
	@Autowired
	private Setting st;
	
	public Money() {}

	@Override
	public void backController(ModelAndView mav, int num) {
		switch(num) {
		case 0: this.entrance(mav); 
		break;
		case 1: this.entrance2(mav); 
		break;
		default:
		
		}
	}


	@Override
	public void backController(Model model, int num) {
		switch(num) {
		case 0 : this.changeMinBg(model);
		break;
		case 1 : this.changeTotalBg(model);
			break;
		case 2 : this.delMoneyCa(model);
			break;
		case 3 : this.insMoneyCa(model);
			break;
		case 4 : this.updMoneyCa(model);
	break;
		default:
		}
	}
	


	@Transactional
	private void entrance(ModelAndView mav) {
		// 지수 - 달력에서 선택한 달이 현재 달과 같을때
		// 설화 - 로그인시 사용자의 지정테마를 불러오기
		this.st.backController(mav, 2);
		MoneyBean mb = (MoneyBean)mav.getModel().get("moneyBean");
		/* 지수 - 예산설정 페이지의 카테고리목록, 총예산설정금액, 현재 총 사용금액 불러오기*/
		HashMap<String,String> map = new HashMap<String,String>();

		try {
			// 지수 - 예산 카테고리 별 정보 불러오기
			// MMCODE 맵에 넣음
			map.put("MMCODE", ((AccessBean)this.session.getAttribute("accessInfo")).getMMCODE());
			// MONTH 맵에 넣음
			map.put("MONTH", mb.getMONTH());
			// 한번이라도 inout에 기록된 예산카테고리 리스트+한번도 기록안된 에산카테고리 리스트
			mav.addObject("moList", this.makeMoList(this.sql.selectList("getMoList",map),map)+this.makeNMoList(this.sql.selectList("getNMoList"),map));
			// 지수 - Max 예산금액, Min 예산금액 ,지금까지 사용한 총 예산금액 가져오기 
			mav.addObject("MaxBudget",this.sql.selectOne("getMaxBudget",map));
			mav.addObject("MinBudget",this.sql.selectOne("getMinBudget",map));
			mav.addObject("totalSpendBudget",this.sql.selectOne("getTotalSpendBudget",map));
		} catch (Exception e) {e.printStackTrace();
		}
		mav.setViewName("money");
	}
	
	@Transactional
	private void entrance2(ModelAndView mav) {
		// 지수 - 달력에서 선택한 달이 현재 달과 다를때
		// 지수 - 예산 카테고리 별 정보 불러오기
		HashMap<String,String> map = new HashMap<String,String>();
		MoneyBean mb = (MoneyBean)mav.getModel().get("moneyBean");


		try {
			// MMCODE 맵에 넣음
			map.put("MMCODE", ((AccessBean)this.session.getAttribute("accessInfo")).getMMCODE());
			//MONTH 맵에 넣음
			map.put("MONTH", mb.getMONTH());
			// 선택한 달에 사용한 총 예산항목과 그에따른 예산금액
			mav.addObject("moList", this.makeOldMoList(this.sql.selectList("getMoList",map),map));
			mav.addObject("MONTH",mb.getMONTH());
			mav.addObject("totalSpendBudget",this.sql.selectOne("getTotalSpendBudget",map));
			mav.setViewName("money2");
		} catch (Exception e) {
			e.printStackTrace();}
	}
	
	@Transactional
	private void entrance(Model model, HashMap map) {
		/* 지수 - 예산설정 페이지의 카테고리목록, 총예산설정금액, 현재 총 사용금액 불러오기*/
		MoneyBean mb = (MoneyBean)model.getAttribute("moneyBean");
		try {
			// 지수 - 예산 카테고리 별 정보 불러오기
			// MMCODE 맵에 넣음
			map.put("MMCODE", mb.getMMCODE());
			// 한번이라도 inout에 기록된 예산카테고리 리스트+한번도 기록안된 에산카테고리 리스트
			map.put("moList", this.makeMoList(this.sql.selectList("getMoList",map),map)+this.makeNMoList(this.sql.selectList("getNMoList"),map));
			// 지수 - Max 예산금액, Min 예산금액 ,지금까지 사용한 총 예산금액 가져오기 
			map.put("MaxBudget",this.sql.selectOne("getMaxBudget",map));
			map.put("MinBudget",this.sql.selectOne("getMinBudget",map));
			map.put("totalSpendBudget",this.sql.selectOne("getTotalSpendBudget",map));

		} catch (Exception e) {e.printStackTrace();
		}
		model.addAttribute("map",map);
	}
	// 지수 - 지금 월이 아닌 예전에 한번이라도 INOUT에 기록된 예산 카테고리 별 정보 불러오기 
	@Transactional
	private String makeOldMoList(List<MoneyBean> moList,HashMap map) {
		StringBuffer sb = new StringBuffer();
		int idx = 1;
		for(MoneyBean mb : moList) {
			sb.append("<div class='old barDiv'  style='margin: 1rem;font-size: 1rem;' >");
			sb.append("<div class='names title'>"+mb.getMONAME()+"</div>");
			sb.append("<div class='names spend'>"+mb.getSPENDMONEY()+"원</div>");
			sb.append("</div>");
		}
		return sb.toString();
		
	}
	// 지수 - 한번이라도 INOUT에 기록된 예산 카테고리 별 정보 불러오기 
	@Transactional
	private String makeMoList(List<MoneyBean> moList,HashMap map) {
		StringBuffer sb = new StringBuffer();
		int idx = 1;
		for(MoneyBean mb : moList) {
			sb.append("<div class='barDiv' onclick=\"changeInfo(\'"+ idx+":"+mb.getMMCODE()+":"+mb.getMOCODE()+":"+mb.getMONAME()+":"+mb.getMOTOTAL()+"\')\" style='margin: 1rem;font-size: 1rem;' >");
			sb.append("<div class='names title'>"+mb.getMONAME()+"</div>");
			sb.append("<div class='names spend'>"+mb.getSPENDMONEY()+"원</div>");
				if(mb.getPERBG()>100) { // 사용값이 예산 설정값을 초과했을때
					sb.append("<progress class=\"overbar\" value=\""+mb.getPERBG()+"\" max=\"100\" id=\"lb\"></progress>");
				}else { // 사용값이 예산 설정값을 초과하지 않았을 때
				sb.append("<progress class=\"bar\" value=\""+mb.getPERBG()+"\" max=\"100\" id=\"lb\"></progress>");
				}
			sb.append("<div  class='names budget'>예산 "+mb.getMOTOTAL()+"원</div>");
			sb.append("</div>");
			idx++;
		}
		// childNode 번호 새겨주려고 idx 풋해줌
		map.put("idx", idx);
		return sb.toString();
		
	}
	// 지수 - 아직까지 지출하지 않은 예산카테고리 불러오기
	@Transactional
	private String makeNMoList(List<MoneyBean> selectList,HashMap map) {
		StringBuffer sb = new StringBuffer();

		int idx = (int) map.get("idx");
		for(MoneyBean mb : selectList) {
			sb.append("<div class='barDiv' onclick=\"changeInfo(\'"+ idx+":"+mb.getMMCODE()+":"+mb.getMOCODE()+":"+mb.getMONAME()+":"+mb.getMOTOTAL()+"\')\" style='margin: 1rem;font-size: 1rem;' >");
			sb.append("<div class='names title'>"+mb.getMONAME()+"</div>");
			sb.append("<div class='names spend'>0원</div>");
				if(mb.getPERBG()>100) { // 사용값이 예산 설정값을 초과했을때
					sb.append("<progress class=\"overbar\" value=\""+mb.getPERBG()+"\" max=\"100\" id=\"lb\"></progress>");
				}else { // 사용값이 예산 설정값을 초과하지 않았을 때
				sb.append("<progress class=\"bar\" value=\""+mb.getPERBG()+"\" max=\"100\" id=\"lb\"></progress>");
				}
			sb.append("<div  class='names budget'>예산 "+mb.getMOTOTAL()+"원</div>");
			sb.append("</div>");
			idx++;
		}
		return sb.toString();
	}
	
	// 지수 - 총 예산 설정값 설정하기
	@Transactional
	private void changeTotalBg(Model model) {
		HashMap<String,Object> map = new HashMap<String,Object>();
		MoneyBean mb = ((MoneyBean)model.getAttribute("moneyBean"));
		try {
			//db가서 입력받은 총 예산값으로 현재 총 예산값 변경하기
			map.put("MMCODE", ((AccessBean)this.session.getAttribute("accessInfo")).getMMCODE());
			map.put("TMMAX", mb.getTMMAX());
			map.put("MONTH", mb.getMONTH());
			//새로운 값들을 moneyBean에 가져갈거라서 새로 선언
			MoneyBean nmb = new MoneyBean();
			if(this.convertToBoolean(this.sql.update("updTotalBudget",map))){
				nmb = this.sql.selectOne("getStatus",map);
				nmb.setMessage("성공하였습니다");
				model.addAttribute("moneyBean",nmb);
			}else {
				nmb.setMessage("실패하였습니다");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	// 지수 - 최소예산 변경하기
	private void changeMinBg(Model model) {
		HashMap<String,Object> map = new HashMap<String,Object>();
		MoneyBean mb = ((MoneyBean)model.getAttribute("moneyBean"));
		try {
			//db가서 입력받은 총 예산값으로 현재 총 예산값 변경하기
			map.put("MMCODE", ((AccessBean)this.session.getAttribute("accessInfo")).getMMCODE());
			map.put("TMMIN", mb.getTMMIN());
			map.put("MONTH", mb.getMONTH());
			//새로운 값들을 moneyBean에 가져갈거라서 새로 선언
			MoneyBean nmb = new MoneyBean();
			if(this.convertToBoolean(this.sql.update("updMinBudget",map))){
				nmb = this.sql.selectOne("getStatus",map);
				nmb.setMessage("성공하였습니다");
				model.addAttribute("moneyBean",nmb);
			}else {
				nmb.setMessage("실패하였습니다");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 총예산-현재지출액 값 보내주기
	}
	// 지수 - 예산항목 삭제하기
	@Transactional
	private void delMoneyCa(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		MoneyBean mb = ((MoneyBean)model.getAttribute("moneyBean"));
		String message = null;
		// 삭제하려면 CU에서 먼저 삭제하고 MO에서 삭제해야함
		// 0.먼저 CUSTOMER에서 MOCODE가 사용되고있는지 확인 
		// count로 확인해서 결과값이 0이 아니면 존재하는것
		if(!this.sql.selectOne("isUseCustomer",mb).equals("0")) {
			// 1.존재O
			// 1.1 CU에서 NULL로 바꾸기
			if(this.convertToBoolean(this.sql.update("delMoInCu",mb))) {
				// 1.2 MONEY에서 삭제
				if(this.convertToBoolean(this.sql.delete("delMoneyCa",mb))) {
					message = "성공하였습니다";
					map.put("message", message);
				}else {
					map.put("message", "실패하였습니다");
				}
			}
			else {
				map.put("message", "실패하였습니다");
			}
		}else {
			// 2.존재X
			// 2.1 MONEY에서 삭제
			if(this.convertToBoolean(this.sql.delete("delMoneyCa",mb))) {	
				message = "성공하였습니다";
				map.put("message", message);
			}else {
				map.put("message", "실패하였습니다");
			}
		}
		this.entrance(model, map);
	}
	// 지수 - 예산항목 추가하기
	private void insMoneyCa(Model model) {
		MoneyBean mb = ((MoneyBean)model.getAttribute("moneyBean"));
		HashMap<String,String> map = new HashMap<String,String>();
		try {
			/*db가서 insert하기*/
			// MMCODE 최대값or최초값 가져오기
			mb.setMMCODE((((AccessBean)this.session.getAttribute("accessInfo")).getMMCODE()));
			mb.setMOCODE(this.sql.selectOne("getMoCode",mb));
			if(this.convertToBoolean(this.sql.insert("insMoney",mb))) {
				map.put("message","성공하였습니다");
			}else {				
				map.put("message","실패하였습니다");}
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.entrance(model, map);
	}

	// 지수 - 예산항목 수정하기
	private void updMoneyCa(Model model) {
		MoneyBean mb = ((MoneyBean)model.getAttribute("moneyBean"));
		HashMap<String,String> map = new HashMap<String,String>();

		/* db가서 업데이트 하기 */
		if(this.convertToBoolean(this.sql.update("updMoney",mb))) {
			map.put("messsage","성공했습니다");
		}else {
			map.put("messsage","실패했습니다");
			}
		this.entrance(model, map);
	}

	private boolean convertToBoolean(int number) {
		return number == 0 ? false : true;
	}
}
