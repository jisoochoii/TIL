package com.account.team4;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.account.bean.MoneyBean;
import com.account.bean.SettingBean;
import com.account.services.Money;
import com.account.services.Setting;

@RestController
public class APIController {
	@Autowired
	private Setting setting;
	@Autowired
	private Money money;
	/**************************    SETTING     **************************/
	
	// 지수 - AJAX 방식으로 받은 데이터로 비밀번호 확인하기
	@SuppressWarnings("unchecked")
	@PostMapping("/ConfirmPw")
	public SettingBean confirmPw(Model model, @ModelAttribute SettingBean sb) {
		/* Developer : 지수 */
		model.addAttribute(sb);
		setting.backController(model, 3);
		return (SettingBean)model.getAttribute("settingBean");
	}
	
	// 지수 - AJAX 방식으로 받은 데이터로 비밀번호 변경하기
	@SuppressWarnings("unchecked")
	@PostMapping("/ChangePw")
	public SettingBean changePw(Model model, @ModelAttribute SettingBean sb) {
		/* Developer : 지수 */
		model.addAttribute(sb);
		setting.backController(model, 2);
		return (SettingBean)model.getAttribute("settingBean");
	}
	
	// 슬기 - 거래처 설정
	@SuppressWarnings("unchecked")
	@GetMapping("/CustomerForm")
	public Map<String, Object> setCustomer(Model model, @ModelAttribute SettingBean sb) {
		model.addAttribute(sb);
		this.setting.backController(model, 4);
		
		return (Map<String, Object>) model.getAttribute("CustomerInfo");
	}
	
	// 슬기 - 거래처 수정
	@SuppressWarnings("unchecked")
	@PostMapping("/UpdateCustomer")
	public Map<String, Object> updateCustomer(Model model, @ModelAttribute SettingBean sb) {
		model.addAttribute(sb);
		this.setting.backController(model, 5);
		
		return (Map<String, Object>) model.getAttribute("CustomerInfo");
	}
	
	// 슬기 - 거래처 삭제
	@SuppressWarnings("unchecked")
	@PostMapping("/DeleteCustomer")
	public Map<String, Object> deleteCustomer(Model model, @ModelAttribute SettingBean sb) {
		model.addAttribute(sb);
		this.setting.backController(model, 6);
		
		return (Map<String, Object>) model.getAttribute("CustomerInfo");
	}
	
	// 설화 - 테마 수정
		@PostMapping("/CngTheme")
		public SettingBean cngTheme(Model model, @ModelAttribute SettingBean sb) {
			model.addAttribute(sb);
			this.setting.backController(model, 7);
			return (SettingBean)model.getAttribute("settingBean");
		}

		/**************************    INOUT     **************************/
		
		/**************************    MONEY     **************************/
	// 지수 - AJAX 방식으로 받은 데이터로 총 예산금액 변경하기
	@SuppressWarnings("unchecked")
	@PostMapping("/ChangeTotalBudget")
	public MoneyBean changeTotalBg(Model model, @ModelAttribute MoneyBean mb) {
		/* Developer : 지수 */
		model.addAttribute(mb);
		money.backController(model, 1);
		return (MoneyBean)model.getAttribute("moneyBean");
	}
	@SuppressWarnings("unchecked")
	@PostMapping("/ChangeMinBudget")
	public MoneyBean changeMinBudget(Model model, @ModelAttribute MoneyBean mb) {
		/* Developer : 지수 */
		model.addAttribute(mb);
		money.backController(model, 0);
		return (MoneyBean)model.getAttribute("moneyBean");
	}
	// 지수 - AJAX 방식으로 받은 데이터로 예산항목 삭제하기
	@SuppressWarnings("unchecked")
	@PostMapping("/DelMoney")
	public HashMap<String,Object> delMoney(Model model, @ModelAttribute MoneyBean mb) {
		/* Developer : 지수 */
		model.addAttribute(mb);
		money.backController(model, 2);
		return (HashMap<String,Object>)model.getAttribute("map");
	}
	// 지수 - AJAX 방식으로 받은 데이터로 예산항목 추가하기
	@SuppressWarnings("unchecked")
	@PostMapping("/InsMoney")
	public HashMap<String,Object> insMoney(Model model, @ModelAttribute MoneyBean mb) {
		/* Developer : 지수 */
		model.addAttribute(mb);
		money.backController(model, 3);
		return (HashMap<String,Object>)model.getAttribute("map");
	}
	// 지수 - AJAX 방식으로 받은 데이터로 예산항목 수정하기
	@SuppressWarnings("unchecked")
	@PostMapping("/UpdMoney")
	public HashMap<String,Object> updMoney(Model model, @ModelAttribute MoneyBean mb) {
		/* Developer : 지수 */
		model.addAttribute(mb);
		money.backController(model, 4);
		return (HashMap<String,Object>)model.getAttribute("map");
	}
}
