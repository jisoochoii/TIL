// AJAX -> JSON
let jsonData;

// 설화 - 로그아웃
function logout(){
	let form = document.getElementsByName("serverForm")[0];
	form.action = "AccessOut";
	form.method = "post";
	form.submit();
}

/* INPUT 만들기 */
function createInput(type, obj, place, cla ,value, onClick) {
	let input = document.createElement("input");
	input.setAttribute("type", type);
	input.setAttribute("name", obj);
	input.setAttribute("placeholder", place);
	input.setAttribute("class", cla);
	input.setAttribute("value", value);
	input.setAttribute("onClick", onClick);

	return input;
}

/* 지수 회원가입, 비밀번호변경 시 길이 체크 메서드 */
	
	function isNumberCheck(text){
		let result;
		let typeCount = 0;
		
		const num = /[0-9]/; //숫자
			
		if (num.test(text)) typeCount++;
		
		result = typeCount == 1? true:false;
		
		return result;
	}
	
	function isCharCheck(text, type) {
		let result;
		
		const largeChar = /[A-Z]/; //대문자 
		const smallChar = /[a-z]/; //소문자
		const num = /[0-9]/; //숫자
		const specialChar = /[!@#$%^&*]/; //특수문자
		
		let typeCount = 0;

		if (largeChar.test(text)) typeCount++; 
		if (smallChar.test(text)) typeCount++;
		if (num.test(text)) typeCount++;
		if (specialChar.test(text)) typeCount++;

		if(type){ //비밀번호 3가지 이상 조합 판단
			result = typeCount >= 3? true:false;
		}else{ //이름 한글로만 이루어졌는지 판단
			result = typeCount == 0? true:false;
		}
		return result;
	}
	
	//password, 문자이름체크
	function isCharLengthCheck(text, minimum, maximum) {
		let result = false;
		if (maximum != null) {
			if (text.length >= minimum && text.length <= maximum) result = true;
		}
		else {
			if (text.length >= minimum) result = true;
		}
		return result;
	}

/*********************        AJAX        **********************/

/* AJAX GET */
function getAjaxJson(jobCode, clientData, fn){ //url?key=value
	const ajax = new XMLHttpRequest();
	const action = (clientData != "")? (jobCode + "?" + clientData):jobCode;
	ajax.onreadystatechange = function(){
		if(ajax.readyState == 4 && ajax.status == 200){
			window[fn](ajax.responseText); //function으로 인식하려면 window사용
		}
	};
	
	ajax.open("get", action);
	ajax.send(); 
}

/* AJAX :: POST */
function postAjaxJson(jobCode, clientData, fn){
	const ajax =  new XMLHttpRequest();
	
	ajax.onreadystatechange = function(){
		if(ajax.readyState == 4 && ajax.status == 200){
			window[fn](ajax.responseText);

		}
	};
	
	ajax.open("post", jobCode);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ajax.send(clientData);
}

/* public ip 저장 */
function setPublicIp(ajaxData){
	jsonData = JSON.parse(ajaxData);
}